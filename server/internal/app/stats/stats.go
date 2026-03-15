package statsapp

import (
	"context"

	statsdomain "github.com/aesterial/secureguard/internal/domain/stats"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
)

type Service struct {
	stats statsdomain.Repository
}

func NewStatsService(stats statsdomain.Repository) *Service {
	return &Service{stats: stats}
}

func (s *Service) ByDate(ctx context.Context, r statsdomain.TimeRange, viewSaved ...bool) (*statsdomain.Stats, error) {
	if r.IsZero() {
		return nil, apperrors.InvalidArguments
	}
	return s.stats.ByDate(ctx, r, viewSaved...)
}

func (s *Service) Total(ctx context.Context) (*statsdomain.Total, error) {
	return s.stats.GetTotal(ctx)
}
