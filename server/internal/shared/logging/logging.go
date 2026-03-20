package logging

import (
	"context"
	"time"

	loggingapp "github.com/aesterial/secureguard/internal/app/logging"
)

type Field = loggingapp.Field
type Level = loggingapp.Level
type Entry = loggingapp.Entry
type Query = loggingapp.Query
type Logger = loggingapp.Logger
type Reader = loggingapp.Reader
type Config = loggingapp.Config
type KafkaConfig = loggingapp.KafkaConfig
type RequestDurationsQuery = loggingapp.RequestDurationsQuery

const (
	LevelInfo     = loggingapp.LevelInfo
	LevelWarn     = loggingapp.LevelWarn
	LevelError    = loggingapp.LevelError
	LevelCritical = loggingapp.LevelCritical
)

var ReaderDisabledErr = loggingapp.ErrReaderDisabled

// F formats given key and value to [loggingdomain.Field]
func F(key string, value any) Field {
	return loggingapp.F(key, value)
}

// New initializes new config service by config
func New(cfg Config) (*loggingapp.Service, error) {
	return loggingapp.New(cfg)
}

// SetDefault sets given service as default
func SetDefault(service *loggingapp.Service) {
	loggingapp.SetDefault(service)
}

// Default returns current default for logging service
func Default() *loggingapp.Service {
	return loggingapp.Default()
}

// Info adds new log with Info level
func Info(message string, fields ...Field) {
	loggingapp.Info(message, fields...)
}

// Warn adds new log with Warn level
func Warn(message string, fields ...Field) {
	loggingapp.Warn(message, fields...)
}

// Error adds new log with Error level
func Error(message string, fields ...Field) {
	loggingapp.Error(message, fields...)
}

// Critical adds new log with Error level
func Critical(message string, fields ...Field) {
	loggingapp.Critical(message, fields...)
}

// ReadEntries receives entries from kafka by given query
// It returns list of Entry
func ReadEntries(ctx context.Context, query Query) ([]Entry, error) {
	return loggingapp.ReadEntries(ctx, query)
}

// RequestDurations receives durations by given entry
// It returns list of [time.Duration]
func RequestDurations(ctx context.Context, query RequestDurationsQuery) ([]time.Duration, error) {
	return loggingapp.RequestDurations(ctx, query)
}
