package usersdomain

import (
	"context"

	"github.com/aesterial/secureguard/internal/domain"
)

type Repository interface {
	GetByID(ctx context.Context, target domain.UUID) (*User, error)
	GetByUsername(ctx context.Context, target string) (*User, error)
	GetByIDs(ctx context.Context, limit int32, targets ...domain.UUID) (Users, error)
	GetList(ctx context.Context, limit, offset int32) (Users, error)
	GetPassword(ctx context.Context, target domain.UUID) (string, error)
	GetPasswordByUsername(ctx context.Context, username string) (string, error)
	GetUserKey(ctx context.Context, target domain.UUID) (*UserKey, error)
	IsExists(ctx context.Context, target domain.UUID) (bool, error)
	IsUserAdmin(ctx context.Context, target domain.UUID) (bool, error)
	IsUsernameExists(ctx context.Context, username string) (bool, error)
	ChangeCrypt(ctx context.Context, target domain.UUID, set Crypt) error
	ChangeTheme(ctx context.Context, target domain.UUID, set Theme) error
	ChangeLanguage(ctx context.Context, target domain.UUID, set Language) error
	ChangePhrase(ctx context.Context, target domain.UUID, set string) error
	Create(ctx context.Context, username string, passwordHash, seedHash string) (*User, error)
	CreateUserKey(ctx context.Context, target domain.UUID, key string, salt string, kdf KDFparams) error
	ChangeUserKey(ctx context.Context, target domain.UUID, key string, salt string, kdf KDFparams) error
}
