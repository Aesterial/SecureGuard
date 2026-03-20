package sessionsapp

import (
	"context"
	"crypto/rand"
	"crypto/sha256"
	"encoding/base64"
	"encoding/hex"
	"errors"
	"time"

	configapp "github.com/aesterial/secureguard/internal/app/config"
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

func (s *Service) genToken() (string, error) {
	b := make([]byte, configapp.Get().Crypt.SessionLength)
	if _, err := rand.Read(b); err != nil {
		return "", err
	}
	return base64.RawURLEncoding.EncodeToString(b), nil
}

func (s *Service) encodeToken(token string) string {
	sum := sha256.Sum256([]byte(token + configapp.Get().Crypt.Pepper))
	return hex.EncodeToString(sum[:])
}

func (s *Service) IsValid(ctx context.Context, id string, hash string) (bool, error) {
	token := s.encodeToken(id)
	exists, err := s.ses.IsExists(ctx, token)
	if err != nil {
		return false, err
	}
	if !exists {
		return false, apperrors.NotFound
	}
	session, err := s.ses.GetInfo(ctx, token)
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

func (s *Service) Info(ctx context.Context, id string) (*sessionsdomain.Session, error) {
	session, err := s.ses.GetInfo(ctx, id)
	if err != nil {
		return nil, err
	}
	if session == nil {
		return nil, apperrors.NotFound
	}
	return session, nil
}

func (s *Service) GetOwner(ctx context.Context, id string) (*domain.UUID, error) {
	owner, err := s.ses.GetOwner(ctx, id)
	if err != nil {
		return nil, err
	}
	if owner == nil {
		return nil, apperrors.NotFound
	}
	return owner, nil
}

func (s *Service) GetListByOwner(ctx context.Context, id domain.UUID, limit int32, offset int32) (sessionsdomain.Sessions, error) {
	list, err := s.ses.GetListByOwner(ctx, id, limit, offset)
	if err != nil {
		return nil, err
	}
	return list, nil
}

func (s *Service) Create(ctx context.Context, owner domain.UUID, hash string) (*string, error) {
	token, err := s.genToken()
	if err != nil {
		return nil, err
	}
	encoded := s.encodeToken(token)
	id, err := s.ses.Create(ctx, encoded, owner, hash)
	if err != nil {
		return nil, err
	}
	if id == nil {
		return nil, apperrors.NotFound
	}
	if *id != encoded {
		return nil, apperrors.ServerError.AddErrDetails("unexpected session id value")
	}
	return &token, nil
}

func (s *Service) Revoke(ctx context.Context, id string) error {
	err := s.ses.Revoke(ctx, id)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return apperrors.NotFound
		}
		return err
	}
	return nil
}

func (s *Service) SetLastSeen(ctx context.Context, id string, at time.Time) error {
	err := s.ses.SetLastSeen(ctx, id, at)
	if err != nil {
		return err
	}
	return nil
}
