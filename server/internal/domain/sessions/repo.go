package sessionsdomain

import (
	"context"

	"github.com/aesterial/secureguard/internal/domain"
)

type Repository interface {
	GetOwner(ctx context.Context, id domain.UUID) (*domain.UUID, error)
	GetInfo(ctx context.Context, id domain.UUID) (*Session, error)
	Create(ctx context.Context, owner domain.UUID) (*domain.UUID, error)
}
