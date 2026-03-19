package repos

import (
	"context"
	"errors"

	domain "github.com/aesterial/secureguard/internal/domain"
	passdomain "github.com/aesterial/secureguard/internal/domain/passwords"
	dbsqlc "github.com/aesterial/secureguard/internal/infra/db/sqlc"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/jackc/pgx/v5"
)

type PasswordsRepository struct {
	querier dbsqlc.Querier
}

func NewPasswordsRepository(querier dbsqlc.Querier) *PasswordsRepository {
	return &PasswordsRepository{querier: querier}
}

var _ passdomain.Repository = (*PasswordsRepository)(nil)

func (s *PasswordsRepository) parsePassword(row dbsqlc.Password) *passdomain.Password {
	return &passdomain.Password{
		ID:       domain.ParseUUID(row.ID.Bytes),
		Service:  passdomain.ParseService(row.Service),
		Login:    row.Login,
		Password: row.Ciphertext,
		Version:  row.Version,
		Nonce:    row.Nonce,
		Aad:      row.Aad,
		Metadata: row.Metadata,
		Created:  row.CreatedAt.Time,
	}
}

func (s *PasswordsRepository) isUserExists(ctx context.Context, usr domain.UUID) (bool, error) {
	exists, err := s.querier.GetIsUserExists(ctx, usr.PG())
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return false, apperrors.NotFound
		}
		return false, err
	}
	if !exists {
		return false, apperrors.NotFound
	}
	return exists, nil
}

func (s *PasswordsRepository) IsExists(ctx context.Context, id domain.UUID) (bool, error) {
	exists, err := s.querier.IsPasswordExists(ctx, id.PG())
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return false, apperrors.NotFound
		}
		return false, err
	}
	if !exists {
		return false, apperrors.NotFound
	}
	return exists, nil
}

func (s *PasswordsRepository) GetInfo(ctx context.Context, target domain.UUID) (*passdomain.Password, error) {
	exists, err := s.IsExists(ctx, target)
	if err != nil {
		return nil, err
	}
	if !exists {
		return nil, apperrors.NotFound
	}
	info, err := s.querier.GetPasswordByID(ctx, target.PG())
	if err != nil {
		return nil, err
	}
	return s.parsePassword(info), nil
}

func (s *PasswordsRepository) GetList(ctx context.Context, target domain.UUID, limit, offset int32) (passdomain.Passwords, error) {
	exists, err := s.isUserExists(ctx, target)
	if err != nil {
		return nil, err
	}
	if !exists {
		return nil, apperrors.NotFound
	}
	list, err := s.querier.ListPasswordsByOwner(ctx, dbsqlc.ListPasswordsByOwnerParams{Owner: target.PG(), Limit: limit, Offset: offset})
	if err != nil {
		return nil, err
	}
	var result = make(passdomain.Passwords, len(list), len(list))
	for i, element := range list {
		result[i] = s.parsePassword(element)
	}
	return result, nil
}

func (s *PasswordsRepository) GetOwner(ctx context.Context, id domain.UUID) (*domain.UUID, error) {
	ow, err := s.querier.GetPasswordOwner(ctx, id.PG())
	if err != nil {
		return nil, err
	}
	owner := domain.ParseUUID(ow.Bytes)
	return &owner, nil
}

func (s *PasswordsRepository) Create(ctx context.Context, target domain.UUID, service string, login string, pass string, version int32, aad []byte, nonce string, metadata []byte) (*passdomain.Password, error) {
	if service == "" || login == "" || pass == "" {
		return nil, apperrors.InvalidArguments
	}
	exists, err := s.isUserExists(ctx, target)
	if err != nil {
		return nil, err
	}
	if !exists {
		return nil, apperrors.NotFound
	}

	p, err := s.querier.CreatePassword(ctx, dbsqlc.CreatePasswordParams{Owner: target.PG(), Service: service, Login: login, Ciphertext: pass, Version: version, Nonce: nonce, Aad: aad, Metadata: metadata})
	if err != nil {
		return nil, err
	}
	return s.parsePassword(p), nil
}

func (s *PasswordsRepository) Update(ctx context.Context, target domain.UUID, update passdomain.Target, value string, salt string) (*passdomain.Password, error) {
	exists, err := s.IsExists(ctx, target)
	if err != nil {
		return nil, err
	}
	if !exists {
		return nil, apperrors.NotFound
	}
	switch update {
	case passdomain.LoginTarget:
		err = s.querier.UpdatePasswordLogin(ctx, dbsqlc.UpdatePasswordLoginParams{Login: value, ID: target.PG()})
	case passdomain.PassTarget:
		err = s.querier.UpdatePasswordPass(ctx, dbsqlc.UpdatePasswordPassParams{Ciphertext: value, ID: target.PG()})
	case passdomain.ServiceTarget:
		err = s.querier.UpdatePasswordService(ctx, dbsqlc.UpdatePasswordServiceParams{Service: value, ID: target.PG()})
	default:
		return nil, apperrors.InvalidArguments
	}
	if err != nil {
		return nil, err
	}
	info, err := s.GetInfo(ctx, target)
	if err != nil {
		return nil, err
	}
	return info, nil
}

func (s *PasswordsRepository) Delete(ctx context.Context, target domain.UUID) error {
	exists, err := s.IsExists(ctx, target)
	if err != nil {
		return err
	}
	if !exists {
		return apperrors.NotFound
	}
	return s.querier.DeletePassword(ctx, target.PG())
}
