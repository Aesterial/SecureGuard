package repos

import (
	"context"
	"errors"
	"strconv"
	"time"

	loggingdomain "github.com/aesterial/secureguard/internal/domain/logging"
	statsdomain "github.com/aesterial/secureguard/internal/domain/stats"
	dbsqlc "github.com/aesterial/secureguard/internal/infra/db/sqlc"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/aesterial/secureguard/internal/shared/logging"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
)

type StatsRepository struct {
	querier dbsqlc.Querier
}

func NewStatsRepository(querier dbsqlc.Querier) *StatsRepository {
	return &StatsRepository{querier: querier}
}

func (s *StatsRepository) parseView(viewSaved ...bool) bool {
	if len(viewSaved) > 0 {
		return viewSaved[0]
	}
	return false
}

var _ statsdomain.Repository = (*StatsRepository)(nil)

func (s *StatsRepository) ByDate(ctx context.Context, r statsdomain.TimeRange, viewSaved ...bool) (*statsdomain.Stats, error) {
	return nil, nil
}

func (s *StatsRepository) GetLatency(ctx context.Context, r statsdomain.TimeRange, viewSaved ...bool) (*statsdomain.Latency, error) {
	if r.IsZero() {
		return nil, apperrors.InvalidArguments
	}
	var latency statsdomain.Latency
	if s.parseView(viewSaved...) {
		row, err := s.querier.GetSavedStatsLatency(ctx, pgtype.Timestamptz{Time: r.Start, Valid: true})
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				return nil, apperrors.NotFound
			}
			return nil, err
		}
		latency.P50 = row.P50
		latency.P90 = row.P90
	} else {
		list, err := logging.ReadEntries(ctx, loggingdomain.Query{Since: time.Date(r.Start.Year(), r.Start.Month(), r.Start.Day(), 0, 0, 0, 0, r.Start.Location())})
		if err != nil {
			return nil, err
		}
		var entries = make([]float32, len(list))
		for i, e := range list {
			duration, exists := e.Field("duration_ms")
			if !exists {
				continue
			}
			durationFloat64, err := strconv.ParseFloat(duration, 32)
			if err != nil {
				continue
			}
			entries[i] = float32(durationFloat64)
		}
		latency = statsdomain.NewLatency(entries)
	}
	return &latency, nil
}

func (s *StatsRepository) GetTotal(ctx context.Context) (*statsdomain.Total, error) {
	users, err := s.querier.GetTotalUsers(ctx)
	if err != nil {
		return nil, err
	}
	admins, err := s.querier.GetTotalAdmins(ctx)
	if err != nil {
		return nil, err
	}
	passwords, err := s.querier.GetTotalPasswords(ctx)
	if err != nil {
		return nil, err
	}
	activeSessions, err := s.querier.GetTotalActiveSessions(ctx)
	if err != nil {
		return nil, err
	}
	return &statsdomain.Total{
		Users:          int32(users),
		Admins:         int32(admins),
		Passwords:      int32(passwords),
		ActiveSessions: int32(activeSessions),
	}, nil
}

func (s *StatsRepository) GetRegisterActivity(ctx context.Context, r statsdomain.TimeRange, viewSaved ...bool) (statsdomain.GraphPoints, error) {
	return nil, nil
}

func (s *StatsRepository) GetUseActivity(ctx context.Context, r statsdomain.TimeRange, viewSaved ...bool) (statsdomain.GraphPoints, error) {
	return nil, nil
}

func (s *StatsRepository) GetCryptMap(ctx context.Context, r statsdomain.TimeRange, viewSaved ...bool) (map[string]int32, error) {
	return nil, nil
}

func (s *StatsRepository) GetTopServices(ctx context.Context, r statsdomain.TimeRange, viewSaved ...bool) (map[string]int32, error) {
	return nil, nil
}
