package loginapp

import (
	"context"
	"errors"
	"testing"

	sessionsapp "github.com/aesterial/secureguard/internal/app/sessions"
	"github.com/aesterial/secureguard/internal/domain"
	logindomain "github.com/aesterial/secureguard/internal/domain/login"
	sessionsdomain "github.com/aesterial/secureguard/internal/domain/sessions"
	usersdomain "github.com/aesterial/secureguard/internal/domain/users"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
)

type loginUsersRepoMock struct {
	createFn                func(context.Context, string, string, string) (*usersdomain.User, error)
	getPasswordByUsernameFn func(context.Context, string) (string, error)
	getByUsernameFn         func(context.Context, string) (*usersdomain.User, error)
}

func (m *loginUsersRepoMock) GetByID(context.Context, domain.UUID) (*usersdomain.User, error) {
	return nil, nil
}
func (m *loginUsersRepoMock) GetByUsername(ctx context.Context, target string) (*usersdomain.User, error) {
	if m.getByUsernameFn != nil {
		return m.getByUsernameFn(ctx, target)
	}
	return nil, nil
}
func (m *loginUsersRepoMock) GetByIDs(context.Context, int32, ...domain.UUID) (usersdomain.Users, error) {
	return nil, nil
}
func (m *loginUsersRepoMock) GetList(context.Context, int32, int32) (usersdomain.Users, error) {
	return nil, nil
}
func (m *loginUsersRepoMock) GetPassword(context.Context, domain.UUID) (string, error) {
	return "", nil
}
func (m *loginUsersRepoMock) GetPasswordByUsername(ctx context.Context, username string) (string, error) {
	if m.getPasswordByUsernameFn != nil {
		return m.getPasswordByUsernameFn(ctx, username)
	}
	return "", nil
}
func (m *loginUsersRepoMock) IsExists(context.Context, domain.UUID) (bool, error) {
	return false, nil
}
func (m *loginUsersRepoMock) IsUserAdmin(context.Context, domain.UUID) (bool, error) {
	return false, nil
}
func (m *loginUsersRepoMock) IsUsernameExists(context.Context, string) (bool, error) {
	return false, nil
}
func (m *loginUsersRepoMock) ChangeCrypt(context.Context, domain.UUID, usersdomain.Crypt) error {
	return nil
}
func (m *loginUsersRepoMock) ChangeTheme(context.Context, domain.UUID, usersdomain.Theme) error {
	return nil
}
func (m *loginUsersRepoMock) ChangeLanguage(context.Context, domain.UUID, usersdomain.Language) error {
	return nil
}
func (m *loginUsersRepoMock) ChangePhrase(context.Context, domain.UUID, string) error {
	return nil
}
func (m *loginUsersRepoMock) Create(ctx context.Context, username string, passwordHash, seedHash string) (*usersdomain.User, error) {
	if m.createFn != nil {
		return m.createFn(ctx, username, passwordHash, seedHash)
	}
	return nil, nil
}

type loginSessionsRepoMock struct {
	createFn func(context.Context, domain.UUID, string) (*domain.UUID, error)
}

func (m *loginSessionsRepoMock) GetOwner(context.Context, domain.UUID) (*domain.UUID, error) {
	return nil, nil
}
func (m *loginSessionsRepoMock) GetInfo(context.Context, domain.UUID) (*sessionsdomain.Session, error) {
	return nil, nil
}
func (m *loginSessionsRepoMock) IsExists(context.Context, domain.UUID) (bool, error) {
	return false, nil
}
func (m *loginSessionsRepoMock) Create(ctx context.Context, owner domain.UUID, hash string) (*domain.UUID, error) {
	if m.createFn != nil {
		return m.createFn(ctx, owner, hash)
	}
	return nil, nil
}
func (m *loginSessionsRepoMock) Revoke(context.Context, domain.UUID) error {
	return nil
}

func (m *loginSessionsRepoMock) GetExpired(ctx context.Context) ([]*domain.UUID, error) {
	return nil, nil
}

func newLoginUUID() domain.UUID {
	return domain.ParseUUID(uuid.New())
}

func TestRegisterUsesNormalizedUsername(t *testing.T) {
	userID := newLoginUUID()
	sessionID := newLoginUUID()
	var capturedUsername string

	usersRepo := &loginUsersRepoMock{
		createFn: func(_ context.Context, username string, passwordHash, seedHash string) (*usersdomain.User, error) {
			capturedUsername = username
			if passwordHash == "" || seedHash == "" {
				t.Fatalf("expected hashes to be non-empty")
			}
			return &usersdomain.User{ID: userID}, nil
		},
	}
	sessionsRepo := &loginSessionsRepoMock{
		createFn: func(_ context.Context, owner domain.UUID, hash string) (*domain.UUID, error) {
			if owner != userID {
				t.Fatalf("unexpected owner passed to session create")
			}
			if hash != "device-hash" {
				t.Fatalf("unexpected client hash: %q", hash)
			}
			return &sessionID, nil
		},
	}

	service := NewLoginService(usersRepo, sessionsapp.NewSessionService(sessionsRepo))
	req := logindomain.RegisterRequire{
		Require: logindomain.Require{
			Username: "abcDEF123!!!",
			Password: "password-123",
		},
		Phrase: "seed-phrase",
	}

	gotUserID, gotSessionID, err := service.Register(context.Background(), req, "device-hash")
	if err != nil {
		t.Fatalf("Register returned error: %v", err)
	}
	if gotUserID == nil || *gotUserID != userID {
		t.Fatalf("unexpected user id: %v", gotUserID)
	}
	if gotSessionID == nil || *gotSessionID != sessionID {
		t.Fatalf("unexpected session id: %v", gotSessionID)
	}
	if capturedUsername != "abc123" {
		t.Fatalf("expected normalized username abc123, got %q", capturedUsername)
	}
}

func TestRegisterInvalidRequire(t *testing.T) {
	service := NewLoginService(&loginUsersRepoMock{}, sessionsapp.NewSessionService(&loginSessionsRepoMock{}))
	_, _, err := service.Register(context.Background(), logindomain.RegisterRequire{}, "hash")
	if !errors.Is(err, apperrors.InvalidArguments) {
		t.Fatalf("expected invalid arguments, got %v", err)
	}
}

func TestAuthorizeWrongPassword(t *testing.T) {
	hash, err := bcrypt.GenerateFromPassword([]byte("correct-password"), bcrypt.DefaultCost)
	if err != nil {
		t.Fatalf("failed to generate hash: %v", err)
	}

	usersRepo := &loginUsersRepoMock{
		getPasswordByUsernameFn: func(_ context.Context, username string) (string, error) {
			if username != "tester" {
				t.Fatalf("unexpected username: %s", username)
			}
			return string(hash), nil
		},
	}
	service := NewLoginService(usersRepo, sessionsapp.NewSessionService(&loginSessionsRepoMock{}))

	_, _, err = service.Authorize(context.Background(), logindomain.AuthorizeRequire{
		Require: logindomain.Require{Username: "tester", Password: "wrong-password"},
	}, "hash")
	if !errors.Is(err, apperrors.AccessDenied) {
		t.Fatalf("expected access denied, got %v", err)
	}
}

func TestAuthorizeSuccess(t *testing.T) {
	userID := newLoginUUID()
	sessionID := newLoginUUID()
	hash, err := bcrypt.GenerateFromPassword([]byte("correct-password"), bcrypt.DefaultCost)
	if err != nil {
		t.Fatalf("failed to generate hash: %v", err)
	}

	usersRepo := &loginUsersRepoMock{
		getPasswordByUsernameFn: func(context.Context, string) (string, error) {
			return string(hash), nil
		},
		getByUsernameFn: func(context.Context, string) (*usersdomain.User, error) {
			return &usersdomain.User{ID: userID}, nil
		},
	}
	sessionsRepo := &loginSessionsRepoMock{
		createFn: func(context.Context, domain.UUID, string) (*domain.UUID, error) {
			return &sessionID, nil
		},
	}

	service := NewLoginService(usersRepo, sessionsapp.NewSessionService(sessionsRepo))
	gotUserID, gotSessionID, err := service.Authorize(context.Background(), logindomain.AuthorizeRequire{
		Require: logindomain.Require{Username: "tester", Password: "correct-password"},
	}, "device-hash")
	if err != nil {
		t.Fatalf("Authorize returned error: %v", err)
	}
	if gotUserID == nil || *gotUserID != userID {
		t.Fatalf("unexpected user id: %v", gotUserID)
	}
	if gotSessionID == nil || *gotSessionID != sessionID {
		t.Fatalf("unexpected session id: %v", gotSessionID)
	}
}
