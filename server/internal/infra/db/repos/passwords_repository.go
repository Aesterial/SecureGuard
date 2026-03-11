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

// var _ passdomain.Repository = (*PasswordsRepository)(nil)

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
	var result = make(passdomain.Passwords, 0, len(list))
	for i, element := range list {
		result[i] = &passdomain.Password{
			ID: domain.ParseUUID(element.ID.Bytes),
			Service: passdomain.ParseService(element.Service),
			Login: element.Login,
			Password: element.Pass,
			Created: element.CreatedAt.Time,
		}
	}
	return result, nil
}

func (s *PasswordsRepository)	GetOwner(ctx context.Context, id domain.UUID) (*domain.UUID, error) {
  ow, err := s.querier.GetPasswordOwner(ctx, id.PG())
  if err != nil {
    return nil, err
  }
  owner := domain.ParseUUID(ow.Bytes)
  return &owner, nil
}
