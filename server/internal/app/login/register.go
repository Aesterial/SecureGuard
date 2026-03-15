package loginapp

import (
	"context"

	logging "github.com/aesterial/secureguard/internal/app/logging"
	"github.com/aesterial/secureguard/internal/domain"
	logindomain "github.com/aesterial/secureguard/internal/domain/login"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
)

func (s *Service) Register(ctx context.Context, require logindomain.RegisterRequire, hash string) (*domain.UUID, *domain.UUID, error) {
	if !require.IsValid() {
		return nil, nil, apperrors.InvalidArguments
	}
	normal := require.Normalize()
	pass, err := s.generatePassword(normal.Password)
	if err != nil {
		logging.Error("failed to generate password hash", logging.F("error", err.Error()))
		return nil, nil, err
	}
	usr, err := s.usr.Create(ctx, normal.Username, pass, require.Phrase)
	if err != nil {
		logging.Error("failed to create user", logging.F("error", err.Error()))
		return nil, nil, err
	}
	if usr == nil {
		return nil, nil, apperrors.InvalidArguments
	}
	session, err := s.ses.Create(ctx, usr.ID, hash)
	if err != nil {
		return nil, nil, err
	}
	return &usr.ID, session, nil
}
