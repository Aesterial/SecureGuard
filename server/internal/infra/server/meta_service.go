package server

import (
	"context"

	metapb "github.com/aesterial/secureguard/internal/api/v1/meta/v1"
	metaapp "github.com/aesterial/secureguard/internal/app/meta"
	ratelimitapp "github.com/aesterial/secureguard/internal/app/ratelimit"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"google.golang.org/protobuf/types/known/emptypb"
)

type MetaService struct {
	metapb.UnimplementedMetaServiceServer
	limit *ratelimitapp.Service
	meta  *metaapp.Service
}

func NewMetaService(metapp *metaapp.Service, limits ...*ratelimitapp.Service) *MetaService {
	var limiter *ratelimitapp.Service
	if len(limits) > 0 {
		limiter = limits[0]
	}
	return &MetaService{limit: limiter, meta: metapp}
}

func (s *MetaService) ClientCompatibility(ctx context.Context, req *metapb.CompatibilityRequest) (*metapb.CompatibilityResponse, error) {
	if err := s.limit.AllowMeta(ctx, clientIPFromContext(ctx)); err != nil {
		return nil, err
	}
	if req == nil || req.ClientApiVersion == 0 || req.Type == metapb.ClientType_CLIENT_TYPE_SECUREGUARD_UNSPECIFIED {
		return nil, apperrors.InvalidArguments
	}
	compatibility, reasons := s.meta.CheckCompability(req.GetClientApiVersion(), req.Type)
	return &metapb.CompatibilityResponse{Value: compatibility, Reasons: reasons}, nil
}

func (s *MetaService) ServerInformation(ctx context.Context, _ *emptypb.Empty) (*metapb.ServerInfoResponse, error) {
	if err := s.limit.AllowMeta(ctx, clientIPFromContext(ctx)); err != nil {
		return nil, err
	}
	return &metapb.ServerInfoResponse{Info: s.meta.ServerInformation().Protobuf()}, nil
}

func (s *MetaService) Localisation(context.Context, *emptypb.Empty) (*metapb.LocalisationResponse, error) {
	return nil, nil
}
