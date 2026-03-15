package statsapp

import (
	"context"
	"time"

	logging "github.com/aesterial/secureguard/internal/app/logging"
	statsdomain "github.com/aesterial/secureguard/internal/domain/stats"
)

type PersistenceWorker struct {
	repo statsdomain.PersistenceRepository
	now  func() time.Time
}

func NewPersistenceWorker(repo statsdomain.PersistenceRepository) *PersistenceWorker {
	return &PersistenceWorker{
		repo: repo,
		now:  time.Now,
	}
}

func (w *PersistenceWorker) Start(ctx context.Context) {
	if w == nil || w.repo == nil {
		return
	}

	go w.runHourly(ctx)
	go w.runDaily(ctx)
}

func (w *PersistenceWorker) runHourly(ctx context.Context) {
	next := nextHourBoundary(w.now())
	logging.Info("hourly activity worker scheduled", logging.F("next_run_at", next))

	for {
		if !waitUntil(ctx, next) {
			return
		}

		hourStart := next.Add(-time.Hour)
		if err := w.repo.SaveHourlyActivity(ctx, hourStart); err != nil {
			logging.Error("failed to persist hourly activity", logging.F("at", hourStart), logging.F("error", err.Error()))
		} else {
			logging.Info("hourly activity persisted", logging.F("at", hourStart))
		}

		next = next.Add(time.Hour)
	}
}

func (w *PersistenceWorker) runDaily(ctx context.Context) {
	next := nextMidnightBoundary(w.now())
	logging.Info("daily statistics worker scheduled", logging.F("next_run_at", next))

	for {
		if !waitUntil(ctx, next) {
			return
		}

		dayStart := next.AddDate(0, 0, -1)
		if err := w.repo.SaveDailyStatistics(ctx, dayStart); err != nil {
			logging.Error("failed to persist daily statistics", logging.F("at", dayStart), logging.F("error", err.Error()))
		} else {
			logging.Info("daily statistics persisted", logging.F("at", dayStart))
		}

		next = next.AddDate(0, 0, 1)
	}
}

func waitUntil(ctx context.Context, next time.Time) bool {
	timer := time.NewTimer(time.Until(next))
	defer timer.Stop()

	select {
	case <-ctx.Done():
		return false
	case <-timer.C:
		return true
	}
}

func nextHourBoundary(at time.Time) time.Time {
	return at.Truncate(time.Hour).Add(time.Hour)
}

func nextMidnightBoundary(at time.Time) time.Time {
	return time.Date(at.Year(), at.Month(), at.Day()+1, 0, 0, 0, 0, at.Location())
}
