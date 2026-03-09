package server

import (
	"context"
	"errors"

	loginpb "github.com/aesterial/secureguard/internal/api/v1/login/v1"
	loginapp "github.com/aesterial/secureguard/internal/app/login"
	userapp "github.com/aesterial/secureguard/internal/app/users"
	logindomain "github.com/aesterial/secureguard/internal/domain/login"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
)

type LoginService struct {
	loginpb.UnimplementedLoginServiceServer
	usr   *userapp.Service
	login *loginapp.Service
	auth  *Authentificator
}

func NewLoginService(usr *userapp.Service, login *loginapp.Service, auth *Authentificator) *LoginService {
	return &LoginService{usr: usr, login: login, auth: auth}
}

func (s *LoginService) Register(ctx context.Context, req *loginpb.RegisterRequest) (*loginpb.LoginResponse, error) {
	if req == nil || len(req.Password) < 8 || len(req.Username) < 3 || req.Phraze == "" {
		return nil, apperrors.InvalidArguments
	}
	auth, err := s.auth.User(ctx)
	if err != nil && errors.Is(err, apperrors.InvalidArguments) {
		if auth == nil || auth.Hash == "" {
			return nil, apperrors.Wrap(err)
		}
	}
	exists, err := s.usr.IsUsernameExists(ctx, req.Username)
	if err != nil {
		return nil, apperrors.Wrap(err)
	}
	if exists {
		return nil, apperrors.Conflict
	}
	id, _, err := s.login.Register(ctx, logindomain.RegisterRequire{Phrase: req.Phraze, Require: logindomain.Require{Username: req.Username, Password: req.Password}})
	if err != nil {
		return nil, apperrors.Wrap(err)
	}
	usr, err := s.usr.GetByID(ctx, *id)
	if err != nil {
		return nil, apperrors.Wrap(err)
	}
	return &loginpb.LoginResponse{Info: usr.ProtobufSelf()}, nil
}
