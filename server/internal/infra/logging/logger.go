package logginginfra

import (
	"context"
	"errors"
	"fmt"
	"log"
	"os"
	"sort"
	"strings"
	"time"

	logspb "github.com/aesterial/secureguard/internal/api/v1/logs/v1"
	loggingdomain "github.com/aesterial/secureguard/internal/domain/logging"
	"github.com/twmb/franz-go/pkg/kgo"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type Config struct {
	Service string
	Level   string
	Kafka   KafkaWriterConfig
}

type KafkaWriterConfig struct {
	Enabled      bool
	Brokers      []string
	Topic        string
	ClientID     string
	WriteTimeout time.Duration
}

type structuredLogger struct {
	baseLogger   *log.Logger
	service      string
	minLevel     loggingdomain.Level
	kafkaClient  *kgo.Client
	kafkaTopic   string
	writeTimeout time.Duration
}

func NewLogger(cfg Config) (loggingdomain.Logger, error) {
	logger := &structuredLogger{
		baseLogger:   log.New(os.Stdout, "", 0),
		service:      strings.TrimSpace(cfg.Service),
		minLevel:     loggingdomain.ParseLevel(cfg.Level),
		writeTimeout: cfg.Kafka.WriteTimeout,
	}
	if logger.service == "" {
		logger.service = "global"
	}
	if logger.writeTimeout <= 0 {
		logger.writeTimeout = 3 * time.Second
	}

	if !cfg.Kafka.Enabled {
		return logger, nil
	}
	if strings.TrimSpace(cfg.Kafka.Topic) == "" {
		return nil, errors.New("kafka topic is required")
	}
	if len(cfg.Kafka.Brokers) == 0 {
		return nil, errors.New("kafka brokers are required")
	}

	opts := []kgo.Opt{
		kgo.SeedBrokers(cfg.Kafka.Brokers...),
	}
	if cfg.Kafka.ClientID != "" {
		opts = append(opts, kgo.ClientID(cfg.Kafka.ClientID))
	}

	client, err := kgo.NewClient(opts...)
	if err != nil {
		return nil, err
	}
	logger.kafkaClient = client
	logger.kafkaTopic = cfg.Kafka.Topic

	return logger, nil
}

func (l *structuredLogger) Info(message string, fields ...loggingdomain.Field) {
	l.log(loggingdomain.LevelInfo, message, fields...)
}

func (l *structuredLogger) Warn(message string, fields ...loggingdomain.Field) {
	l.log(loggingdomain.LevelWarn, message, fields...)
}

func (l *structuredLogger) Error(message string, fields ...loggingdomain.Field) {
	l.log(loggingdomain.LevelError, message, fields...)
}

func (l *structuredLogger) Critical(message string, fields ...loggingdomain.Field) {
	l.log(loggingdomain.LevelCritical, message, fields...)
}

func (l *structuredLogger) log(level loggingdomain.Level, message string, fields ...loggingdomain.Field) {
	if level < l.minLevel {
		return
	}

	entry := loggingdomain.NewEntry(time.Now().UTC(), l.service, level, message, fields...)
	l.baseLogger.Println(renderLine(entry))

	if l.kafkaClient == nil {
		return
	}

	rawProto, err := proto.Marshal(encodeEntry(entry))
	if err != nil {
		l.baseLogger.Println(renderLine(loggingdomain.NewEntry(
			time.Now().UTC(),
			l.service,
			loggingdomain.LevelError,
			"failed to marshal protobuf log entry",
			loggingdomain.F("error", err.Error()),
		)))
		return
	}

	ctx, cancel := context.WithTimeout(context.Background(), l.writeTimeout)
	defer cancel()
	result := l.kafkaClient.ProduceSync(ctx, &kgo.Record{
		Topic: l.kafkaTopic,
		Headers: []kgo.RecordHeader{
			{Key: "content-type", Value: []byte("application/protobuf")},
			{Key: "message-type", Value: []byte("xyz.secureguard.v1.logs.v1.KafkaLogEntry")},
		},
		Value: rawProto,
	})
	if err = result.FirstErr(); err != nil {
		l.baseLogger.Println(renderLine(loggingdomain.NewEntry(
			time.Now().UTC(),
			l.service,
			loggingdomain.LevelError,
			"failed to publish log to kafka",
			loggingdomain.F("error", err.Error()),
		)))
	}
}

func (l *structuredLogger) Close() error {
	if l.kafkaClient != nil {
		l.kafkaClient.Close()
	}
	return nil
}

func renderLine(entry loggingdomain.Entry) string {
	line := fmt.Sprintf("[%s]: %s | %s | %s", entry.Level.String(), entry.Service, entry.Message, entry.Timestamp.Format(time.RFC3339Nano))
	if len(entry.Fields) == 0 {
		return line
	}

	keys := make([]string, 0, len(entry.Fields))
	for key := range entry.Fields {
		keys = append(keys, key)
	}
	sort.Strings(keys)

	pairs := make([]string, 0, len(keys))
	for _, key := range keys {
		pairs = append(pairs, fmt.Sprintf("%s=%s", key, entry.Fields[key]))
	}
	return line + " | " + strings.Join(pairs, ", ")
}

func encodeEntry(entry loggingdomain.Entry) *logspb.KafkaLogEntry {
	payload := &logspb.KafkaLogEntry{
		Timestamp: timestamppb.New(entry.Timestamp),
		Service:   entry.Service,
		Level:     entry.Level.String(),
		Message:   entry.Message,
	}
	if len(entry.Fields) > 0 {
		payload.Fields = entry.Fields
	}
	return payload
}
