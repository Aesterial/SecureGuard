package statsdomain

import "context"

type Repository interface {
	ByDate(ctx context.Context, r TimeRange, viewSaved ...bool) (*Stats, error)
	GetLatency(ctx context.Context, r TimeRange, viewSaved ...bool) (*Latency, error)
	GetTotal(ctx context.Context) (*Total, error)
	GetActivity(ctx context.Context, r TimeRange) (*ActivityStats, error)
	GetUsersPreferences(ctx context.Context) (*PreferencesStats, error)
	GetTopServices(ctx context.Context, r TimeRange, viewSaved ...bool) (map[string]int32, error)
}
