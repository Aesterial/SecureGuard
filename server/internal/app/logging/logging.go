package loggingapp

import (
	"context"
	"errors"
	"strconv"
	"strings"
	"sync"
	"time"

	loggingdomain "github.com/aesterial/secureguard/internal/domain/logging"
	logginginfra "github.com/aesterial/secureguard/internal/infra/logging"
)

type Field = loggingdomain.Field
type Level = loggingdomain.Level
type Entry = loggingdomain.Entry
type Query = loggingdomain.Query
type Logger = loggingdomain.Logger
type Reader = loggingdomain.Reader

const (
	LevelInfo     = loggingdomain.LevelInfo
	LevelWarn     = loggingdomain.LevelWarn
	LevelError    = loggingdomain.LevelError
	LevelCritical = loggingdomain.LevelCritical
)

var ErrReaderDisabled = loggingdomain.ErrReaderDisabled

func F(key string, value any) Field {
	return loggingdomain.F(key, value)
}

type Config struct {
	Service string
	Level   string
	Kafka   KafkaConfig
}

type KafkaConfig struct {
	Enabled        bool
	Brokers        []string
	Topic          string
	ClientID       string
	WriteTimeout   time.Duration
	ReadTimeout    time.Duration
	PollTimeout    time.Duration
	MaxPollRecords int
	MaxEmptyPolls  int
}

type RequestDurationsQuery struct {
	Query  Query
	Method string
}

type Service struct {
	logger Logger
	reader Reader
}

func New(cfg Config) (*Service, error) {
	logger, err := logginginfra.NewLogger(logginginfra.Config{
		Service: cfg.Service,
		Level:   cfg.Level,
		Kafka: logginginfra.KafkaWriterConfig{
			Enabled:      cfg.Kafka.Enabled,
			Brokers:      cfg.Kafka.Brokers,
			Topic:        cfg.Kafka.Topic,
			ClientID:     cfg.Kafka.ClientID,
			WriteTimeout: cfg.Kafka.WriteTimeout,
		},
	})
	if err != nil {
		return nil, err
	}

	reader, err := logginginfra.NewReader(logginginfra.ReaderConfig{
		Enabled:        cfg.Kafka.Enabled,
		Brokers:        cfg.Kafka.Brokers,
		Topic:          cfg.Kafka.Topic,
		ClientID:       cfg.Kafka.ClientID,
		ReadTimeout:    cfg.Kafka.ReadTimeout,
		PollTimeout:    cfg.Kafka.PollTimeout,
		MaxPollRecords: cfg.Kafka.MaxPollRecords,
		MaxEmptyPolls:  cfg.Kafka.MaxEmptyPolls,
	})
	if err != nil {
		_ = logger.Close()
		return nil, err
	}

	return &Service{
		logger: logger,
		reader: reader,
	}, nil
}

func (s *Service) Info(message string, fields ...Field) {
	s.logger.Info(message, fields...)
}

func (s *Service) Warn(message string, fields ...Field) {
	s.logger.Warn(message, fields...)
}

func (s *Service) Error(message string, fields ...Field) {
	s.logger.Error(message, fields...)
}

func (s *Service) Critical(message string, fields ...Field) {
	s.logger.Critical(message, fields...)
}

func (s *Service) ReadEntries(ctx context.Context, query Query) ([]Entry, error) {
	if s == nil || s.reader == nil {
		return nil, ErrReaderDisabled
	}
	return s.reader.Read(ctx, query)
}

func (s *Service) RequestDurations(ctx context.Context, query RequestDurationsQuery) ([]time.Duration, error) {
	readQuery := query.Query
	if strings.TrimSpace(readQuery.Message) == "" {
		readQuery.Message = "grpc request handled"
	}
	if method := strings.TrimSpace(query.Method); method != "" {
		if readQuery.Fields == nil {
			readQuery.Fields = make(map[string]string, 1)
		}
		readQuery.Fields["method"] = method
	}

	entries, err := s.ReadEntries(ctx, readQuery)
	if err != nil {
		return nil, err
	}

	durations := make([]time.Duration, 0, len(entries))
	for _, entry := range entries {
		raw, ok := entry.Field("duration_ms")
		if !ok {
			continue
		}
		ms, err := strconv.ParseInt(raw, 10, 64)
		if err != nil {
			continue
		}
		durations = append(durations, time.Duration(ms)*time.Millisecond)
	}
	return durations, nil
}

func (s *Service) Close() error {
	if s == nil {
		return nil
	}
	return errors.Join(
		closeIfNotNil(s.reader),
		closeIfNotNil(s.logger),
	)
}

func closeIfNotNil(closer interface{ Close() error }) error {
	if closer == nil {
		return nil
	}
	return closer.Close()
}

type noopLogger struct{}

func (noopLogger) Info(string, ...Field)     {}
func (noopLogger) Warn(string, ...Field)     {}
func (noopLogger) Error(string, ...Field)    {}
func (noopLogger) Critical(string, ...Field) {}
func (noopLogger) Close() error              { return nil }

type disabledReader struct{}

func (disabledReader) Read(context.Context, Query) ([]Entry, error) {
	return nil, ErrReaderDisabled
}

func (disabledReader) Close() error { return nil }

var (
	defaultMu  sync.RWMutex
	defaultSvc = &Service{
		logger: noopLogger{},
		reader: disabledReader{},
	}
)

func SetDefault(service *Service) {
	if service == nil {
		return
	}
	defaultMu.Lock()
	defaultSvc = service
	defaultMu.Unlock()
}

func Default() *Service {
	defaultMu.RLock()
	defer defaultMu.RUnlock()
	return defaultSvc
}

func Info(message string, fields ...Field) {
	Default().Info(message, fields...)
}

func Warn(message string, fields ...Field) {
	Default().Warn(message, fields...)
}

func Error(message string, fields ...Field) {
	Default().Error(message, fields...)
}

func Critical(message string, fields ...Field) {
	Default().Critical(message, fields...)
}

func ReadEntries(ctx context.Context, query Query) ([]Entry, error) {
	return Default().ReadEntries(ctx, query)
}

func RequestDurations(ctx context.Context, query RequestDurationsQuery) ([]time.Duration, error) {
	return Default().RequestDurations(ctx, query)
}
