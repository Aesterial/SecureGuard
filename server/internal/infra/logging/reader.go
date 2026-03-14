package logginginfra

import (
	"context"
	"errors"
	"strings"
	"time"

	logspb "github.com/aesterial/secureguard/internal/api/v1/logs/v1"
	loggingdomain "github.com/aesterial/secureguard/internal/domain/logging"
	"github.com/twmb/franz-go/pkg/kgo"
	"google.golang.org/protobuf/proto"
)

type ReaderConfig struct {
	Enabled        bool
	Brokers        []string
	Topic          string
	ClientID       string
	ReadTimeout    time.Duration
	PollTimeout    time.Duration
	MaxPollRecords int
	MaxEmptyPolls  int
}

type kafkaReader struct {
	brokers        []string
	topic          string
	clientID       string
	readTimeout    time.Duration
	pollTimeout    time.Duration
	maxPollRecords int
	maxEmptyPolls  int
}

func NewReader(cfg ReaderConfig) (loggingdomain.Reader, error) {
	if !cfg.Enabled {
		return nil, nil
	}
	if strings.TrimSpace(cfg.Topic) == "" {
		return nil, errors.New("kafka topic is required")
	}
	if len(cfg.Brokers) == 0 {
		return nil, errors.New("kafka brokers are required")
	}

	if cfg.ReadTimeout <= 0 {
		cfg.ReadTimeout = 5 * time.Second
	}
	if cfg.PollTimeout <= 0 {
		cfg.PollTimeout = 750 * time.Millisecond
	}
	if cfg.MaxPollRecords <= 0 {
		cfg.MaxPollRecords = 256
	}
	if cfg.MaxEmptyPolls <= 0 {
		cfg.MaxEmptyPolls = 3
	}

	return &kafkaReader{
		brokers:        append([]string(nil), cfg.Brokers...),
		topic:          cfg.Topic,
		clientID:       cfg.ClientID,
		readTimeout:    cfg.ReadTimeout,
		pollTimeout:    cfg.PollTimeout,
		maxPollRecords: cfg.MaxPollRecords,
		maxEmptyPolls:  cfg.MaxEmptyPolls,
	}, nil
}

func (r *kafkaReader) Read(ctx context.Context, query loggingdomain.Query) ([]loggingdomain.Entry, error) {
	if ctx == nil {
		ctx = context.Background()
	}

	readCtx, cancel := context.WithTimeout(ctx, r.readTimeout)
	defer cancel()

	client, err := r.newClient(query)
	if err != nil {
		return nil, err
	}
	defer client.Close()

	limit := query.Limit
	if limit <= 0 {
		limit = r.maxPollRecords * r.maxEmptyPolls
	}

	entries := make([]loggingdomain.Entry, 0, limit)
	emptyPolls := 0

	for {
		if err := readCtx.Err(); err != nil {
			if errors.Is(err, context.DeadlineExceeded) {
				return entries, nil
			}
			return nil, err
		}

		pollCtx, pollCancel := context.WithTimeout(readCtx, r.pollTimeout)
		fetches := client.PollRecords(pollCtx, r.maxPollRecords)
		pollCancel()

		if fetches.IsClientClosed() {
			return entries, nil
		}

		var fetchErr error
		fetches.EachError(func(_ string, _ int32, err error) {
			if fetchErr != nil {
				return
			}
			if errors.Is(err, context.Canceled) || errors.Is(err, context.DeadlineExceeded) {
				return
			}
			fetchErr = err
		})
		if fetchErr != nil {
			return nil, fetchErr
		}

		receivedRecords := false
		iter := fetches.RecordIter()
		for !iter.Done() {
			receivedRecords = true
			record := iter.Next()
			entry, ok := decodeEntry(record)
			if !ok || !query.Matches(entry) {
				continue
			}
			entries = append(entries, entry)
			if len(entries) >= limit {
				return entries, nil
			}
		}

		if receivedRecords {
			emptyPolls = 0
			continue
		}

		emptyPolls++
		if emptyPolls >= r.maxEmptyPolls {
			return entries, nil
		}
	}
}

func (r *kafkaReader) Close() error {
	return nil
}

func (r *kafkaReader) newClient(query loggingdomain.Query) (*kgo.Client, error) {
	offset := kgo.NewOffset().AtStart()
	if !query.Since.IsZero() {
		offset = kgo.NewOffset().AfterMilli(query.Since.UTC().UnixMilli())
	}

	opts := []kgo.Opt{
		kgo.SeedBrokers(r.brokers...),
		kgo.ConsumeTopics(r.topic),
		kgo.ConsumeResetOffset(offset),
	}
	if r.clientID != "" {
		opts = append(opts, kgo.ClientID(r.clientID+"-reader"))
	}
	return kgo.NewClient(opts...)
}

func decodeEntry(record *kgo.Record) (loggingdomain.Entry, bool) {
	if record == nil || len(record.Value) == 0 {
		return loggingdomain.Entry{}, false
	}

	var payload logspb.KafkaLogEntry
	if err := proto.Unmarshal(record.Value, &payload); err != nil {
		return loggingdomain.Entry{}, false
	}

	timestamp := record.Timestamp.UTC()
	if payload.GetTimestamp() != nil {
		timestamp = payload.GetTimestamp().AsTime().UTC()
	}

	fields := payload.GetFields()
	if len(fields) == 0 {
		fields = nil
	}

	return loggingdomain.Entry{
		Timestamp: timestamp,
		Service:   payload.GetService(),
		Level:     loggingdomain.ParseLevel(payload.GetLevel()),
		Message:   payload.GetMessage(),
		Fields:    fields,
	}, true
}
