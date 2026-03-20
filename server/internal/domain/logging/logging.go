package loggingdomain

import (
	"context"
	"errors"
	"fmt"
	"slices"
	"strings"
	"time"
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

func ParseLevel(raw string) Level {
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

type Entry struct {
	Timestamp time.Time
	Service   string
	Level     Level
	Message   string
	Fields    map[string]string
}

func NewEntry(timestamp time.Time, service string, level Level, message string, fields ...Field) Entry {
	if timestamp.IsZero() {
		timestamp = time.Now().UTC()
	} else {
		timestamp = timestamp.UTC()
	}
	service = strings.TrimSpace(service)
	if service == "" {
		service = "global"
	}
	return Entry{
		Timestamp: timestamp,
		Service:   service,
		Level:     level,
		Message:   message,
		Fields:    NormalizeFields(fields),
	}
}

func (e Entry) Field(key string) (string, bool) {
	if e.Fields == nil {
		return "", false
	}
	value, ok := e.Fields[key]
	return value, ok
}

type Query struct {
	Since   time.Time
	Until   time.Time
	Service string
	Message string
	Levels  []Level
	Fields  map[string]string
	Limit   int
}

func (q Query) Matches(entry Entry) bool {
	if !q.Since.IsZero() && entry.Timestamp.Before(q.Since) {
		return false
	}
	if !q.Until.IsZero() && entry.Timestamp.After(q.Until) {
		return false
	}
	if service := strings.TrimSpace(q.Service); service != "" && entry.Service != service {
		return false
	}
	if message := strings.TrimSpace(q.Message); message != "" && entry.Message != message {
		return false
	}
	if len(q.Levels) > 0 {
		matchedLevel := slices.Contains(q.Levels, entry.Level)
		if !matchedLevel {
			return false
		}
	}
	for key, expected := range q.Fields {
		actual, ok := entry.Field(key)
		if !ok || actual != expected {
			return false
		}
	}
	return true
}

type Logger interface {
	Info(message string, fields ...Field)
	Warn(message string, fields ...Field)
	Error(message string, fields ...Field)
	Critical(message string, fields ...Field)
	Close() error
}

type Reader interface {
	Read(ctx context.Context, query Query) ([]Entry, error)
	Close() error
}

var ErrReaderDisabled = errors.New("logging reader is disabled")

func NormalizeFields(fields []Field) map[string]string {
	if len(fields) == 0 {
		return nil
	}

	out := make(map[string]string, len(fields))
	for _, field := range fields {
		key := strings.TrimSpace(field.Key)
		if key == "" {
			continue
		}
		out[key] = FormatValue(field.Value)
	}
	if len(out) == 0 {
		return nil
	}
	return out
}

func FormatValue(value any) string {
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
