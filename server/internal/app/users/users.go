package usersapp

import (
	"context"
	"database/sql"
	"errors"
	"strings"

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
