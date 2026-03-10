package server

import (
	"context"
	"strings"

	sessionsapp "github.com/aesterial/secureguard/internal/app/sessions"
	usersapp "github.com/aesterial/secureguard/internal/app/users"
	"github.com/aesterial/secureguard/internal/domain"
	authdomain "github.com/aesterial/secureguard/internal/domain/auth"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/aesterial/secureguard/internal/shared/logging"
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
	  logging.Info("metadata is missing")
		return nil, apperrors.InvalidArguments
	}

	for _, value := range md.Get("session") {
	  logging.Info("session data", logging.Field{Key: "id", Value: value})
		sessionID, ok := strings.CutPrefix(value, "SG-")
		if !ok || sessionID == "" {
			continue
		}

		u, err := uuid.Parse(sessionID)
		if err != nil {
		  logging.Error("failed to parse uuid", logging.Field{Key: "err", Value: err.Error()})
			return nil, apperrors.InvalidArguments
		}

		var raw [16]byte
		copy(raw[:], u[:])

		id := domain.ParseUUID(raw)
		return &id, nil
	}

	logging.Error("no values found")
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

func (a *Authentificator) User(ctx context.Context) (*authdomain.Meta, error) {
	var metadata authdomain.Meta
	var err error
	metadata.Hash, err = a.deviceIdFromContext(ctx)
	if err != nil {
	  logging.Info("device id is missing", logging.Field{Key: "err", Value: err.Error()})
		return &metadata, err
	}
	session, err := a.idFromContext(ctx)
	if err != nil {
	  logging.Info("session id getter error", logging.Field{Key: "err", Value: err.Error()})
		return &metadata, err
	}
	valid, err := a.ses.IsValid(ctx, *session, metadata.Hash)
	if err != nil {
		return &metadata, err
	}
	if !valid {
		return &metadata, apperrors.Unauthenticated
	}
	owner, err := a.ses.GetOwner(ctx, *session)
	if err != nil {
		return &metadata, err
	}
	
	metadata.UserID = owner
	return &metadata, nil
}
