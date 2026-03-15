package repos

import (
	"context"
	"encoding/json"
	"errors"
	"strconv"
	"strings"
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
	if r.IsZero() {
		return nil, apperrors.InvalidArguments
	}
	var resp statsdomain.Stats
	var err error
	resp.Activity, err = s.GetActivity(ctx, r)
	if err != nil {
		logging.Info("failed to get activity: " + err.Error())
		return nil, err
	}
	resp.Selected, err = s.GetUsersPreferences(ctx)
	if err != nil {
		logging.Info("failed to get selected: " + err.Error())
		return nil, err
	}

	if s.parseView(viewSaved...) {
		resp.Latency, err = s.GetLatency(ctx, r, viewSaved...)
		if err != nil {
			logging.Info("failed to get latency: " + err.Error())
			return nil, err
		}
		resp.Services, err = s.GetTopServices(ctx, r, viewSaved...)
		if err != nil {
			logging.Info("failed to top of services: " + err.Error())
			return nil, err
		}
		return &resp, nil
	}

	entries, err := s.readRealtimeEntries(ctx, r)
	if err != nil {
		return nil, err
	}

	resp.Latency = buildRealtimeLatency(entries)
	resp.Services = buildRealtimeTopServices(entries)
	return &resp, nil
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
				logging.Info("records of latency saved not found")
				return nil, apperrors.NotFound
			}
			return nil, err
		}
		latency.P50 = row.P50
		latency.P90 = row.P90
	} else {
		list, err := s.readRealtimeEntries(ctx, r)
		if err != nil {
			return nil, err
		}
		latency = *buildRealtimeLatency(list)
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

func (s *StatsRepository) GetActivity(ctx context.Context, r statsdomain.TimeRange) (*statsdomain.ActivityStats, error) {
	if r.IsZero() {
		return nil, apperrors.InvalidArguments
	}
	activity, err := s.querier.GetActivityStatistics(ctx, dbsqlc.GetActivityStatisticsParams{At: pgtype.Timestamptz{Time: r.Start, Valid: true}, At_2: pgtype.Timestamptz{Time: r.End, Valid: true}})
	if err != nil {
		return nil, err
	}
	var resp statsdomain.ActivityStats
	for _, e := range activity {
		resp.Register = append(resp.Register, &statsdomain.GraphPoint{At: e.At.Time, Value: e.Registers})
		resp.Users = append(resp.Users, &statsdomain.GraphPoint{At: e.At.Time, Value: e.Users})
	}
	return &resp, nil
}

func (s *StatsRepository) GetTopServices(ctx context.Context, r statsdomain.TimeRange, viewSaved ...bool) (map[string]int32, error) {
	if r.IsZero() {
		return nil, apperrors.InvalidArguments
	}
	var services map[string]int32
	if s.parseView(viewSaved...) {
		row, err := s.querier.GetServicesTopStats(ctx, pgtype.Timestamptz{Time: r.Start, Valid: true})
		if err != nil {
			return nil, err
		}
		if err := json.Unmarshal(row, &services); err != nil {
			return nil, err
		}
	} else {
		list, err := s.readRealtimeEntries(ctx, r)
		if err != nil {
			return nil, err
		}
		services = buildRealtimeTopServices(list)
	}
	return services, nil
}

func (s *StatsRepository) parsePreferencesValues(list []string) map[string]int32 {
	resp := make(map[string]int32, len(list))
	for _, v := range list {
		resp[v]++
	}
	return resp
}

func (s *StatsRepository) GetUsersPreferences(ctx context.Context) (*statsdomain.PreferencesStats, error) {
	themes, err := s.querier.GetChoosenPreferencesTheme(ctx)
	if err != nil {
		return nil, err
	}
	langs, err := s.querier.GetChoosenPreferencesLanguage(ctx)
	if err != nil {
		return nil, err
	}
	crypts, err := s.querier.GetChoosenPreferencesCrypt(ctx)
	if err != nil {
		return nil, err
	}
	return &statsdomain.PreferencesStats{
		Theme: s.parsePreferencesValues(themes),
		Crypt: s.parsePreferencesValues(crypts),
		Lang:  s.parsePreferencesValues(langs),
	}, nil
}

func (s *StatsRepository) SaveDailyStatistics(ctx context.Context, at time.Time) error {
	start := normalizeDayStart(at)
	end := start.AddDate(0, 0, 1)

	entries, err := s.readRealtimeEntries(ctx, statsdomain.TimeRange{Start: start, End: end})
	if err != nil {
		return err
	}

	latency := buildRealtimeLatency(entries)
	services := buildRealtimeTopServices(entries)
	preferences, err := s.GetUsersPreferences(ctx)
	if err != nil {
		return err
	}

	servicesTop, err := json.Marshal(services)
	if err != nil {
		return err
	}
	cryptUses, err := json.Marshal(preferences.Crypt)
	if err != nil {
		return err
	}

	return s.querier.CreateStatisticsSnapshot(ctx, dbsqlc.CreateStatisticsSnapshotParams{
		P50:         latency.P50,
		P90:         latency.P90,
		ServicesTop: servicesTop,
		CryptUses:   cryptUses,
		At:          pgtype.Timestamptz{Time: start, Valid: true},
	})
}

func (s *StatsRepository) SaveHourlyActivity(ctx context.Context, at time.Time) error {
	start := normalizeHourStart(at)
	end := start.Add(time.Hour)

	registers, err := s.querier.CountUsersRegisteredBetween(ctx, dbsqlc.CountUsersRegisteredBetweenParams{
		Joined:   pgtype.Timestamptz{Time: start, Valid: true},
		Joined_2: pgtype.Timestamptz{Time: end, Valid: true},
	})
	if err != nil {
		return err
	}

	entries, err := s.readRealtimeEntries(ctx, statsdomain.TimeRange{Start: start, End: end})
	if err != nil {
		return err
	}

	return s.querier.CreateActivitySnapshot(ctx, dbsqlc.CreateActivitySnapshotParams{
		Users:     int32(countHourlyServiceUsage(entries)),
		Registers: int32(registers),
		At:        pgtype.Timestamptz{Time: start, Valid: true},
	})
}

func (s *StatsRepository) readRealtimeEntries(ctx context.Context, r statsdomain.TimeRange) ([]loggingdomain.Entry, error) {
	until := r.End
	if !until.IsZero() {
		until = until.Add(-time.Nanosecond)
	}
	return logging.ReadEntries(ctx, loggingdomain.Query{Since: r.Start, Until: until})
}

func buildRealtimeLatency(list []loggingdomain.Entry) *statsdomain.Latency {
	entries := make([]float32, 0, len(list))
	for _, e := range list {
		duration, exists := e.Field("duration_ms")
		if !exists {
			continue
		}
		durationFloat64, err := strconv.ParseFloat(duration, 32)
		if err != nil {
			continue
		}
		entries = append(entries, float32(durationFloat64))
	}
	latency := statsdomain.NewLatency(entries)
	return &latency
}

func buildRealtimeTopServices(list []loggingdomain.Entry) map[string]int32 {
	services := make(map[string]int32, len(list))
	for _, e := range list {
		method := normalizeRealtimeMethod(e)
		if method == "" {
			continue
		}
		services[method]++
	}
	return services
}

func countHourlyServiceUsage(list []loggingdomain.Entry) int {
	var total int
	for _, e := range list {
		method := normalizeRealtimeMethod(e)
		if method == "" || method == "LoginService/Register" {
			continue
		}
		total++
	}
	return total
}

func normalizeRealtimeMethod(entry loggingdomain.Entry) string {
	method, ok := entry.Field("method")
	if !ok {
		return ""
	}
	method = strings.TrimSpace(method)
	if method == "" {
		return ""
	}
	index := strings.LastIndex(method, ".")
	if index == -1 || index == len(method)-1 {
		return method
	}
	return method[index+1:]
}

func normalizeDayStart(at time.Time) time.Time {
	return time.Date(at.Year(), at.Month(), at.Day(), 0, 0, 0, 0, at.Location())
}

func normalizeHourStart(at time.Time) time.Time {
	return at.Truncate(time.Hour)
}
