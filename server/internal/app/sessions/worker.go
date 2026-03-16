package sessionsapp

import (
	"context"
	"time"

	sessionsdomain "github.com/aesterial/secureguard/internal/domain/sessions"
	"github.com/aesterial/secureguard/internal/shared/logging"
)

type Worker struct {
	repo sessionsdomain.Repository
}

func NewWorker(repo sessionsdomain.Repository) *Worker {
	return &Worker{repo: repo}
}

func (w *Worker) Start(ctx context.Context) {
	if w == nil || w.repo == nil {
		return
	}
	go w.loop(ctx)
}

func (w *Worker) loop(ctx context.Context) {
	ticker := time.NewTicker(30 * time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-ctx.Done():
			return

		case <-ticker.C:
			list, err := w.repo.GetExpired(ctx)
			if err != nil {
				logging.Error("received error in worker loop", logging.F("error", err.Error()))
				continue
			}

			for _, e := range list {
				if e == nil {
					continue
				}

				if err := w.repo.Revoke(ctx, *e); err != nil {
					logging.Error("failed to revoke session", logging.F("error", err.Error()))
				}
			}
		}
	}
}
