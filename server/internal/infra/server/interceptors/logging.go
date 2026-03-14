package interceptors

import (
	"context"
	"time"

	logging "github.com/aesterial/secureguard/internal/app/logging"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func LoggingServerInterceptor() grpc.UnaryServerInterceptor {
	return func(ctx context.Context, req any, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (resp any, err error) {
		startedAt := time.Now()
		resp, err = handler(ctx, req)

		fields := []logging.Field{
			logging.F("method", info.FullMethod),
			logging.F("duration_ms", time.Since(startedAt).Milliseconds()),
		}

		if err == nil {
			logging.Info("grpc request handled", fields...)
			return resp, nil
		}

		st, ok := status.FromError(err)
		if !ok {
			st = status.New(codes.Unknown, err.Error())
		}
		fields = append(fields, logging.F("code", st.Code().String()), logging.F("error", err.Error()))

		switch st.Code() {
		case codes.InvalidArgument, codes.NotFound, codes.AlreadyExists, codes.PermissionDenied, codes.Unauthenticated, codes.FailedPrecondition, codes.Aborted, codes.OutOfRange, codes.Canceled, codes.ResourceExhausted:
			logging.Warn("grpc request failed", fields...)
		default:
			logging.Error("grpc request failed", fields...)
		}

		return resp, err
	}
}
