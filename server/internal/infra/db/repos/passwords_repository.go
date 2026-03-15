package repos

import (
	"context"
	"errors"

	domain "github.com/aesterial/secureguard/internal/domain"
	passdomain "github.com/aesterial/secureguard/internal/domain/passwords"
	dbsqlc "github.com/aesterial/secureguard/internal/infra/db/sqlc"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/jackc/pgx/v5"
)

type PasswordsRepository struct {
	querier dbsqlc.Querier
}

func NewPasswordsRepository(querier dbsqlc.Querier) *PasswordsRepository {
	return &PasswordsRepository{querier: querier}
}

var _ passdomain.Repository = (*PasswordsRepository)(nil)

func (s *PasswordsRepository) isUserExists(ctx context.Context, usr domain.UUID) (bool, error) {
	exists, err := s.querier.GetIsUserExists(ctx, usr.PG())
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return false, apperrors.NotFound
		}
		return false, err
	}
	if !exists {
		return false, apperrors.NotFound
	}
	return exists, nil
}

func (s *PasswordsRepository) IsExists(ctx context.Context, id domain.UUID) (bool, error) {
	exists, err := s.querier.IsPasswordExists(ctx, id.PG())
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return false, apperrors.NotFound
		}
		return false, err
	}
	if !exists {
		return false, apperrors.NotFound
	}
	return exists, nil
}

func (s *PasswordsRepository) GetInfo(ctx context.Context, target domain.UUID) (*passdomain.Password, error) {
	exists, err := s.IsExists(ctx, target)
	if err != nil {
		return nil, err
	}
	if !exists {
		return nil, apperrors.NotFound
	}
	info, err := s.querier.GetPasswordByID(ctx, target.PG())
	if err != nil {
		return nil, err
	}
	return &passdomain.Password{
		ID:       target,
		Service:  passdomain.ParseService(info.Service),
		Login:    info.Login,
		Password: info.Pass,
		Created:  info.CreatedAt.Time,
	}, nil
}

func (s *PasswordsRepository) GetList(ctx context.Context, target domain.UUID, limit, offset int32) (passdomain.Passwords, error) {
	exists, err := s.isUserExists(ctx, target)
	if err != nil {
		return nil, err
	}
	if !exists {
		return nil, apperrors.NotFound
	}
	list, err := s.querier.ListPasswordsByOwner(ctx, dbsqlc.ListPasswordsByOwnerParams{Owner: target.PG(), Limit: limit, Offset: offset})
	if err != nil {
		return nil, err
	}
	var result = make(passdomain.Passwords, len(list), len(list))
	for i, element := range list {
		result[i] = &passdomain.Password{
			ID:       domain.ParseUUID(element.ID.Bytes),
			Service:  passdomain.ParseService(element.Service),
			Login:    element.Login,
			Password: element.Pass,
			Created:  element.CreatedAt.Time,
		}
	}
	return result, nil
}

func (s *PasswordsRepository) GetOwner(ctx context.Context, id domain.UUID) (*domain.UUID, error) {
	ow, err := s.querier.GetPasswordOwner(ctx, id.PG())
	if err != nil {
		return nil, err
	}
	owner := domain.ParseUUID(ow.Bytes)
	return &owner, nil
}

func (s *PasswordsRepository) Create(ctx context.Context, target domain.UUID, service string, login string, pass string, salt string) (*passdomain.Password, error) {
	if service == "" || login == "" || pass == "" {
		return nil, apperrors.InvalidArguments
	}
	exists, err := s.isUserExists(ctx, target)
	if err != nil {
		return nil, err
	}
	if !exists {
		return nil, apperrors.NotFound
	}

	p, err := s.querier.CreatePassword(ctx, dbsqlc.CreatePasswordParams{Owner: target.PG(), Service: service, Login: login, Pass: pass, Salt: salt})
	if err != nil {
		return nil, err
	}
	return &passdomain.Password{ID: domain.ParseUUID(p.ID.Bytes), Service: passdomain.ParseService(p.Service), Login: p.Login, Password: p.Pass, Created: p.CreatedAt.Time}, nil
}

func (s *PasswordsRepository) Update(ctx context.Context, target domain.UUID, update passdomain.Target, value string, salt string) (*passdomain.Password, error) {
	exists, err := s.IsExists(ctx, target)
	if err != nil {
		return nil, err
	}
	if !exists {
		return nil, apperrors.NotFound
	}
	switch update {
	case passdomain.LoginTarget:
		err = s.querier.UpdatePasswordLogin(ctx, dbsqlc.UpdatePasswordLoginParams{Login: value, ID: target.PG(), Salt: salt})
	case passdomain.PassTarget:
		err = s.querier.UpdatePasswordPass(ctx, dbsqlc.UpdatePasswordPassParams{Pass: value, ID: target.PG(), Salt: salt})
	case passdomain.ServiceTarget:
		err = s.querier.UpdatePasswordService(ctx, dbsqlc.UpdatePasswordServiceParams{Service: value, ID: target.PG(), Salt: salt})
	default:
		return nil, apperrors.InvalidArguments
	}
	if err != nil {
		return nil, err
	}
	info, err := s.GetInfo(ctx, target)
	if err != nil {
		return nil, err
	}
	return info, nil
}

func (s *PasswordsRepository) Delete(ctx context.Context, target domain.UUID) error {
	exists, err := s.IsExists(ctx, target)
	if err != nil {
		return err
	}
	if !exists {
		return apperrors.NotFound
	}
	return s.querier.DeletePassword(ctx, target.PG())
}
