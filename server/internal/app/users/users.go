package usersapp

import (
	"context"
	"database/sql"
	"errors"
	"strings"

	userpb "github.com/aesterial/secureguard/internal/api/v1/users/v1"
	domain "github.com/aesterial/secureguard/internal/domain"
	usersdomain "github.com/aesterial/secureguard/internal/domain/users"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/jackc/pgx/v5"
)

type Service struct {
	usr usersdomain.Repository
}

func NewUserService(usr usersdomain.Repository) *Service {
	return &Service{
		usr: usr,
	}
}

func (s *Service) GetByID(ctx context.Context, id domain.UUID) (*usersdomain.User, error) {
	exists, err := s.IsExists(ctx, id)
	if err != nil {
		return nil, err
	}
	if !exists {
		return nil, apperrors.NotFound
	}
	usr, err := s.usr.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	return usr, nil
}

func (s *Service) GetByIDs(ctx context.Context, limit int32, id ...domain.UUID) (usersdomain.Users, error) {
	usrs, err := s.usr.GetByIDs(ctx, limit, id...)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, apperrors.NotFound
		}
		return nil, err
	}
	return usrs, nil
}

func (s *Service) IsExists(ctx context.Context, id domain.UUID) (bool, error) {
	exists, err := s.usr.IsExists(ctx, id)
	if err != nil && !errors.Is(err, sql.ErrNoRows) {
		return false, err
	}
	return exists, nil
}

func (s *Service) IsUsernameExists(ctx context.Context, username string) (bool, error) {
	if len(username) < 3 {
		return false, apperrors.InvalidArguments
	}
	username = strings.ToLower(username)
	exists, err := s.usr.IsUsernameExists(ctx, username)
	if err != nil && !errors.Is(err, sql.ErrNoRows) {
		return false, err
	}
	return exists, nil
}

func (s *Service) ChangeCrypt(ctx context.Context, target domain.UUID, set userpb.Crypt) error {
	if set == userpb.Crypt_CRYPT_UNSPECIFIED {
		return apperrors.InvalidArguments
	}
	err := s.usr.ChangeCrypt(ctx, target, usersdomain.ParseCryptPB(set))
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return apperrors.NotFound
		}
		return err
	}
	return nil
}

func (s *Service) ChangeLanguage(ctx context.Context, target domain.UUID, set userpb.Language) error {
	if set == userpb.Language_LANGUAGE_UNSPECIFIED {
		return apperrors.InvalidArguments
	}
	err := s.usr.ChangeLanguage(ctx, target, usersdomain.ParseLanguagePB(set))
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return apperrors.NotFound
		}
		return err
	}
	return nil
}

func (s *Service) ChangeTheme(ctx context.Context, target domain.UUID, set userpb.Theme) error {
	if set == userpb.Theme_THEME_UNSPECIFIED {
		return apperrors.InvalidArguments
	}
	err := s.usr.ChangeTheme(ctx, target, usersdomain.ParseThemePB(set))
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return apperrors.InvalidArguments
		}
		return err
	}
	return nil
}

func (s *Service) IsAdmin(ctx context.Context, target domain.UUID) (bool, error) {
	active, err := s.usr.IsUserAdmin(ctx, target)
	if err != nil {
		return false, err
	}
	return active, nil
}
