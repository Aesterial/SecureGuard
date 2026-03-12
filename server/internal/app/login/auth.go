package loginapp

import (
	"context"
	"errors"

	"github.com/aesterial/secureguard/internal/domain"
	logindomain "github.com/aesterial/secureguard/internal/domain/login"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"golang.org/x/crypto/bcrypt"
)

func (s *Service) Authorize(ctx context.Context, required logindomain.AuthorizeRequire, hash string) (*domain.UUID, *domain.UUID, error) {
	if !required.IsCredentialsValid() {
		return nil, nil, apperrors.InvalidArguments
	}
	password, err := s.usr.GetPasswordByUsername(ctx, required.Username)
	if err != nil {
		return nil, nil, err
	}
	if err := bcrypt.CompareHashAndPassword([]byte(password), []byte(required.Password)); err != nil {
		if errors.Is(err, bcrypt.ErrMismatchedHashAndPassword) {
			return nil, nil, apperrors.AccessDenied
		}
		return nil, nil, err
	}
	usr, err := s.usr.GetByUsername(ctx, required.Username)
	if err != nil {
		return nil, nil, err
	}
	session, err := s.ses.Create(ctx, usr.ID, hash)
	if err != nil {
		return nil, nil, err
	}
	return &usr.ID, session, nil
}
