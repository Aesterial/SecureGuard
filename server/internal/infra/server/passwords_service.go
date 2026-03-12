package server

import (
	"context"
	"time"

	typespb "github.com/aesterial/secureguard/internal/api/v1"
	passpb "github.com/aesterial/secureguard/internal/api/v1/passwords/v1"
	passapp "github.com/aesterial/secureguard/internal/app/passwords"
	"github.com/aesterial/secureguard/internal/domain"
	passdomain "github.com/aesterial/secureguard/internal/domain/passwords"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/aesterial/secureguard/internal/shared/logging"
	"github.com/google/uuid"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type PasswordsService struct {
	passpb.UnimplementedPasswordServiceServer
	pass *passapp.Service
	auth *Authentificator
}

func NewPasswordsService(pass *passapp.Service, auth *Authentificator) *PasswordsService {
	return &PasswordsService{pass: pass, auth: auth}
}

func (s *PasswordsService) Create(ctx context.Context, req *passpb.CreateRequest) (*passpb.PassDataResponse, error) {
	if req == nil || req.ServiceUrl == "" || req.Login == "" || req.Pass == "" || req.Salt == "" {
		return nil, apperrors.InvalidArguments
	}
	auth, err := s.auth.User(ctx)
	if err != nil {
		return nil, err
	}
	pass, err := s.pass.Create(ctx, *auth.UserID, req.ServiceUrl, req.Login, req.Pass, req.Salt)
	if err != nil {
		return nil, apperrors.Wrap(err)
	}
	if pass == nil {
		return nil, apperrors.NotFound
	}
	return &passpb.PassDataResponse{Info: pass.Protobuf()}, nil
}

func (s *PasswordsService) Update(ctx context.Context, req *passpb.UpdateRequest) (*passpb.PassDataResponse, error) {
	if req == nil {
		return nil, apperrors.InvalidArguments
	}
	auth, err := s.auth.User(ctx)
	if err != nil {
		return nil, err
	}
	var value string
	var target passdomain.Target
	for _, v := range []*struct {
		value  *string
		target passdomain.Target
	}{{value: req.Login, target: passdomain.LoginTarget}, {value: req.Pass, target: passdomain.PassTarget}, {value: req.ServiceUrl, target: passdomain.ServiceTarget}} {
		if v.value != nil {
			value = *v.value
			target = v.target
			break
		}
	}
	id, err := uuid.Parse(req.Id)
	if err != nil {
		return nil, apperrors.InvalidArguments
	}
	password, err := s.pass.Update(ctx, *auth.UserID, domain.ParseUUID(id), target, value, req.Salt)
	if err != nil {
		logging.Error(err.Error())
		return nil, apperrors.Wrap(err)
	}
	return &passpb.PassDataResponse{Info: password.Protobuf(), At: timestamppb.New(time.Now())}, nil
}

func (s *PasswordsService) List(ctx context.Context, req *typespb.RequestWithLimitAndOffset) (*passpb.ListResponse, error) {
	if req == nil {
		return nil, apperrors.InvalidArguments
	}
	auth, err := s.auth.User(ctx)
	if err != nil {
		return nil, err
	}
	list, err := s.pass.GetList(ctx, *auth.UserID, req.Limit, req.Offset)
	if err != nil {
		return nil, err
	}
	if list == nil {
		return nil, apperrors.NotFound
	}
	return &passpb.ListResponse{List: list.Protobuf(), Count: int32(len(list))}, nil
}

func (s *PasswordsService) Delete(ctx context.Context, req *typespb.RequestWithID) (*passpb.DeleteResponse, error) {
	if req == nil {
		return nil, apperrors.InvalidArguments
	}
	auth, err := s.auth.User(ctx)
	if err != nil {
		return nil, err
	}
	id, err := uuid.Parse(req.Id)
	if err != nil {
		return nil, apperrors.InvalidArguments
	}
	err = s.pass.Delete(ctx, *auth.UserID, domain.ParseUUID(id))
	if err != nil {
		logging.Error("failed to delete password", logging.Field{Key: "err", Value: err.Error()})
		return nil, apperrors.Wrap(err)
	}
	return &passpb.DeleteResponse{}, nil
}
