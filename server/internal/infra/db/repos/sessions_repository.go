package repos

import (
	"context"
	"errors"

	domain "github.com/aesterial/secureguard/internal/domain"
	sessionsdomain "github.com/aesterial/secureguard/internal/domain/sessions"
	dbsqlc "github.com/aesterial/secureguard/internal/infra/db/sqlc"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/jackc/pgx/v5"
)

type SessionsRepository struct {
	querier dbsqlc.Querier
}

func NewSessionsRepository(querier dbsqlc.Querier) *SessionsRepository {
	return &SessionsRepository{querier: querier}
}

var _ sessionsdomain.Repository = (*SessionsRepository)(nil)

func (s *SessionsRepository) GetOwner(ctx context.Context, id domain.UUID) (*domain.UUID, error) {
	valid, err := s.IsExists(ctx, id)
	if err != nil {
		return nil, err
	}
	if !valid {
		return nil, apperrors.NotFound
	}
	own, err := s.querier.GetSessionOwner(ctx, id.PG())
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, apperrors.NotFound
		}
		return nil, err
	}
	owner := domain.ParseUUID(own.Bytes)
	return &owner, nil
}

func (s *SessionsRepository) IsExists(ctx context.Context, id domain.UUID) (bool, error) {
	valid, err := s.querier.IsSessionExists(ctx, id.PG())
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return false, nil
		}
		return false, err
	}
	return valid, nil
}

func (s *SessionsRepository) GetInfo(ctx context.Context, id domain.UUID) (*sessionsdomain.Session, error) {
	valid, err := s.IsExists(ctx, id)
	if err != nil {
		return nil, err
	}
	if !valid {
		return nil, apperrors.NotFound
	}
	session, err := s.querier.GetSessionInfo(ctx, id.PG())
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, apperrors.NotFound
		}
		return nil, err
	}
	return &sessionsdomain.Session{
		ID:      id,
		Hash:    session.ClientHash,
		Revoked: session.Revoked,
		Created: session.Created.Time,
		Expires: session.Expires.Time,
	}, nil
}

func (s *SessionsRepository) Create(ctx context.Context, owner domain.UUID, hash string) (*domain.UUID, error) {
	id, err := s.querier.CreateSession(ctx, dbsqlc.CreateSessionParams{Owner: owner.PG(), ClientHash: hash})
	if err != nil {
		return nil, err
	}
	parsed := domain.ParseUUID(id.Bytes)
	return &parsed, nil
}

func (s *SessionsRepository) Revoke(ctx context.Context, id domain.UUID) error {
	exists, err := s.IsExists(ctx, id)
	if err != nil {
		return err
	}
	if !exists {
		return apperrors.NotFound
	}
	err = s.querier.RevokeSession(ctx, id.PG())
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return apperrors.NotFound
		}
		return err
	}
	return nil
}
