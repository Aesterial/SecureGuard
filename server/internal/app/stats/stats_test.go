package statsapp

import (
	"context"
	"errors"
	"testing"
	"time"

	statsdomain "github.com/aesterial/secureguard/internal/domain/stats"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
)

type statsRepoMock struct {
	byDateFn func(context.Context, statsdomain.TimeRange, ...bool) (*statsdomain.Stats, error)
	totalFn  func(context.Context) (*statsdomain.Total, error)
}

func (m *statsRepoMock) ByDate(ctx context.Context, r statsdomain.TimeRange, viewSaved ...bool) (*statsdomain.Stats, error) {
	if m.byDateFn != nil {
		return m.byDateFn(ctx, r, viewSaved...)
	}
	return nil, nil
}

func (m *statsRepoMock) GetLatency(context.Context, statsdomain.TimeRange, ...bool) (*statsdomain.Latency, error) {
	return nil, nil
}
func (m *statsRepoMock) GetTotal(ctx context.Context) (*statsdomain.Total, error) {
	if m.totalFn != nil {
		return m.totalFn(ctx)
	}
	return nil, nil
}
func (m *statsRepoMock) GetActivity(context.Context, statsdomain.TimeRange) (*statsdomain.ActivityStats, error) {
	return nil, nil
}
func (m *statsRepoMock) GetUsersPreferences(context.Context) (*statsdomain.PreferencesStats, error) {
	return nil, nil
}
func (m *statsRepoMock) GetTopServices(context.Context, statsdomain.TimeRange, ...bool) (map[string]int32, error) {
	return nil, nil
}

func TestByDateRejectsZeroRange(t *testing.T) {
	service := NewStatsService(&statsRepoMock{})
	_, err := service.ByDate(context.Background(), statsdomain.TimeRange{})
	if !errors.Is(err, apperrors.InvalidArguments) {
		t.Fatalf("expected invalid arguments, got %v", err)
	}
}

func TestByDatePassesThroughViewSaved(t *testing.T) {
	now := time.Now()
	rangeIn := statsdomain.TimeRange{Start: now, End: now.Add(time.Hour)}
	expected := &statsdomain.Stats{}
	called := false

	service := NewStatsService(&statsRepoMock{
		byDateFn: func(_ context.Context, r statsdomain.TimeRange, viewSaved ...bool) (*statsdomain.Stats, error) {
			called = true
			if r != rangeIn {
				t.Fatalf("unexpected range passed: %#v", r)
			}
			if len(viewSaved) != 1 || !viewSaved[0] {
				t.Fatalf("expected viewSaved=true, got %#v", viewSaved)
			}
			return expected, nil
		},
	})

	got, err := service.ByDate(context.Background(), rangeIn, true)
	if err != nil {
		t.Fatalf("ByDate returned error: %v", err)
	}
	if !called {
		t.Fatalf("expected repository call")
	}
	if got != expected {
		t.Fatalf("unexpected stats pointer")
	}
}

func TestTotalPassThrough(t *testing.T) {
	expected := &statsdomain.Total{Users: 1, Admins: 2, Passwords: 3, ActiveSessions: 4}
	service := NewStatsService(&statsRepoMock{
		totalFn: func(context.Context) (*statsdomain.Total, error) {
			return expected, nil
		},
	})

	got, err := service.Total(context.Background())
	if err != nil {
		t.Fatalf("Total returned error: %v", err)
	}
	if got != expected {
		t.Fatalf("unexpected total pointer")
	}
}
