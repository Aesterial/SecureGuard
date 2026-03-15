package sessionsapp

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/aesterial/secureguard/internal/domain"
	sessionsdomain "github.com/aesterial/secureguard/internal/domain/sessions"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
)

type sessionsRepoMock struct {
	isExistsFn func(context.Context, domain.UUID) (bool, error)
	getInfoFn  func(context.Context, domain.UUID) (*sessionsdomain.Session, error)
	getOwnerFn func(context.Context, domain.UUID) (*domain.UUID, error)
	createFn   func(context.Context, domain.UUID, string) (*domain.UUID, error)
	revokeFn   func(context.Context, domain.UUID) error
}

func (m *sessionsRepoMock) GetOwner(ctx context.Context, id domain.UUID) (*domain.UUID, error) {
	if m.getOwnerFn != nil {
		return m.getOwnerFn(ctx, id)
	}
	return nil, nil
}
func (m *sessionsRepoMock) GetInfo(ctx context.Context, id domain.UUID) (*sessionsdomain.Session, error) {
	if m.getInfoFn != nil {
		return m.getInfoFn(ctx, id)
	}
	return nil, nil
}
func (m *sessionsRepoMock) IsExists(ctx context.Context, id domain.UUID) (bool, error) {
	if m.isExistsFn != nil {
		return m.isExistsFn(ctx, id)
	}
	return false, nil
}
func (m *sessionsRepoMock) Create(ctx context.Context, owner domain.UUID, hash string) (*domain.UUID, error) {
	if m.createFn != nil {
		return m.createFn(ctx, owner, hash)
	}
	return nil, nil
}
func (m *sessionsRepoMock) Revoke(ctx context.Context, id domain.UUID) error {
	if m.revokeFn != nil {
		return m.revokeFn(ctx, id)
	}
	return nil
}

func newSessionUUID() domain.UUID {
	return domain.ParseUUID(uuid.New())
}

func TestIsValidNotFoundWhenSessionDoesNotExist(t *testing.T) {
	service := NewSessionService(&sessionsRepoMock{
		isExistsFn: func(context.Context, domain.UUID) (bool, error) {
			return false, nil
		},
	})

	valid, err := service.IsValid(context.Background(), newSessionUUID(), "hash")
	if valid {
		t.Fatalf("expected invalid session")
	}
	if !errors.Is(err, apperrors.NotFound) {
		t.Fatalf("expected not found, got %v", err)
	}
}

func TestIsValidHandlesRevokedExpiredAndHashMismatch(t *testing.T) {
	sessionID := newSessionUUID()
	tests := []struct {
		name    string
		session *sessionsdomain.Session
		hash    string
		wantErr error
	}{
		{
			name: "revoked",
			session: &sessionsdomain.Session{
				ID:      sessionID,
				Hash:    "device-hash",
				Revoked: true,
				Expires: time.Now().Add(time.Hour),
			},
			hash:    "device-hash",
			wantErr: nil,
		},
		{
			name: "expired",
			session: &sessionsdomain.Session{
				ID:      sessionID,
				Hash:    "device-hash",
				Revoked: false,
				Expires: time.Now().Add(-time.Minute),
			},
			hash:    "device-hash",
			wantErr: nil,
		},
		{
			name: "hash mismatch",
			session: &sessionsdomain.Session{
				ID:      sessionID,
				Hash:    "stored-hash",
				Revoked: false,
				Expires: time.Now().Add(time.Hour),
			},
			hash:    "request-hash",
			wantErr: apperrors.Unauthenticated,
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			service := NewSessionService(&sessionsRepoMock{
				isExistsFn: func(context.Context, domain.UUID) (bool, error) {
					return true, nil
				},
				getInfoFn: func(context.Context, domain.UUID) (*sessionsdomain.Session, error) {
					return tc.session, nil
				},
			})

			valid, err := service.IsValid(context.Background(), sessionID, tc.hash)
			if tc.wantErr == nil {
				if err != nil {
					t.Fatalf("unexpected error: %v", err)
				}
				if valid {
					t.Fatalf("expected false for %s case", tc.name)
				}
				return
			}
			if !errors.Is(err, tc.wantErr) {
				t.Fatalf("expected %v, got %v", tc.wantErr, err)
			}
		})
	}
}

func TestIsValidSuccess(t *testing.T) {
	sessionID := newSessionUUID()
	service := NewSessionService(&sessionsRepoMock{
		isExistsFn: func(context.Context, domain.UUID) (bool, error) {
			return true, nil
		},
		getInfoFn: func(context.Context, domain.UUID) (*sessionsdomain.Session, error) {
			return &sessionsdomain.Session{
				ID:      sessionID,
				Hash:    "device-hash",
				Revoked: false,
				Expires: time.Now().Add(time.Hour),
			}, nil
		},
	})

	valid, err := service.IsValid(context.Background(), sessionID, "device-hash")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if !valid {
		t.Fatalf("expected valid session")
	}
}

func TestRevokeMapsNoRowsToNotFound(t *testing.T) {
	service := NewSessionService(&sessionsRepoMock{
		revokeFn: func(context.Context, domain.UUID) error {
			return pgx.ErrNoRows
		},
	})

	err := service.Revoke(context.Background(), newSessionUUID())
	if !errors.Is(err, apperrors.NotFound) {
		t.Fatalf("expected not found, got %v", err)
	}
}
