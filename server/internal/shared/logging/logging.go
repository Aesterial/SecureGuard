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

var ErrReaderDisabled = loggingapp.ErrReaderDisabled

func F(key string, value any) Field {
	return loggingapp.F(key, value)
}

func New(cfg Config) (*loggingapp.Service, error) {
	return loggingapp.New(cfg)
}

func SetDefault(service *loggingapp.Service) {
	loggingapp.SetDefault(service)
}

func Default() *loggingapp.Service {
	return loggingapp.Default()
}

func Info(message string, fields ...Field) {
	loggingapp.Info(message, fields...)
}

func Warn(message string, fields ...Field) {
	loggingapp.Warn(message, fields...)
}

func Error(message string, fields ...Field) {
	loggingapp.Error(message, fields...)
}

func Critical(message string, fields ...Field) {
	loggingapp.Critical(message, fields...)
}

func ReadEntries(ctx context.Context, query Query) ([]Entry, error) {
	return loggingapp.ReadEntries(ctx, query)
}

func RequestDurations(ctx context.Context, query RequestDurationsQuery) ([]time.Duration, error) {
	return loggingapp.RequestDurations(ctx, query)
}
