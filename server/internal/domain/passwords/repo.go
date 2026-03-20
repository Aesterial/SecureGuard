package passdomain

import (
	"context"

	"github.com/aesterial/secureguard/internal/domain"
)

type Repository interface {
	GetList(ctx context.Context, target domain.UUID, limit int32, offset int32) (Passwords, error)
	GetOwner(ctx context.Context, id domain.UUID) (*domain.UUID, error)
	Create(ctx context.Context, target domain.UUID, service string, login string, pass string, version int32, aad []byte, nonce string, metadata []byte) (*Password, error)
	Update(ctx context.Context, target domain.UUID, update Target, value string, salt string) (*Password, error)
	Delete(ctx context.Context, id domain.UUID) error
}
