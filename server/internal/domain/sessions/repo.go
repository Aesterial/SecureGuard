package sessionsdomain

import (
	"context"
	"time"

	"github.com/aesterial/secureguard/internal/domain"
)

type Repository interface {
	GetOwner(ctx context.Context, id string) (*domain.UUID, error)
	GetInfo(ctx context.Context, id string) (*Session, error)
	GetExpired(ctx context.Context) ([]string, error)
	IsExists(ctx context.Context, id string) (bool, error)
	Create(ctx context.Context, id string, owner domain.UUID, hash string) (*string, error)
	Revoke(ctx context.Context, id string) error
	SetLastSeen(ctx context.Context, id string, at time.Time) error
	GetListByOwner(ctx context.Context, id domain.UUID, limit int32, offset int32) (Sessions, error)
}
