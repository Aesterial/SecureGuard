package statsdomain

import "context"

type Repository interface {
	ByDate(ctx context.Context, r TimeRange, viewSaved ...bool) (*Stats, error)
	GetLatency(ctx context.Context, r TimeRange, viewSaved ...bool) (*Latency, error)
	GetTotal(ctx context.Context)(*Total, error)
	GetRegisterActivity(ctx context.Context, r TimeRange, viewSaved ...bool) (GraphPoints, error)
	GetUseActivity(ctx context.Context, r TimeRange, viewSaved ...bool) (GraphPoints, error)
	GetCryptMap(ctx context.Context, r TimeRange, viewSaved ...bool) (map[string]int32, error)
	GetTopServices(ctx context.Context, r TimeRange, viewSaved ...bool) (map[string]int32, error)
}
