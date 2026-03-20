package loginapp

import (
	"context"
	"errors"
	"testing"
	"time"

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
	createUserKeyFn         func(context.Context, domain.UUID, string, string, usersdomain.KDFparams) error
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
func (m *loginUsersRepoMock) CreateUserKey(ctx context.Context, target domain.UUID, key string, salt string, kdf usersdomain.KDFparams) error {
	if m.createUserKeyFn != nil {
		return m.createUserKeyFn(ctx, target, key, salt, kdf)
	}
	return nil
}

type loginSessionsRepoMock struct {
	createFn func(context.Context, string, domain.UUID, string) (*string, error)
}

func (m *loginSessionsRepoMock) GetOwner(context.Context, string) (*domain.UUID, error) {
	return nil, nil
}
func (m *loginSessionsRepoMock) GetInfo(context.Context, string) (*sessionsdomain.Session, error) {
	return nil, nil
}
func (m *loginSessionsRepoMock) IsExists(context.Context, string) (bool, error) {
	return false, nil
}
func (m *loginSessionsRepoMock) Create(ctx context.Context, id string, owner domain.UUID, hash string) (*string, error) {
	if m.createFn != nil {
		return m.createFn(ctx, id, owner, hash)
	}
	return nil, nil
}
func (m *loginSessionsRepoMock) Revoke(context.Context, string) error {
	return nil
}
func (m *loginSessionsRepoMock) GetExpired(context.Context) ([]string, error) {
	return nil, nil
}
func (m *loginSessionsRepoMock) SetLastSeen(context.Context, string, time.Time) error {
	return nil
}
func (m *loginSessionsRepoMock) GetListByOwner(context.Context, domain.UUID, int32, int32) (sessionsdomain.Sessions, error) {
	return nil, nil
}

func newLoginUUID() domain.UUID {
	return domain.ParseUUID(uuid.New())
}

func TestRegisterUsesNormalizedUsername(t *testing.T) {
	userID := newLoginUUID()
	var capturedUsername string
	var createUserKeyCalled bool

	usersRepo := &loginUsersRepoMock{
		createFn: func(_ context.Context, username string, passwordHash, seedHash string) (*usersdomain.User, error) {
			capturedUsername = username
			if passwordHash == "" || seedHash == "" {
				t.Fatalf("expected hashes to be non-empty")
			}
			return &usersdomain.User{ID: userID}, nil
		},
		createUserKeyFn: func(_ context.Context, target domain.UUID, key string, salt string, kdf usersdomain.KDFparams) error {
			createUserKeyCalled = true
			if target != userID || key != "master-key" || salt != "salt-value" {
				t.Fatalf("unexpected user key args")
			}
			if kdf.Version != 1 || kdf.Memory != 64 || kdf.Iterations != 3 || kdf.Parallelism != 2 {
				t.Fatalf("unexpected kdf params: %#v", kdf)
			}
			return nil
		},
	}
	sessionsRepo := &loginSessionsRepoMock{
		createFn: func(_ context.Context, id string, owner domain.UUID, hash string) (*string, error) {
			if owner != userID {
				t.Fatalf("unexpected owner passed to session create")
			}
			if id == "" {
				t.Fatalf("expected encoded session id")
			}
			if hash != "device-hash" {
				t.Fatalf("unexpected client hash: %q", hash)
			}
			return &id, nil
		},
	}

	service := NewLoginService(usersRepo, sessionsapp.NewSessionService(sessionsRepo))
	req := logindomain.RegisterRequire{
		Require: logindomain.Require{
			Username: "abcDEF123!!!",
			Password: "password-123",
		},
		MasterKey: "master-key",
		Salt:      "salt-value",
	}

	gotUserID, gotSessionID, err := service.Register(context.Background(), req, "device-hash", usersdomain.KDFparams{
		Version:     1,
		Memory:      64,
		Iterations:  3,
		Parallelism: 2,
	})
	if err != nil {
		t.Fatalf("Register returned error: %v", err)
	}
	if gotUserID == nil || *gotUserID != userID {
		t.Fatalf("unexpected user id: %v", gotUserID)
	}
	if gotSessionID == nil || *gotSessionID == "" {
		t.Fatalf("unexpected session id: %v", gotSessionID)
	}
	if capturedUsername != "abc123" {
		t.Fatalf("expected normalized username abc123, got %q", capturedUsername)
	}
	if !createUserKeyCalled {
		t.Fatalf("expected CreateUserKey call")
	}
}

func TestRegisterInvalidRequire(t *testing.T) {
	service := NewLoginService(&loginUsersRepoMock{}, sessionsapp.NewSessionService(&loginSessionsRepoMock{}))
	_, _, err := service.Register(context.Background(), logindomain.RegisterRequire{}, "hash", usersdomain.KDFparams{})
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
		createFn: func(_ context.Context, id string, _ domain.UUID, _ string) (*string, error) {
			return &id, nil
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
	if gotSessionID == nil || *gotSessionID == "" {
		t.Fatalf("unexpected session id: %v", gotSessionID)
	}
}
