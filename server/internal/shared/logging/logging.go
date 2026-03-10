package logging

import (
	"context"
	"errors"
	"fmt"
	"log"
	"os"
	"sort"
	"strings"
	"sync"
	"time"

	logspb "github.com/aesterial/secureguard/internal/api/v1/logs/v1"
	"github.com/twmb/franz-go/pkg/kgo"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type Level int

const (
	LevelInfo Level = iota
	LevelWarn
	LevelError
	LevelCritical
)

func (l Level) String() string {
	switch l {
	case LevelInfo:
		return "INFO"
	case LevelWarn:
		return "WARN"
	case LevelError:
		return "ERROR"
	case LevelCritical:
		return "CRITICAL"
	default:
		return "INFO"
	}
}

func parseLevel(raw string) Level {
	switch strings.ToLower(strings.TrimSpace(raw)) {
	case "warn", "warning":
		return LevelWarn
	case "error":
		return LevelError
	case "critical", "fatal":
		return LevelCritical
	default:
		return LevelInfo
	}
}

type Field struct {
	Key   string
	Value any
}

func F(key string, value any) Field {
	return Field{Key: key, Value: value}
}

type Logger interface {
	Info(message string, fields ...Field)
	Warn(message string, fields ...Field)
	Error(message string, fields ...Field)
	Critical(message string, fields ...Field)
	Close() error
}

type Config struct {
	Service string
	Level   string
	Kafka   KafkaConfig
}

type KafkaConfig struct {
	Enabled      bool
	Brokers      []string
	Topic        string
	ClientID     string
	WriteTimeout time.Duration
}

type structuredLogger struct {
	baseLogger   *log.Logger
	service      string
	minLevel     Level
	kafkaClient  *kgo.Client
	kafkaTopic   string
	writeTimeout time.Duration
}

func New(cfg Config) (Logger, error) {
	logger := &structuredLogger{
		baseLogger:   log.New(os.Stdout, "", 0),
		service:      strings.TrimSpace(cfg.Service),
		minLevel:     parseLevel(cfg.Level),
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

func (l *structuredLogger) Info(message string, fields ...Field) {
	l.log(LevelInfo, message, fields...)
}

func (l *structuredLogger) Warn(message string, fields ...Field) {
	l.log(LevelWarn, message, fields...)
}

func (l *structuredLogger) Error(message string, fields ...Field) {
	l.log(LevelError, message, fields...)
}

func (l *structuredLogger) Critical(message string, fields ...Field) {
	l.log(LevelCritical, message, fields...)
}

func (l *structuredLogger) log(level Level, message string, fields ...Field) {
	if level < l.minLevel {
		return
	}

	timestamp := time.Now().UTC()
	tsRaw := timestamp.Format(time.RFC3339Nano)
	protoPayload := &logspb.KafkaLogEntry{
		Timestamp: timestamppb.New(timestamp),
		Service:   l.service,
		Level:     level.String(),
		Message:   message,
	}
	normalizedFields := normalizeFields(fields)
	if len(normalizedFields) > 0 {
		protoPayload.Fields = normalizedFields
	}

	l.baseLogger.Println(renderLine(level.String(), l.service, message, tsRaw, normalizedFields))

	if l.kafkaClient == nil {
		return
	}

	rawProto, err := proto.Marshal(protoPayload)
	if err != nil {
		l.baseLogger.Println(renderLine("ERROR", l.service, "failed to marshal protobuf log entry", time.Now().UTC().Format(time.RFC3339Nano), map[string]string{
			"error": err.Error(),
		}))
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
		l.baseLogger.Println(renderLine("ERROR", l.service, "failed to publish log to kafka", time.Now().UTC().Format(time.RFC3339Nano), map[string]string{
			"error": err.Error(),
		}))
	}
}

func renderLine(level string, service string, message string, timestamp string, fields map[string]string) string {
	line := fmt.Sprintf("[%s]: %s | %s | %s", level, service, message, timestamp)
	if len(fields) == 0 {
		return line
	}

	keys := make([]string, 0, len(fields))
	for key := range fields {
		keys = append(keys, key)
	}
	sort.Strings(keys)

	pairs := make([]string, 0, len(keys))
	for _, key := range keys {
		pairs = append(pairs, fmt.Sprintf("%s=%s", key, fields[key]))
	}
	return line + " | " + strings.Join(pairs, ", ")
}

func normalizeFields(fields []Field) map[string]string {
	if len(fields) == 0 {
		return nil
	}

	out := make(map[string]string, len(fields))
	for _, field := range fields {
		key := strings.TrimSpace(field.Key)
		if key == "" {
			continue
		}
		out[key] = formatValue(field.Value)
	}
	if len(out) == 0 {
		return nil
	}
	return out
}

func formatValue(value any) string {
	switch v := value.(type) {
	case nil:
		return ""
	case string:
		return v
	case fmt.Stringer:
		return v.String()
	case error:
		return v.Error()
	default:
		return fmt.Sprintf("%v", v)
	}
}

func (l *structuredLogger) Close() error {
	if l.kafkaClient != nil {
		l.kafkaClient.Close()
	}
	return nil
}

type noopLogger struct{}

func (n *noopLogger) Info(_ string, _ ...Field)     {}
func (n *noopLogger) Warn(_ string, _ ...Field)     {}
func (n *noopLogger) Error(_ string, _ ...Field)    {}
func (n *noopLogger) Critical(_ string, _ ...Field) {}
func (n *noopLogger) Close() error                  { return nil }

var (
	globalMu sync.RWMutex
	global   Logger = &noopLogger{}
)

func SetDefault(logger Logger) {
	if logger == nil {
		return
	}
	globalMu.Lock()
	global = logger
	globalMu.Unlock()
}

func Default() Logger {
	globalMu.RLock()
	defer globalMu.RUnlock()
	return global
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
