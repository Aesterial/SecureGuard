package server

import (
	"context"

	userpb "github.com/aesterial/secureguard/internal/api/v1/users/v1"
	userapp "github.com/aesterial/secureguard/internal/app/users"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/aesterial/secureguard/internal/shared/logging"
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

func (u *UserService) Info(ctx context.Context, req *emptypb.Empty) (*userpb.UserResponse, error) {
	auth, err := u.auth.User(ctx)
	if err != nil {
	  logging.Error("error on authorizing: " + err.Error())
		return nil, apperrors.Wrap(err)
	}
	usr, err := u.usr.GetByID(ctx, *auth.UserID)
	if err != nil {
	  logging.Error("failed to get user info info: " + err.Error())
		return nil, apperrors.Wrap(err)
	}
	return &userpb.UserResponse{Info: usr.ProtobufSelf()}, nil
}
