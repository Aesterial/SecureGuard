package server

import (
	"context"

	typespb "github.com/aesterial/secureguard/internal/api/v1"
	userpb "github.com/aesterial/secureguard/internal/api/v1/users/v1"
	logging "github.com/aesterial/secureguard/internal/app/logging"
	userapp "github.com/aesterial/secureguard/internal/app/users"
	usersdomain "github.com/aesterial/secureguard/internal/domain/users"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"google.golang.org/protobuf/types/known/emptypb"
)

type UserService struct {
	userpb.UnimplementedUserServiceServer
	auth *Authentificator
	usr  *userapp.Service
}

func NewUserService(usr *userapp.Service, a *Authentificator) *UserService {
	return &UserService{usr: usr, auth: a}
}

func (u *UserService) Info(ctx context.Context, _ *emptypb.Empty) (*userpb.UserResponse, error) {
	auth, err := u.auth.User(ctx)
	if err != nil {
		return nil, apperrors.Wrap(err)
	}
	usr, err := u.usr.GetByID(ctx, *auth.UserID)
	if err != nil {
		logging.Error("failed to get user info info: " + err.Error())
		return nil, apperrors.Wrap(err)
	}
	return &userpb.UserResponse{Info: usr.ProtobufSelf()}, nil
}

func (u *UserService) ChangeCrypt(ctx context.Context, req *userpb.ChangeCryptRequest) (*userpb.ChangeCryptResponse, error) {
	auth, err := u.auth.User(ctx)
	if err != nil {
		return nil, apperrors.Wrap(err)
	}
	if req.Value == userpb.Crypt_CRYPT_UNSPECIFIED {
		return nil, apperrors.InvalidArguments
	}
	err = u.usr.ChangeCrypt(ctx, *auth.UserID, req.Value)
	if err != nil {
		return nil, apperrors.Wrap(err)
	}
	return &userpb.ChangeCryptResponse{Result: req.Value}, nil
}

func (u *UserService) ChangeTheme(ctx context.Context, req *userpb.ChangeThemeRequest) (*userpb.ChangeThemeResponse, error) {
	if req == nil {
		return nil, apperrors.InvalidArguments
	}
	auth, err := u.auth.User(ctx)
	if err != nil {
		return nil, apperrors.Wrap(err)
	}
	if req.Value == userpb.Theme_THEME_UNSPECIFIED {
		return nil, apperrors.InvalidArguments
	}
	err = u.usr.ChangeTheme(ctx, *auth.UserID, req.Value)
	if err != nil {
		return nil, apperrors.Wrap(err)
	}
	return &userpb.ChangeThemeResponse{Result: req.Value}, nil
}

func (u *UserService) ChangeLanguage(ctx context.Context, req *userpb.ChangeLanguageRequest) (*userpb.ChangeLanguageResponse, error) {
	if req == nil {
		return nil, apperrors.InvalidArguments
	}
	auth, err := u.auth.User(ctx)
	if err != nil {
		return nil, apperrors.Wrap(err)
	}
	if req.Value == userpb.Language_LANGUAGE_UNSPECIFIED {
		return nil, apperrors.InvalidArguments
	}
	err = u.usr.ChangeLanguage(ctx, *auth.UserID, req.Value)
	if err != nil {
		return nil, apperrors.Wrap(err)
	}
	return &userpb.ChangeLanguageResponse{Result: req.Value}, nil
}

func (u *UserService) ChangeKey(ctx context.Context, req *typespb.RequestWithValueAndKdf) (*emptypb.Empty, error) {
	if req == nil || req.GetValue() == "" || req.GetSalt() == "" {
		return nil, apperrors.InvalidArguments
	}
	auth, err := u.auth.User(ctx)
	if err != nil {
		return nil, apperrors.Wrap(err)
	}
	err = u.usr.ChangeUserKey(ctx, *auth.UserID, req.GetValue(), req.GetSalt(), usersdomain.ParseKdfParams(req.GetKdf()))
	if err != nil {
		return nil, err
	}
	return &emptypb.Empty{}, nil
}
