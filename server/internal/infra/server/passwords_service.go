package server

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"time"

	v1 "github.com/aesterial/secureguard/internal/api/v1"
	passwordpb "github.com/aesterial/secureguard/internal/api/v1/passwords/v1"
	dbsqlc "github.com/aesterial/secureguard/internal/infra/db/sqlc"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/aesterial/secureguard/internal/shared/logging"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
	"google.golang.org/protobuf/types/known/emptypb"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type PasswordService struct {
	passwordpb.UnimplementedPasswordServiceServer
	auth    *Authentificator
	querier dbsqlc.Querier
	db      dbsqlc.DBTX
}

func NewPasswordService(q dbsqlc.Querier, db dbsqlc.DBTX, a *Authentificator) *PasswordService {
	return &PasswordService{auth: a, querier: q, db: db}
}

func (p *PasswordService) List(ctx context.Context, _ *emptypb.Empty) (*passwordpb.ListResponse, error) {
	auth, err := p.auth.User(ctx)
	if err != nil || auth == nil || auth.UserID == nil {
		logging.Error("password list auth failed", logging.F("error", fmt.Sprint(err)))
		if err != nil {
			return nil, apperrors.Wrap(err)
		}
		return nil, apperrors.Unauthenticated
	}

	rows, err := p.querier.ListPasswordsByOwner(ctx, dbsqlc.ListPasswordsByOwnerParams{
		Owner:  auth.UserID.PG(),
		Limit:  1000,
		Offset: 0,
	})
	if err != nil {
		logging.Error("password list query failed", logging.F("error", err.Error()))
		return nil, apperrors.Wrap(err)
	}

	out := make([]*passwordpb.Password, 0, len(rows))
	for _, row := range rows {
		payload := enrichPasswordPayload(row.Pass, uuid.UUID(row.ID.Bytes).String(), row.CreatedAt.Time)
		out = append(out, &passwordpb.Password{
			Serv:      &passwordpb.ServiceInfo{Url: "secureguard", Name: "secureguard"},
			Login:     "",
			Pass:      payload,
			CreatedAt: timestamppb.New(row.CreatedAt.Time),
		})
	}

	return &passwordpb.ListResponse{List: out, Count: int32(len(out))}, nil
}

func (p *PasswordService) Create(ctx context.Context, req *passwordpb.CreateRequest) (*passwordpb.PassDataResponse, error) {
	if req == nil || strings.TrimSpace(req.Pass) == "" {
		return nil, apperrors.InvalidArguments
	}

	auth, err := p.auth.User(ctx)
	if err != nil || auth == nil || auth.UserID == nil {
		logging.Error("password create auth failed", logging.F("error", fmt.Sprint(err)))
		if err != nil {
			return nil, apperrors.Wrap(err)
		}
		return nil, apperrors.Unauthenticated
	}

	row, err := p.querier.CreatePassword(ctx, dbsqlc.CreatePasswordParams{
		Owner: auth.UserID.PG(),
		Pass:  req.Pass,
	})
	if err != nil {
		logging.Error("password create query failed", logging.F("error", err.Error()))
		return nil, apperrors.Wrap(err)
	}

	payload := enrichPasswordPayload(row.Pass, uuid.UUID(row.ID.Bytes).String(), row.CreatedAt.Time)

	return &passwordpb.PassDataResponse{
		Info: &passwordpb.Password{
			Serv:      &passwordpb.ServiceInfo{Url: req.ServiceUrl, Name: req.ServiceUrl},
			Login:     req.Login,
			Pass:      payload,
			CreatedAt: timestamppb.New(row.CreatedAt.Time),
		},
		At: timestamppb.New(time.Now().UTC()),
	}, nil
}

func (p *PasswordService) Update(context.Context, *passwordpb.UpdateRequest) (*passwordpb.PassDataResponse, error) {
	return nil, apperrors.NotImplemented
}

func (p *PasswordService) Delete(ctx context.Context, req *v1.RequestWithID) (*passwordpb.DeleteResponse, error) {
	if req == nil || strings.TrimSpace(req.Id) == "" {
		return nil, apperrors.InvalidArguments
	}

	auth, err := p.auth.User(ctx)
	if err != nil || auth == nil || auth.UserID == nil {
		logging.Error("password delete auth failed", logging.F("error", fmt.Sprint(err)))
		if err != nil {
			return nil, apperrors.Wrap(err)
		}
		return nil, apperrors.Unauthenticated
	}

	parsed, err := uuid.Parse(req.Id)
	if err != nil {
		return nil, apperrors.InvalidArguments
	}

	tag, err := p.db.Exec(
		ctx,
		"delete from passwords where id = $1 and owner = $2",
		pgtype.UUID{Bytes: [16]byte(parsed), Valid: true},
		auth.UserID.PG(),
	)
	if err != nil {
		logging.Error("password delete query failed", logging.F("error", err.Error()))
		return nil, apperrors.Wrap(err)
	}
	if tag.RowsAffected() == 0 {
		return nil, apperrors.NotFound
	}

	return &passwordpb.DeleteResponse{}, nil
}

func enrichPasswordPayload(raw, id string, createdAt time.Time) string {
	payload := map[string]any{}
	if err := json.Unmarshal([]byte(raw), &payload); err != nil {
		payload = map[string]any{
			"encrypted_password": raw,
		}
	}

	payload["id"] = id
	if value, ok := payload["created_at"]; !ok || strings.TrimSpace(fmt.Sprint(value)) == "" {
		payload["created_at"] = createdAt.UTC().Format(time.RFC3339)
	}

	encoded, err := json.Marshal(payload)
	if err != nil {
		return raw
	}
	return string(encoded)
}
