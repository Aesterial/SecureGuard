package passapp

import (
	"context"
	"encoding/json"

	"github.com/aesterial/secureguard/internal/domain"
	passdomain "github.com/aesterial/secureguard/internal/domain/passwords"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
)

type Service struct {
	pass passdomain.Repository
}

func NewPassService(pass passdomain.Repository) *Service {
	return &Service{pass: pass}
}

func (s *Service) GetList(ctx context.Context, owner domain.UUID, limit, offset int32) (passdomain.Passwords, error) {
	list, err := s.pass.GetList(ctx, owner, limit, offset)
	if err != nil {
		return nil, err
	}
	if list == nil {
		return nil, apperrors.NotFound
	}
	return list, nil
}

func (s *Service) Create(ctx context.Context, owner domain.UUID, service string, login string, pass string, version int32, aad []byte, nonce string, meta string) (*passdomain.Password, error) {
	if service == "" || login == "" || pass == "" || version <= 0 || aad == nil || nonce == "" || meta == "" {
		return nil, apperrors.InvalidArguments
	}
	metadata, err := json.Marshal(meta)
	if err != nil {
		return nil, err
	}
	password, err := s.pass.Create(ctx, owner, service, login, pass, version, aad, nonce, metadata)
	if err != nil {
		return nil, err
	}
	if password == nil {
		return nil, apperrors.NotFound
	}
	return password, nil
}

func (s *Service) Update(ctx context.Context, owner domain.UUID, target domain.UUID, update passdomain.Target, value string, salt string) (*passdomain.Password, error) {
	if value == "" || salt == "" {
		return nil, apperrors.InvalidArguments
	}
	owns, err := s.pass.GetOwner(ctx, target)
	if err != nil {
		return nil, err
	}
	if owns == nil {
		return nil, apperrors.NotFound
	}
	if !(*owns == owner) {
		return nil, apperrors.AccessDenied
	}
	password, err := s.pass.Update(ctx, target, update, value, salt)
	if err != nil {
		return nil, err
	}
	if password == nil {
		return nil, apperrors.NotFound
	}
	return password, nil
}

func (s *Service) Delete(ctx context.Context, owner domain.UUID, target domain.UUID) error {
	owns, err := s.pass.GetOwner(ctx, target)
	if err != nil {
		return err
	}
	if owns == nil {
		return apperrors.NotFound
	}
	if !(*owns == owner) {
		return apperrors.AccessDenied
	}
	return s.pass.Delete(ctx, target)
}
