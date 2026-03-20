package repos

import (
	"context"
	"testing"
	"time"

	"github.com/aesterial/secureguard/internal/domain"
	passdomain "github.com/aesterial/secureguard/internal/domain/passwords"
	dbsqlc "github.com/aesterial/secureguard/internal/infra/db/sqlc"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
)

type querierStub struct {
	dbsqlc.Querier

	getListUsersFn        func(context.Context, dbsqlc.GetListUsersParams) ([]dbsqlc.User, error)
	getUserPreferencesFn  func(context.Context, pgtype.UUID) (dbsqlc.GetUserPreferencesRow, error)
	isPasswordExistsFn    func(context.Context, pgtype.UUID) (bool, error)
	updatePasswordLoginFn func(context.Context, dbsqlc.UpdatePasswordLoginParams) error
	getPasswordByIDFn     func(context.Context, pgtype.UUID) (dbsqlc.Password, error)
}

func (s *querierStub) GetListUsers(ctx context.Context, arg dbsqlc.GetListUsersParams) ([]dbsqlc.User, error) {
	return s.getListUsersFn(ctx, arg)
}

func (s *querierStub) GetUserPreferences(ctx context.Context, owner pgtype.UUID) (dbsqlc.GetUserPreferencesRow, error) {
	return s.getUserPreferencesFn(ctx, owner)
}

func (s *querierStub) IsPasswordExists(ctx context.Context, id pgtype.UUID) (bool, error) {
	return s.isPasswordExistsFn(ctx, id)
}

func (s *querierStub) UpdatePasswordLogin(ctx context.Context, arg dbsqlc.UpdatePasswordLoginParams) error {
	return s.updatePasswordLoginFn(ctx, arg)
}

func (s *querierStub) GetPasswordByID(ctx context.Context, id pgtype.UUID) (dbsqlc.Password, error) {
	return s.getPasswordByIDFn(ctx, id)
}

func newRepoUUID() domain.UUID {
	return domain.ParseUUID(uuid.New())
}

func TestUserRepositoryGetByIDsAllocatesOutputSlice(t *testing.T) {
	userID := newRepoUUID()
	now := time.Now().UTC()
	stub := &querierStub{
		getListUsersFn: func(context.Context, dbsqlc.GetListUsersParams) ([]dbsqlc.User, error) {
			return []dbsqlc.User{
				{
					ID:       userID.PG(),
					Username: "tester",
					Joined:   pgtype.Timestamptz{Time: now, Valid: true},
				},
			}, nil
		},
		getUserPreferencesFn: func(context.Context, pgtype.UUID) (dbsqlc.GetUserPreferencesRow, error) {
			return dbsqlc.GetUserPreferencesRow{Theme: "black", Lang: "en"}, nil
		},
	}

	repo := NewUserRepository(stub)
	users, err := repo.GetByIDs(context.Background(), 10, userID)
	if err != nil {
		t.Fatalf("GetByIDs returned error: %v", err)
	}
	if len(users) != 1 {
		t.Fatalf("expected 1 user, got %d", len(users))
	}
	if users[0] == nil || users[0].Username != "tester" {
		t.Fatalf("unexpected user payload: %#v", users[0])
	}
}

func TestPasswordsRepositoryUpdateReturnsFreshEntity(t *testing.T) {
	target := newRepoUUID()
	now := time.Now().UTC()
	called := false
	stub := &querierStub{
		isPasswordExistsFn: func(context.Context, pgtype.UUID) (bool, error) {
			return true, nil
		},
		updatePasswordLoginFn: func(_ context.Context, arg dbsqlc.UpdatePasswordLoginParams) error {
			called = true
			if arg.Login != "new-login" || arg.ID != target.PG() {
				t.Fatalf("unexpected update args: %#v", arg)
			}
			return nil
		},
		getPasswordByIDFn: func(context.Context, pgtype.UUID) (dbsqlc.Password, error) {
			return dbsqlc.Password{
				ID:         target.PG(),
				Service:    "github.com",
				Login:      "new-login",
				Ciphertext: "encrypted",
				CreatedAt:  pgtype.Timestamptz{Time: now, Valid: true},
			}, nil
		},
	}

	repo := NewPasswordsRepository(stub)
	got, err := repo.Update(context.Background(), target, passdomain.LoginTarget, "new-login", "new-salt")
	if err != nil {
		t.Fatalf("Update returned error: %v", err)
	}
	if !called {
		t.Fatalf("expected UpdatePasswordLogin call")
	}
	if got == nil || got.Login != "new-login" || got.ID != target {
		t.Fatalf("unexpected updated password: %#v", got)
	}
}
