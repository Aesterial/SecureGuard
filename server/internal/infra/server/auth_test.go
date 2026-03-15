package server

import (
	"context"
	"errors"
	"testing"
	"time"

	sessionsapp "github.com/aesterial/secureguard/internal/app/sessions"
	usersapp "github.com/aesterial/secureguard/internal/app/users"
	"github.com/aesterial/secureguard/internal/domain"
	sessionsdomain "github.com/aesterial/secureguard/internal/domain/sessions"
	usersdomain "github.com/aesterial/secureguard/internal/domain/users"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/google/uuid"
	"google.golang.org/grpc/metadata"
)

type authSessionsRepoMock struct {
	getOwnerFn func(context.Context, domain.UUID) (*domain.UUID, error)
	getInfoFn  func(context.Context, domain.UUID) (*sessionsdomain.Session, error)
	isExistsFn func(context.Context, domain.UUID) (bool, error)
}

func (m *authSessionsRepoMock) GetOwner(ctx context.Context, id domain.UUID) (*domain.UUID, error) {
	if m.getOwnerFn != nil {
		return m.getOwnerFn(ctx, id)
	}
	return nil, nil
}
func (m *authSessionsRepoMock) GetInfo(ctx context.Context, id domain.UUID) (*sessionsdomain.Session, error) {
	if m.getInfoFn != nil {
		return m.getInfoFn(ctx, id)
	}
	return nil, nil
}
func (m *authSessionsRepoMock) IsExists(ctx context.Context, id domain.UUID) (bool, error) {
	if m.isExistsFn != nil {
		return m.isExistsFn(ctx, id)
	}
	return false, nil
}
func (m *authSessionsRepoMock) Create(context.Context, domain.UUID, string) (*domain.UUID, error) {
	return nil, nil
}
func (m *authSessionsRepoMock) Revoke(context.Context, domain.UUID) error {
	return nil
}

type authUsersRepoMock struct {
	isAdminFn func(context.Context, domain.UUID) (bool, error)
}

func (m *authUsersRepoMock) GetByID(context.Context, domain.UUID) (*usersdomain.User, error) {
	return nil, nil
}
func (m *authUsersRepoMock) GetByUsername(context.Context, string) (*usersdomain.User, error) {
	return nil, nil
}
func (m *authUsersRepoMock) GetByIDs(context.Context, int32, ...domain.UUID) (usersdomain.Users, error) {
	return nil, nil
}
func (m *authUsersRepoMock) GetList(context.Context, int32, int32) (usersdomain.Users, error) {
	return nil, nil
}
func (m *authUsersRepoMock) GetPassword(context.Context, domain.UUID) (string, error) {
	return "", nil
}
func (m *authUsersRepoMock) GetPasswordByUsername(context.Context, string) (string, error) {
	return "", nil
}
func (m *authUsersRepoMock) IsExists(context.Context, domain.UUID) (bool, error) {
	return false, nil
}
func (m *authUsersRepoMock) IsUserAdmin(ctx context.Context, target domain.UUID) (bool, error) {
	if m.isAdminFn != nil {
		return m.isAdminFn(ctx, target)
	}
	return false, nil
}
func (m *authUsersRepoMock) IsUsernameExists(context.Context, string) (bool, error) {
	return false, nil
}
func (m *authUsersRepoMock) ChangeCrypt(context.Context, domain.UUID, usersdomain.Crypt) error {
	return nil
}
func (m *authUsersRepoMock) ChangeTheme(context.Context, domain.UUID, usersdomain.Theme) error {
	return nil
}
func (m *authUsersRepoMock) ChangeLanguage(context.Context, domain.UUID, usersdomain.Language) error {
	return nil
}
func (m *authUsersRepoMock) ChangePhrase(context.Context, domain.UUID, string) error {
	return nil
}
func (m *authUsersRepoMock) Create(context.Context, string, string, string) (*usersdomain.User, error) {
	return nil, nil
}

func newAuthUUID() domain.UUID {
	return domain.ParseUUID(uuid.New())
}

func authContext(client string, session ...string) context.Context {
	md := metadata.MD{}
	if client != "" {
		md.Append("client", client)
	}
	for _, value := range session {
		md.Append("session", value)
	}
	return metadata.NewIncomingContext(context.Background(), md)
}

func TestAuthentificatorUserRejectsMissingClientHeader(t *testing.T) {
	auth := NewAuthentificator(
		sessionsapp.NewSessionService(&authSessionsRepoMock{}),
		usersapp.NewUserService(&authUsersRepoMock{}),
	)

	_, err := auth.User(authContext("", "SG-"+uuid.NewString()))
	if !errors.Is(err, apperrors.InvalidArguments) {
		t.Fatalf("expected invalid arguments, got %v", err)
	}
}

func TestAuthentificatorUserSuccess(t *testing.T) {
	sessionID := newAuthUUID()
	ownerID := newAuthUUID()

	auth := NewAuthentificator(
		sessionsapp.NewSessionService(&authSessionsRepoMock{
			isExistsFn: func(_ context.Context, id domain.UUID) (bool, error) {
				return id == sessionID, nil
			},
			getInfoFn: func(_ context.Context, id domain.UUID) (*sessionsdomain.Session, error) {
				if id != sessionID {
					t.Fatalf("unexpected session id")
				}
				return &sessionsdomain.Session{
					ID:      sessionID,
					Hash:    "device-hash",
					Revoked: false,
					Expires: time.Now().Add(time.Hour),
				}, nil
			},
			getOwnerFn: func(_ context.Context, id domain.UUID) (*domain.UUID, error) {
				if id != sessionID {
					t.Fatalf("unexpected session id")
				}
				return &ownerID, nil
			},
		}),
		usersapp.NewUserService(&authUsersRepoMock{}),
	)

	meta, err := auth.User(authContext("device-hash", "SG-"+sessionID.String()))
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if meta == nil || meta.UserID == nil || *meta.UserID != ownerID {
		t.Fatalf("unexpected owner meta: %#v", meta)
	}
	if meta.SessionID == nil || *meta.SessionID != sessionID {
		t.Fatalf("unexpected session meta: %#v", meta)
	}
	if meta.Hash != "device-hash" {
		t.Fatalf("unexpected hash in meta: %q", meta.Hash)
	}
}

func TestAuthentificatorUserStaffCheckDenied(t *testing.T) {
	sessionID := newAuthUUID()
	ownerID := newAuthUUID()

	auth := NewAuthentificator(
		sessionsapp.NewSessionService(&authSessionsRepoMock{
			isExistsFn: func(context.Context, domain.UUID) (bool, error) { return true, nil },
			getInfoFn: func(context.Context, domain.UUID) (*sessionsdomain.Session, error) {
				return &sessionsdomain.Session{ID: sessionID, Hash: "device-hash", Expires: time.Now().Add(time.Hour)}, nil
			},
			getOwnerFn: func(context.Context, domain.UUID) (*domain.UUID, error) { return &ownerID, nil },
		}),
		usersapp.NewUserService(&authUsersRepoMock{
			isAdminFn: func(context.Context, domain.UUID) (bool, error) {
				return false, nil
			},
		}),
	)

	_, err := auth.User(authContext("device-hash", "SG-"+sessionID.String()), true)
	if !errors.Is(err, apperrors.AccessDenied) {
		t.Fatalf("expected access denied, got %v", err)
	}
}

func TestIDFromContextSkipsValuesWithoutPrefix(t *testing.T) {
	sessionID := newAuthUUID()
	auth := NewAuthentificator(nil, nil)
	ctx := authContext("device", "plain-value", "SG-"+sessionID.String())

	got, err := auth.idFromContext(ctx)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if got == nil || *got != sessionID {
		t.Fatalf("unexpected parsed id: %v", got)
	}
}
