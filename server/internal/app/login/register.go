package loginapp

import (
	"context"

	"fmt"

	logindomain "github.com/aesterial/secureguard/internal/domain/login"
	"github.com/aesterial/secureguard/internal/infra/db/sqlc"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
)

func (s *Service) Register(ctx context.Context, require logindomain.RegisterRequire) (*uuid.UUID, error) {
	if !require.IsValid() {
		return nil, apperrors.InvalidArguments
	}
	normal := require.Normalize()
	pass, err := s.generatePassword(normal.Password)
	if err != nil {
		return nil, err
	}
	usr, err := s.client.Queries.CreateUser(ctx, dbsqlc.CreateUserParams{
		Username:   normal.Username,
		Password:   pass,
		SeedPhrase: pgtype.Text{String: require.Phrase, Valid: true},
	})
	if err != nil {
		return nil, err
	}

	if !usr.ID.Valid {
		return nil, fmt.Errorf("id is NULL")
	}

	uid := uuid.UUID(usr.ID.Bytes)
	return &uid, nil
}
