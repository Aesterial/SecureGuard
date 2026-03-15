package server

import (
	"context"
	"time"

	statspb "github.com/aesterial/secureguard/internal/api/v1/stats/v1"
	statsapp "github.com/aesterial/secureguard/internal/app/stats"
	statsdomain "github.com/aesterial/secureguard/internal/domain/stats"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/aesterial/secureguard/internal/shared/logging"
	"google.golang.org/protobuf/types/known/emptypb"
)

type StatsService struct {
	statspb.UnimplementedStatsServiceServer
	auth *Authentificator
	stat *statsapp.Service
}

func NewStatsService(stat *statsapp.Service, auth *Authentificator) *StatsService {
	return &StatsService{auth: auth, stat: stat}
}

func (s *StatsService) ByDate(ctx context.Context, req *statspb.ByDateRequest) (*statspb.StatsResponse, error) {
	if req == nil || req.Day == nil {
		return nil, apperrors.InvalidArguments
	}
	_, err := s.auth.User(ctx, true)
	if err != nil {
		return nil, err
	}
	r := req.Day.AsTime()
	start := time.Date(r.Year(), r.Month(), r.Day(), 0, 0, 0, 0, r.Location())
	resp, err := s.stat.ByDate(ctx, statsdomain.TimeRange{Start: start, End: start.AddDate(0, 0, 1)}, true)
	if err != nil {
		logging.Info("failed to get by date: " + err.Error())
		return nil, apperrors.Wrap(err)
	}
	return &statspb.StatsResponse{Stats: resp.Protobuf()}, nil
}

func (s *StatsService) Total(ctx context.Context, _ *emptypb.Empty) (*statspb.TotalResponse, error) {
	_, err := s.auth.User(ctx, true)
	if err != nil {
		return nil, err
	}
	total, err := s.stat.Total(ctx)
	if err != nil {
		logging.Info("failed to get total: " + err.Error())
		return nil, apperrors.Wrap(err)
	}
	return &statspb.TotalResponse{Users: total.Users, Admins: total.Admins, ActiveSessions: total.ActiveSessions, Passwords: total.Passwords}, nil
}

func (s *StatsService) Today(ctx context.Context, _ *emptypb.Empty) (*statspb.StatsResponse, error) {
	_, err := s.auth.User(ctx, true)
	if err != nil {
		return nil, err
	}
	now := time.Now()
	start := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location())
	resp, err := s.stat.ByDate(ctx, statsdomain.TimeRange{Start: start, End: start.AddDate(0, 0, 1)}, false)
	if err != nil {
		logging.Info("failed to get by date: " + err.Error())
		return nil, apperrors.Wrap(err)
	}
	return &statspb.StatsResponse{Stats: resp.Protobuf()}, nil
}
