package server

import (
	"context"
	"strings"

	logging "github.com/aesterial/secureguard/internal/app/logging"
	sessionsapp "github.com/aesterial/secureguard/internal/app/sessions"
	usersapp "github.com/aesterial/secureguard/internal/app/users"
	"github.com/aesterial/secureguard/internal/domain"
	authdomain "github.com/aesterial/secureguard/internal/domain/auth"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/google/uuid"
	"google.golang.org/grpc/metadata"
)

type Authentificator struct {
	ses *sessionsapp.Service
	usr *usersapp.Service
}

func NewAuthentificator(ses *sessionsapp.Service, usr *usersapp.Service) *Authentificator {
	return &Authentificator{ses: ses, usr: usr}
}

func (a *Authentificator) idFromContext(ctx context.Context) (*domain.UUID, error) {
	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return nil, apperrors.InvalidArguments
	}

	for _, value := range md.Get("session") {
		sessionID, ok := strings.CutPrefix(value, "SG-")
		if !ok || sessionID == "" {
			continue
		}

		u, err := uuid.Parse(sessionID)
		if err != nil {
			return nil, apperrors.InvalidArguments
		}

		var raw [16]byte
		copy(raw[:], u[:])

		id := domain.ParseUUID(raw)
		return &id, nil
	}

	return nil, apperrors.InvalidArguments
}

func (a *Authentificator) deviceIdFromContext(ctx context.Context) (string, error) {
	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return "", apperrors.InvalidArguments
	}

	for _, value := range md.Get("client") {
		if value == "" {
			continue
		}
		return value, nil
	}
	return "", apperrors.InvalidArguments
}

func (a *Authentificator) User(ctx context.Context, checkStaff ...bool) (*authdomain.Meta, error) {
	var staffCheck bool
	if len(checkStaff) > 0 {
		staffCheck = checkStaff[0]
	}
	var metadata authdomain.Meta
	var err error
	metadata.Hash, err = a.deviceIdFromContext(ctx)
	if err != nil {
		return &metadata, err
	}
	session, err := a.idFromContext(ctx)
	if err != nil {
		return &metadata, err
	}
	metadata.SessionID = session
	valid, err := a.ses.IsValid(ctx, *metadata.SessionID, metadata.Hash)
	if err != nil {
		logging.Error("failed to check is session valid: " + err.Error())
		return &metadata, err
	}
	if !valid {
		return &metadata, apperrors.Unauthenticated
	}
	owner, err := a.ses.GetOwner(ctx, *metadata.SessionID)
	if err != nil {
		logging.Error("failed to get owner: " + err.Error())
		return &metadata, err
	}
	if owner == nil {
		return nil, apperrors.NotFound
	}
	if staffCheck {
		staff, err := a.usr.IsAdmin(ctx, *owner)
		if err != nil {
			logging.Error("failed to check is user admin: " + err.Error())
			return nil, apperrors.Wrap(err)
		}
		if !staff {
			return nil, apperrors.AccessDenied
		}
	}
	metadata.UserID = owner
	return &metadata, nil
}
