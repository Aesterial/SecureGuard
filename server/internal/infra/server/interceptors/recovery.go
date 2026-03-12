package interceptors

import (
	"context"
	"log/slog"

	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
)

func ServerPanicRecovery(ctx context.Context, p any) error {
	slog.ErrorContext(ctx, "panic received", "panic", p)
	return apperrors.ServerError
}
