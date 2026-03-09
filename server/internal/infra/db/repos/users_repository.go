package repos

import (
	"errors"

	"github.com/aesterial/secureguard/internal/domain"
	usersdomain "github.com/aesterial/secureguard/internal/domain/users"
	dbsqlc "github.com/aesterial/secureguard/internal/infra/db/sqlc"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/jackc/pgx/v5"

	"context"
)

type UserRepository struct {
	querier dbsqlc.Querier
}

func NewUserRepository(q dbsqlc.Querier) *UserRepository {
	return &UserRepository{querier: q}
}

var _ usersdomain.Repository = (*UserRepository)(nil)

func (u *UserRepository) compileUser(usr dbsqlc.User, prefs dbsqlc.GetUserPreferencesRow) *usersdomain.User {
	return &usersdomain.User{
		ID:       domain.ParseUUID(usr.ID.Bytes),
		Username: usr.Username,
		Joined:   usr.Joined.Time,
		Preferences: usersdomain.Preferences{
			Theme: usersdomain.ParseThemeSTR(prefs.Theme),
			Lang:  usersdomain.ParseLanguageSTR(prefs.Lang),
		},
	}
}

func (u *UserRepository) GetByID(ctx context.Context, id domain.UUID) (*usersdomain.User, error) {
	usr, err := u.querier.GetUserByID(ctx, id.PG())
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, apperrors.NotFound
		}
		return nil, err
	}
	prefs, err := u.querier.GetUserPreferences(ctx, usr.ID)
	if err != nil {
		return nil, err
	}
	return u.compileUser(usr, prefs), nil
}

func (u *UserRepository) GetByUsername(ctx context.Context, username string) (*usersdomain.User, error) {
	if len(username) <= 3 {
		return nil, apperrors.InvalidArguments
	}
	usr, err := u.querier.GetUserByUsername(ctx, username)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, apperrors.NotFound
		}
		return nil, err
	}
	prefs, err := u.querier.GetUserPreferences(ctx, usr.ID)
	if err != nil {
		return nil, err
	}
	return u.compileUser(usr, prefs), nil
}

func (u *UserRepository) IsExists(ctx context.Context, id domain.UUID) (bool, error) {
	return u.querier.GetIsUserExists(ctx, id.PG())
}

func (u *UserRepository) IsUsernameExists(ctx context.Context, username string) (bool, error) {
	if len(username) < 3 {
		return false, apperrors.InvalidArguments
	}
	return u.querier.GetIsUsernameExists(ctx, username)
}

func (u *UserRepository) GetByIDs(ctx context.Context, limit int32, ids ...domain.UUID) (usersdomain.Users, error) {
	if len(ids) == 0 {
		return nil, apperrors.InvalidArguments
	}
	users, err := u.querier.GetListUsers(ctx, dbsqlc.GetListUsersParams{Limit: limit})
	if err != nil {
		return nil, err
	}
	var response = make(usersdomain.Users, 0, len(users))
	for i := range users {
		prefs, err := u.querier.GetUserPreferences(ctx, users[i].ID)
		if err != nil {
			return nil, err
		}
		response[i] = u.compileUser(users[i], prefs)
	}
	return response, nil
}

func (u *UserRepository) GetList(ctx context.Context, limit, offset int32) (usersdomain.Users, error) {
	usrs, err := u.querier.GetListUsers(ctx, dbsqlc.GetListUsersParams{Limit: limit, Offset: offset})
	if err != nil {
		return nil, err
	}
	var response = make(usersdomain.Users, 0, len(usrs))
	for i := range usrs {
		prefs, err := u.querier.GetUserPreferences(ctx, usrs[i].ID)
		if err != nil {
			return nil, err
		}
		response[i] = u.compileUser(usrs[i], prefs)
	}
	return response, nil
}

func (u *UserRepository) GetPassword(ctx context.Context, id domain.UUID) (string, error) {
	return u.querier.GetUserPassword(ctx, id.PG())
}

func (u *UserRepository) ChangeCrypt(ctx context.Context, target domain.UUID, set usersdomain.Crypt) error {
	if !set.IsValid() {
		return apperrors.InvalidArguments
	}
	return u.querier.UpdatePreferenceCrypt(ctx, dbsqlc.UpdatePreferenceCryptParams{Crypt: set.String(), Owner: target.PG()})
}

func (u *UserRepository) ChangeLanguage(ctx context.Context, target domain.UUID, set usersdomain.Language) error {
	if !set.IsValid() {
		return apperrors.InvalidArguments
	}
	return u.querier.UpdatePreferenceLanguage(ctx, dbsqlc.UpdatePreferenceLanguageParams{Lang: set.String(), Owner: target.PG()})
}

func (u *UserRepository) ChangeTheme(ctx context.Context, target domain.UUID, set usersdomain.Theme) error {
	if !set.IsValid() {
		return apperrors.InvalidArguments
	}
	return u.querier.UpdatePreferenceTheme(ctx, dbsqlc.UpdatePreferenceThemeParams{Theme: set.String(), Owner: target.PG()})
}

func (u *UserRepository) ChangePhrase(ctx context.Context, target domain.UUID, set string) error {
	if set == "" {
		return apperrors.InvalidArguments
	}
	return u.querier.UpdateSeedPhrase(ctx, dbsqlc.UpdateSeedPhraseParams{SeedPhrase: set, ID: target.PG()})
}

func (u *UserRepository) Create(ctx context.Context, username string, passwordHash, seedHash string) (*usersdomain.User, error) {
	if len(username) < 3 || len(passwordHash) < 3 || len(seedHash) < 3 {
		return nil, apperrors.InvalidArguments
	}
	usr, err := u.querier.CreateUser(ctx, dbsqlc.CreateUserParams{Username: username, Password: passwordHash, SeedPhrase: seedHash})
	if err != nil {
		return nil, err
	}
	prefs, err := u.querier.GetUserPreferences(ctx, usr.ID)
	if err != nil {
		return nil, err
	}
	return u.compileUser(usr, prefs), nil
}
