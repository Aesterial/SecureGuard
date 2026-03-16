package sessionsdomain

import (
	"context"

	"github.com/aesterial/secureguard/internal/domain"
)

type Repository interface {
	GetOwner(ctx context.Context, id domain.UUID) (*domain.UUID, error)
	GetInfo(ctx context.Context, id domain.UUID) (*Session, error)
	GetExpired(ctx context.Context) ([]*domain.UUID, error)
	IsExists(ctx context.Context, id domain.UUID) (bool, error)
	Create(ctx context.Context, owner domain.UUID, hash string) (*domain.UUID, error)
	Revoke(ctx context.Context, id domain.UUID) error
}
