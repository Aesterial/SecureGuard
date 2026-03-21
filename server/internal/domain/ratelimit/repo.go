package ratelimitdomain

import (
	"context"
	"time"
)

type Repository interface {
	Allow(ctx context.Context, bucket Bucket, key string, rule Rule) (bool, time.Duration, error)
}
