package repos

import (
	"context"
	"errors"
	"time"

	domain "github.com/aesterial/secureguard/internal/domain"
	sessionsdomain "github.com/aesterial/secureguard/internal/domain/sessions"
	dbsqlc "github.com/aesterial/secureguard/internal/infra/db/sqlc"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
)

type SessionsRepository struct {
	querier dbsqlc.Querier
}

func NewSessionsRepository(querier dbsqlc.Querier) *SessionsRepository {
	return &SessionsRepository{querier: querier}
}

var _ sessionsdomain.Repository = (*SessionsRepository)(nil)

func (s *SessionsRepository) GetOwner(ctx context.Context, id string) (*domain.UUID, error) {
	valid, err := s.IsExists(ctx, id)
	if err != nil {
		return nil, err
	}
	if !valid {
		return nil, apperrors.NotFound
	}
	own, err := s.querier.GetSessionOwner(ctx, id)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, apperrors.NotFound
		}
		return nil, err
	}
	owner := domain.ParseUUID(own.Bytes)
	return &owner, nil
}

func (s *SessionsRepository) IsExists(ctx context.Context, id string) (bool, error) {
	valid, err := s.querier.IsSessionExists(ctx, id)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return false, nil
		}
		return false, err
	}
	return valid, nil
}

func (s *SessionsRepository) GetInfo(ctx context.Context, id string) (*sessionsdomain.Session, error) {
	valid, err := s.IsExists(ctx, id)
	if err != nil {
		return nil, err
	}
	if !valid {
		return nil, apperrors.NotFound
	}
	session, err := s.querier.GetSessionInfo(ctx, id)
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

func (s *SessionsRepository) Create(ctx context.Context, id string, owner domain.UUID, hash string) (*string, error) {
	id, err := s.querier.CreateSession(ctx, dbsqlc.CreateSessionParams{ID: id, Owner: owner.PG(), ClientHash: hash})
	if err != nil {
		return nil, err
	}
	return &id, nil
}

func (s *SessionsRepository) Revoke(ctx context.Context, id string) error {
	exists, err := s.IsExists(ctx, id)
	if err != nil {
		return err
	}
	if !exists {
		return apperrors.NotFound
	}
	err = s.querier.RevokeSession(ctx, id)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return apperrors.NotFound
		}
		return err
	}
	return nil
}

func (s *SessionsRepository) GetExpired(ctx context.Context) ([]string, error) {
	list, err := s.querier.GetExpiredSessions(ctx)
	if err != nil {
		return nil, err
	}
	if len(list) == 0 {
		return nil, nil
	}
	return list, nil
}

func (s *SessionsRepository) SetLastSeen(ctx context.Context, id string, at time.Time) error {
	exists, err := s.IsExists(ctx, id)
	if err != nil {
		return err
	}
	if !exists {
		return apperrors.NotFound
	}
	err = s.querier.SetLastSeenSession(ctx, dbsqlc.SetLastSeenSessionParams{LastSeen: pgtype.Timestamptz{Time: at, Valid: true}, ID: id})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return apperrors.NotFound
		}
		return err
	}
	return nil
}

func (s *SessionsRepository) parseSession(arg dbsqlc.Session) *sessionsdomain.Session {
	var revokedAt *time.Time = nil
	if arg.RevokedAt.Valid {
		revokedAt = &arg.RevokedAt.Time
	}
	var lastSeenAt *time.Time = nil
	if arg.LastSeen.Valid {
		lastSeenAt = &arg.LastSeen.Time
	}
	return &sessionsdomain.Session{
		ID:        arg.ID,
		Hash:      arg.ClientHash,
		Revoked:   arg.Revoked,
		RevokedAt: revokedAt,
		Created:   arg.Created.Time,
		Expires:   arg.Expires.Time,
		LastSeen:  lastSeenAt,
	}
}

func (s *SessionsRepository) parseSessions(args []dbsqlc.Session) sessionsdomain.Sessions {
	var list = make(sessionsdomain.Sessions, len(args))
	for i, arg := range args {
		list[i] = s.parseSession(arg)
	}
	return list
}

func (s *SessionsRepository) GetListByOwner(ctx context.Context, id domain.UUID, limit int32, offset int32) (sessionsdomain.Sessions, error) {
	list, err := s.querier.GetListSessionsByOwner(ctx, dbsqlc.GetListSessionsByOwnerParams{Owner: id.PG(), Limit: limit, Offset: offset})
	if err != nil {
		return nil, err
	}
	return s.parseSessions(list), nil
}
