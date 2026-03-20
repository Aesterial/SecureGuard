package server

import (
	"context"

	typespb "github.com/aesterial/secureguard/internal/api/v1"
	sessionspb "github.com/aesterial/secureguard/internal/api/v1/sessions/v1"
	sessionsapp "github.com/aesterial/secureguard/internal/app/sessions"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"google.golang.org/protobuf/types/known/emptypb"
)

type SessionsService struct {
	sessionspb.UnimplementedSessionsServiceServer
	ses  *sessionsapp.Service
	auth *Authentificator
}

func NewSessionsService(ses *sessionsapp.Service, auth *Authentificator) *SessionsService {
	return &SessionsService{ses: ses, auth: auth}
}

func (s *SessionsService) GetList(ctx context.Context, req *typespb.RequestWithBooleanLimitOffset) (*sessionspb.SessionsListResponse, error) {
	auth, err := s.auth.User(ctx)
	if err != nil {
		return nil, err
	}
	list, err := s.ses.GetListByOwner(ctx, *auth.UserID, req.Limit, req.Offset)
	if err != nil {
		return nil, apperrors.Wrap(err)
	}
	return &sessionspb.SessionsListResponse{List: list.Protobuf(req.GetValue())}, nil
}

func (s *SessionsService) Revoke(ctx context.Context, req *typespb.RequestWithID) (*emptypb.Empty, error) {
	_, err := s.auth.User(ctx)
	if err != nil {
		return nil, err
	}
	err = s.ses.Revoke(ctx, req.GetId())
	if err != nil {
		return nil, apperrors.Wrap(err)
	}
	return &emptypb.Empty{}, nil
}
