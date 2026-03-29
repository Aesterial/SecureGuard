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

func (u *UserRepository) compileUser(usr dbsqlc.User, prefs dbsqlc.GetUserPreferencesRow, key *usersdomain.UserKey) *usersdomain.User {
	if key != nil {
		key.Algorithm = usersdomain.ParseCryptSTR(prefs.Crypt)
	}

	return &usersdomain.User{
		ID:       domain.ParseUUID(usr.ID.Bytes),
		Username: usr.Username,
		Joined:   usr.Joined.Time,
		Staff:    usr.AdminAccess,
		Preferences: usersdomain.Preferences{
			Theme: usersdomain.ParseThemeSTR(prefs.Theme),
			Lang:  usersdomain.ParseLanguageSTR(prefs.Lang),
			Crypt: usersdomain.ParseCryptSTR(prefs.Crypt),
		},
		Key: key,
	}
}

func (u *UserRepository) GetByID(ctx context.Context, id domain.UUID) (*usersdomain.User, error) {
	exists, err := u.querier.GetIsUserExists(ctx, id.PG())
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, apperrors.NotFound
		}
		return nil, err
	}
	if !exists {
		return nil, apperrors.NotFound
	}
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
	key, err := u.GetUserKey(ctx, id)
	if err != nil && !errors.Is(err, apperrors.NotFound) {
		return nil, err
	}
	return u.compileUser(usr, prefs, key), nil
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
	key, err := u.GetUserKey(ctx, domain.ParseUUID(usr.ID.Bytes))
	if err != nil && !errors.Is(err, apperrors.NotFound) {
		return nil, err
	}
	return u.compileUser(usr, prefs, key), nil
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
	var response = make(usersdomain.Users, len(users))
	for i := range users {
		prefs, err := u.querier.GetUserPreferences(ctx, users[i].ID)
		if err != nil {
			return nil, err
		}
		response[i] = u.compileUser(users[i], prefs, nil)
	}
	return response, nil
}

func (u *UserRepository) GetList(ctx context.Context, limit, offset int32) (usersdomain.Users, error) {
	usrs, err := u.querier.GetListUsers(ctx, dbsqlc.GetListUsersParams{Limit: limit, Offset: offset})
	if err != nil {
		return nil, err
	}
	var response = make(usersdomain.Users, len(usrs))
	for i := range usrs {
		prefs, err := u.querier.GetUserPreferences(ctx, usrs[i].ID)
		if err != nil {
			return nil, err
		}
		response[i] = u.compileUser(usrs[i], prefs, nil)
	}
	return response, nil
}

func (u *UserRepository) GetPassword(ctx context.Context, id domain.UUID) (string, error) {
	password, err := u.querier.GetUserPassword(ctx, id.PG())
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return "", apperrors.NotFound
		}
		return "", err
	}
	if password == "" {
		return "", apperrors.InvalidArguments
	}
	return password, nil
}

func (u *UserRepository) GetPasswordByUsername(ctx context.Context, username string) (string, error) {
	if username == "" {
		return "", errors.New("username is empty")
	}
	password, err := u.querier.GetUserPasswordByUsername(ctx, username)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return "", apperrors.NotFound
		}
		return "", err
	}
	if password == "" {
		return "", apperrors.InvalidArguments
	}
	return password, nil
}

func (u *UserRepository) GetUserKey(ctx context.Context, target domain.UUID) (*usersdomain.UserKey, error) {
	row, err := u.querier.GetUserKey(ctx, target.PG())
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, apperrors.NotFound
		}
		return nil, err
	}

	return &usersdomain.UserKey{
		WrappedMasterKey: row.MasterKey,
		Salt:             row.Salt,
		KDF: usersdomain.KDFparams{
			Version:     row.Version,
			Memory:      row.Memory,
			Iterations:  row.Iterations,
			Parallelism: row.Parallelism,
		},
	}, nil
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
	return u.querier.UpdateMasterKey(ctx, dbsqlc.UpdateMasterKeyParams{MasterKey: set, Owner: target.PG()})
}

func (u *UserRepository) initPreferences(ctx context.Context, owner domain.UUID) error {
	exists, err := u.IsPreferencesExists(ctx, owner)
	if err != nil {
		return err
	}
	if exists {
		return apperrors.NotFound
	}
	if err := u.querier.InitPreferences(ctx, owner.PG()); err != nil {
		return err
	}
	return nil
}

func (u *UserRepository) IsPreferencesExists(ctx context.Context, owner domain.UUID) (bool, error) {
	exists, err := u.querier.IsPreferencesExists(ctx, owner.PG())
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return false, nil
		}
		return false, err
	}
	return exists, nil
}

func (u *UserRepository) Create(ctx context.Context, username string, passwordHash, seedHash string) (*usersdomain.User, error) {
	if len(username) < 3 || len(passwordHash) < 3 || len(seedHash) < 3 {
		return nil, apperrors.InvalidArguments
	}
	usr, err := u.querier.CreateUser(ctx, dbsqlc.CreateUserParams{Username: username, Password: passwordHash})
	if err != nil {
		return nil, err
	}
	if err := u.initPreferences(ctx, domain.ParseUUID(usr.ID.Bytes)); err != nil {
		return nil, err
	}
	prefs, err := u.querier.GetUserPreferences(ctx, usr.ID)
	if err != nil {
		return nil, err
	}
	return u.compileUser(usr, prefs, nil), nil
}

func (u *UserRepository) CreateUserKey(ctx context.Context, target domain.UUID, key string, salt string, kdf usersdomain.KDFparams) error {
	if key == "" {
		return apperrors.InvalidArguments
	}
	err := u.querier.CreateUserKey(ctx, dbsqlc.CreateUserKeyParams{Owner: target.PG(), MasterKey: key, Salt: salt, Version: kdf.Version, Memory: kdf.Memory, Iterations: kdf.Iterations, Parallelism: kdf.Parallelism})
	if err != nil {
		return err
	}
	return nil
}

func (u *UserRepository) ChangeUserKey(ctx context.Context, target domain.UUID, key string, salt string, kdf usersdomain.KDFparams) error {
	if key == "" || salt == "" {
		return apperrors.InvalidArguments
	}
	err := u.querier.UpdateUserKey(ctx, dbsqlc.UpdateUserKeyParams{MasterKey: key, Salt: salt, Version: kdf.Version, Memory: kdf.Memory, Iterations: kdf.Iterations, Parallelism: kdf.Parallelism, Owner: target.PG()})
	if err != nil {
		return err
	}
	return nil
}

func (u *UserRepository) IsUserAdmin(ctx context.Context, id domain.UUID) (bool, error) {
	active, err := u.querier.GetIsUserAdmin(ctx, id.PG())
	if err != nil {
		return false, err
	}
	return active, nil
}
