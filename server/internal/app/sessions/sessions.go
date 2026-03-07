package sessionsapp

import (
	"context"
	"time"

	"github.com/aesterial/secureguard/internal/domain"
	"github.com/aesterial/secureguard/internal/domain/sessions"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
)

type Service struct {
	ses sessionsdomain.Repository
}

func NewSessionService(ses sessionsdomain.Repository) *Service {
	return &Service{ses: ses}
}

func (s *Service) IsValid(ctx context.Context, id domain.UUID) (bool, error) {
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