package ratelimit

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"time"

	ratelimitdomain "github.com/aesterial/secureguard/internal/domain/ratelimit"
	"github.com/redis/go-redis/v9"
)

type Config struct {
	Enabled  bool
	Addr     string
	Password string
	DB       int
	Prefix   string
}

type Service struct {
	enabled bool
	client  *redis.Client
	prefix  string
}

var _ ratelimitdomain.Repository = (*Service)(nil)

var incrWindowScript = redis.NewScript(`
local count = redis.call("INCR", KEYS[1])
if count == 1 then
  redis.call("EXPIRE", KEYS[1], ARGV[1])
end
local ttl = redis.call("TTL", KEYS[1])
return {count, ttl}
`)

func New(ctx context.Context, cfg Config) (*Service, error) {
	service := &Service{
		enabled: cfg.Enabled,
		prefix:  strings.TrimSpace(cfg.Prefix),
	}
	if !service.enabled {
		return service, nil
	}
	if strings.TrimSpace(cfg.Addr) == "" {
		return nil, errors.New("redis address is required")
	}
	if service.prefix == "" {
		service.prefix = "ratelimit"
	}

	client := redis.NewClient(&redis.Options{
		Addr:     cfg.Addr,
		Password: cfg.Password,
		DB:       cfg.DB,
	})
	if err := client.Ping(ctx).Err(); err != nil {
		_ = client.Close()
		return nil, err
	}

	service.client = client
	return service, nil
}

func (s *Service) Close() error {
	if s == nil || s.client == nil {
		return nil
	}
	return s.client.Close()
}

func (s *Service) Allow(ctx context.Context, bucket ratelimitdomain.Bucket, key string, rule ratelimitdomain.Rule) (bool, time.Duration, error) {
	if s == nil || !s.enabled || s.client == nil {
		return true, 0, nil
	}
	if rule.IsZero() {
		return true, 0, nil
	}

	redisKey := fmt.Sprintf("%s:%s:%s", s.prefix, ratelimitdomain.NormalizeKey(string(bucket)), ratelimitdomain.NormalizeKey(key))
	values, err := incrWindowScript.Run(ctx, s.client, []string{redisKey}, int(rule.Window.Seconds())).Result()
	if err != nil {
		return false, 0, err
	}

	parts, ok := values.([]any)
	if !ok || len(parts) != 2 {
		return false, 0, errors.New("unexpected redis limiter response")
	}

	current, ok := parts[0].(int64)
	if !ok {
		return false, 0, errors.New("unexpected redis limiter counter type")
	}
	ttlSeconds, ok := parts[1].(int64)
	if !ok {
		return false, 0, errors.New("unexpected redis limiter ttl type")
	}

	var ttl time.Duration
	if ttlSeconds > 0 {
		ttl = time.Duration(ttlSeconds) * time.Second
	}
	return current <= int64(rule.Limit), ttl, nil
}
