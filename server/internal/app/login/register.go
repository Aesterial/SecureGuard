package loginapp

import (
	"context"

	"github.com/aesterial/secureguard/internal/domain"
	logindomain "github.com/aesterial/secureguard/internal/domain/login"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
)

func (s *Service) Register(ctx context.Context, require logindomain.RegisterRequire) (*domain.UUID, *domain.UUID, error) {
	if !require.IsValid() {
		return nil, nil, apperrors.InvalidArguments
	}
	normal := require.Normalize()
	pass, err := s.generatePassword(normal.Password)
	if err != nil {
		return nil, nil, err
	}
	usr, err := s.usr.Create(ctx, require.Username, require.Password, pass)
	if err != nil {
		return nil, nil, err
	}
	if usr == nil {
		return nil, nil, apperrors.InvalidArguments
	}
	return &usr.ID, nil, nil
}
