package sessionsapp

import (
	"context"
	"errors"
	"time"

	"github.com/aesterial/secureguard/internal/domain"
	sessionsdomain "github.com/aesterial/secureguard/internal/domain/sessions"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/jackc/pgx/v5"
)

type Service struct {
	ses sessionsdomain.Repository
}

func NewSessionService(ses sessionsdomain.Repository) *Service {
	return &Service{ses: ses}
}

func (s *Service) IsValid(ctx context.Context, id domain.UUID, hash string) (bool, error) {
	exists, err := s.ses.IsExists(ctx, id)
	if err != nil {
		return false, err
	}
	if !exists {
		return false, apperrors.NotFound
	}
	session, err := s.ses.GetInfo(ctx, id)
	if err != nil {
		return false, err
	}
	if session == nil {
		return false, apperrors.NotFound
	}
	if session.Revoked {
		return false, nil
	}
	if time.Now().After(session.Expires) {
		return false, nil
	}
	if session.Hash != hash {
		return false, apperrors.Unauthenticated
	}
	return true, nil
}

func (s *Service) Info(ctx context.Context, id domain.UUID) (*sessionsdomain.Session, error) {
	session, err := s.ses.GetInfo(ctx, id)
	if err != nil {
		return nil, err
	}
	if session == nil {
		return nil, apperrors.NotFound
	}
	return session, nil
}

func (s *Service) GetOwner(ctx context.Context, id domain.UUID) (*domain.UUID, error) {
	owner, err := s.ses.GetOwner(ctx, id)
	if err != nil {
		return nil, err
	}
	if owner == nil {
		return nil, apperrors.NotFound
	}
	return owner, nil
}

func (s *Service) Create(ctx context.Context, id domain.UUID, hash string) (*domain.UUID, error) {
	session, err := s.ses.Create(ctx, id, hash)
	if err != nil {
		return nil, err
	}
	if session == nil {
		return nil, apperrors.NotFound
	}
	return session, nil
}

func (s *Service) Revoke(ctx context.Context, id domain.UUID) error {
	err := s.ses.Revoke(ctx, id)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return apperrors.NotFound
		}
		return err
	}
	return nil
}
