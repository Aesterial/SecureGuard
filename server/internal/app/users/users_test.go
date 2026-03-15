package usersapp

import (
	"context"
	"database/sql"
	"errors"
	"testing"
	"time"

	userpb "github.com/aesterial/secureguard/internal/api/v1/users/v1"
	"github.com/aesterial/secureguard/internal/domain"
	usersdomain "github.com/aesterial/secureguard/internal/domain/users"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
)

type usersRepoMock struct {
	getByIDFn          func(context.Context, domain.UUID) (*usersdomain.User, error)
	getByIDsFn         func(context.Context, int32, ...domain.UUID) (usersdomain.Users, error)
	isExistsFn         func(context.Context, domain.UUID) (bool, error)
	isUsernameExistsFn func(context.Context, string) (bool, error)
	changeCryptFn      func(context.Context, domain.UUID, usersdomain.Crypt) error
	changeLangFn       func(context.Context, domain.UUID, usersdomain.Language) error
	changeThemeFn      func(context.Context, domain.UUID, usersdomain.Theme) error
	isAdminFn          func(context.Context, domain.UUID) (bool, error)
}

func (m *usersRepoMock) GetByID(ctx context.Context, target domain.UUID) (*usersdomain.User, error) {
	if m.getByIDFn != nil {
		return m.getByIDFn(ctx, target)
	}
	return nil, nil
}
func (m *usersRepoMock) GetByUsername(context.Context, string) (*usersdomain.User, error) {
	return nil, nil
}
func (m *usersRepoMock) GetByIDs(ctx context.Context, limit int32, targets ...domain.UUID) (usersdomain.Users, error) {
	if m.getByIDsFn != nil {
		return m.getByIDsFn(ctx, limit, targets...)
	}
	return nil, nil
}
func (m *usersRepoMock) GetList(context.Context, int32, int32) (usersdomain.Users, error) {
	return nil, nil
}
func (m *usersRepoMock) GetPassword(context.Context, domain.UUID) (string, error) {
	return "", nil
}
func (m *usersRepoMock) GetPasswordByUsername(context.Context, string) (string, error) {
	return "", nil
}
func (m *usersRepoMock) IsExists(ctx context.Context, target domain.UUID) (bool, error) {
	if m.isExistsFn != nil {
		return m.isExistsFn(ctx, target)
	}
	return false, nil
}
func (m *usersRepoMock) IsUserAdmin(ctx context.Context, target domain.UUID) (bool, error) {
	if m.isAdminFn != nil {
		return m.isAdminFn(ctx, target)
	}
	return false, nil
}
func (m *usersRepoMock) IsUsernameExists(ctx context.Context, username string) (bool, error) {
	if m.isUsernameExistsFn != nil {
		return m.isUsernameExistsFn(ctx, username)
	}
	return false, nil
}
func (m *usersRepoMock) ChangeCrypt(ctx context.Context, target domain.UUID, set usersdomain.Crypt) error {
	if m.changeCryptFn != nil {
		return m.changeCryptFn(ctx, target, set)
	}
	return nil
}
func (m *usersRepoMock) ChangeTheme(ctx context.Context, target domain.UUID, set usersdomain.Theme) error {
	if m.changeThemeFn != nil {
		return m.changeThemeFn(ctx, target, set)
	}
	return nil
}
func (m *usersRepoMock) ChangeLanguage(ctx context.Context, target domain.UUID, set usersdomain.Language) error {
	if m.changeLangFn != nil {
		return m.changeLangFn(ctx, target, set)
	}
	return nil
}
func (m *usersRepoMock) ChangePhrase(context.Context, domain.UUID, string) error {
	return nil
}
func (m *usersRepoMock) Create(context.Context, string, string, string) (*usersdomain.User, error) {
	return nil, nil
}

func newUsersUUID() domain.UUID {
	return domain.ParseUUID(uuid.New())
}

func TestIsUsernameExistsValidationAndLowercase(t *testing.T) {
	service := NewUserService(&usersRepoMock{})
	if _, err := service.IsUsernameExists(context.Background(), "ab"); !errors.Is(err, apperrors.InvalidArguments) {
		t.Fatalf("expected invalid arguments, got %v", err)
	}

	var captured string
	service = NewUserService(&usersRepoMock{
		isUsernameExistsFn: func(_ context.Context, username string) (bool, error) {
			captured = username
			return true, nil
		},
	})
	ok, err := service.IsUsernameExists(context.Background(), "TeSTUser")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !ok {
		t.Fatalf("expected true result")
	}
	if captured != "testuser" {
		t.Fatalf("expected lowercased username, got %q", captured)
	}
}

func TestIsExistsHandlesSqlNoRowsAsFalse(t *testing.T) {
	service := NewUserService(&usersRepoMock{
		isExistsFn: func(context.Context, domain.UUID) (bool, error) {
			return false, sql.ErrNoRows
		},
	})

	exists, err := service.IsExists(context.Background(), newUsersUUID())
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if exists {
		t.Fatalf("expected false")
	}
}

func TestGetByIDNotFoundWhenUserDoesNotExist(t *testing.T) {
	service := NewUserService(&usersRepoMock{
		isExistsFn: func(context.Context, domain.UUID) (bool, error) {
			return false, nil
		},
	})

	_, err := service.GetByID(context.Background(), newUsersUUID())
	if !errors.Is(err, apperrors.NotFound) {
		t.Fatalf("expected not found, got %v", err)
	}
}

func TestGetByIDSuccess(t *testing.T) {
	userID := newUsersUUID()
	expected := &usersdomain.User{ID: userID, Username: "tester", Joined: time.Now().UTC()}

	service := NewUserService(&usersRepoMock{
		isExistsFn: func(context.Context, domain.UUID) (bool, error) {
			return true, nil
		},
		getByIDFn: func(context.Context, domain.UUID) (*usersdomain.User, error) {
			return expected, nil
		},
	})

	got, err := service.GetByID(context.Background(), userID)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if got == nil || got.ID != expected.ID {
		t.Fatalf("unexpected user: %#v", got)
	}
}

func TestGetByIDsMapsNoRowsToNotFound(t *testing.T) {
	service := NewUserService(&usersRepoMock{
		getByIDsFn: func(context.Context, int32, ...domain.UUID) (usersdomain.Users, error) {
			return nil, pgx.ErrNoRows
		},
	})

	_, err := service.GetByIDs(context.Background(), 10, newUsersUUID())
	if !errors.Is(err, apperrors.NotFound) {
		t.Fatalf("expected not found, got %v", err)
	}
}

func TestChangeMethodsMapNoRows(t *testing.T) {
	id := newUsersUUID()
	service := NewUserService(&usersRepoMock{
		changeCryptFn: func(context.Context, domain.UUID, usersdomain.Crypt) error { return pgx.ErrNoRows },
		changeLangFn:  func(context.Context, domain.UUID, usersdomain.Language) error { return pgx.ErrNoRows },
		changeThemeFn: func(context.Context, domain.UUID, usersdomain.Theme) error { return pgx.ErrNoRows },
	})

	if err := service.ChangeCrypt(context.Background(), id, userpb.Crypt_CRYPT_SHA256); !errors.Is(err, apperrors.NotFound) {
		t.Fatalf("expected not found for crypt, got %v", err)
	}
	if err := service.ChangeLanguage(context.Background(), id, userpb.Language_LANGUAGE_EN); !errors.Is(err, apperrors.NotFound) {
		t.Fatalf("expected not found for language, got %v", err)
	}
	if err := service.ChangeTheme(context.Background(), id, userpb.Theme_THEME_BLACK); !errors.Is(err, apperrors.InvalidArguments) {
		t.Fatalf("expected invalid arguments for theme, got %v", err)
	}
}

func TestChangeMethodsRejectUnspecified(t *testing.T) {
	service := NewUserService(&usersRepoMock{})
	id := newUsersUUID()
	if err := service.ChangeCrypt(context.Background(), id, userpb.Crypt_CRYPT_UNSPECIFIED); !errors.Is(err, apperrors.InvalidArguments) {
		t.Fatalf("expected invalid arguments, got %v", err)
	}
	if err := service.ChangeLanguage(context.Background(), id, userpb.Language_LANGUAGE_UNSPECIFIED); !errors.Is(err, apperrors.InvalidArguments) {
		t.Fatalf("expected invalid arguments, got %v", err)
	}
	if err := service.ChangeTheme(context.Background(), id, userpb.Theme_THEME_UNSPECIFIED); !errors.Is(err, apperrors.InvalidArguments) {
		t.Fatalf("expected invalid arguments, got %v", err)
	}
}

func TestIsAdminPassThrough(t *testing.T) {
	id := newUsersUUID()
	service := NewUserService(&usersRepoMock{
		isAdminFn: func(context.Context, domain.UUID) (bool, error) { return true, nil },
	})

	ok, err := service.IsAdmin(context.Background(), id)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !ok {
		t.Fatalf("expected admin true")
	}
}
