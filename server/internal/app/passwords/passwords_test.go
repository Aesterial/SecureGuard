package passapp

import (
	"context"
	"errors"
	"testing"
	"time"

	"github.com/aesterial/secureguard/internal/domain"
	passdomain "github.com/aesterial/secureguard/internal/domain/passwords"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/google/uuid"
)

type passRepoMock struct {
	getListFn  func(context.Context, domain.UUID, int32, int32) (passdomain.Passwords, error)
	getOwnerFn func(context.Context, domain.UUID) (*domain.UUID, error)
	createFn   func(context.Context, domain.UUID, string, string, string, int32, []byte, string, []byte) (*passdomain.Password, error)
	updateFn   func(context.Context, domain.UUID, passdomain.Target, string, string) (*passdomain.Password, error)
	deleteFn   func(context.Context, domain.UUID) error
}

func (m *passRepoMock) GetList(ctx context.Context, target domain.UUID, limit int32, offset int32) (passdomain.Passwords, error) {
	if m.getListFn != nil {
		return m.getListFn(ctx, target, limit, offset)
	}
	return nil, nil
}

func (m *passRepoMock) GetOwner(ctx context.Context, id domain.UUID) (*domain.UUID, error) {
	if m.getOwnerFn != nil {
		return m.getOwnerFn(ctx, id)
	}
	return nil, nil
}

func (m *passRepoMock) Create(ctx context.Context, target domain.UUID, service string, login string, pass string, version int32, aad []byte, nonce string, metadata []byte) (*passdomain.Password, error) {
	if m.createFn != nil {
		return m.createFn(ctx, target, service, login, pass, version, aad, nonce, metadata)
	}
	return nil, nil
}

func (m *passRepoMock) Update(ctx context.Context, target domain.UUID, update passdomain.Target, value string, salt string) (*passdomain.Password, error) {
	if m.updateFn != nil {
		return m.updateFn(ctx, target, update, value, salt)
	}
	return nil, nil
}

func (m *passRepoMock) Delete(ctx context.Context, id domain.UUID) error {
	if m.deleteFn != nil {
		return m.deleteFn(ctx, id)
	}
	return nil
}

func newPassUUID() domain.UUID {
	return domain.ParseUUID(uuid.New())
}

func TestCreateValidatesRequiredFields(t *testing.T) {
	service := NewPassService(&passRepoMock{})
	_, err := service.Create(context.Background(), newPassUUID(), "", "login", "pass", 1, []byte("aad"), "nonce", "meta")
	if !errors.Is(err, apperrors.InvalidArguments) {
		t.Fatalf("expected invalid arguments, got %v", err)
	}
}

func TestGetListNilIsNotFound(t *testing.T) {
	service := NewPassService(&passRepoMock{
		getListFn: func(context.Context, domain.UUID, int32, int32) (passdomain.Passwords, error) {
			return nil, nil
		},
	})

	_, err := service.GetList(context.Background(), newPassUUID(), 10, 0)
	if !errors.Is(err, apperrors.NotFound) {
		t.Fatalf("expected not found, got %v", err)
	}
}

func TestUpdateRejectsMismatchedOwner(t *testing.T) {
	owner := newPassUUID()
	target := newPassUUID()
	anotherOwner := newPassUUID()

	service := NewPassService(&passRepoMock{
		getOwnerFn: func(context.Context, domain.UUID) (*domain.UUID, error) {
			return &anotherOwner, nil
		},
	})

	_, err := service.Update(context.Background(), owner, target, passdomain.LoginTarget, "new-login", "salt")
	if !errors.Is(err, apperrors.AccessDenied) {
		t.Fatalf("expected access denied, got %v", err)
	}
}

func TestUpdateSuccess(t *testing.T) {
	owner := newPassUUID()
	target := newPassUUID()
	expected := &passdomain.Password{
		ID:       target,
		Service:  passdomain.ParseService("example.com"),
		Login:    "login",
		Password: "encrypted",
		Created:  time.Now().UTC(),
	}
	service := NewPassService(&passRepoMock{
		getOwnerFn: func(context.Context, domain.UUID) (*domain.UUID, error) {
			return &owner, nil
		},
		updateFn: func(_ context.Context, id domain.UUID, update passdomain.Target, value string, salt string) (*passdomain.Password, error) {
			if id != target || update != passdomain.PassTarget || value != "new-pass" || salt != "salt" {
				t.Fatalf("unexpected update args")
			}
			return expected, nil
		},
	})

	got, err := service.Update(context.Background(), owner, target, passdomain.PassTarget, "new-pass", "salt")
	if err != nil {
		t.Fatalf("Update returned error: %v", err)
	}
	if got == nil || got.ID != expected.ID || got.Login != expected.Login {
		t.Fatalf("unexpected password returned: %#v", got)
	}
}

func TestDeleteRejectsMismatchedOwner(t *testing.T) {
	owner := newPassUUID()
	target := newPassUUID()
	anotherOwner := newPassUUID()
	service := NewPassService(&passRepoMock{
		getOwnerFn: func(context.Context, domain.UUID) (*domain.UUID, error) {
			return &anotherOwner, nil
		},
	})

	err := service.Delete(context.Background(), owner, target)
	if !errors.Is(err, apperrors.AccessDenied) {
		t.Fatalf("expected access denied, got %v", err)
	}
}
