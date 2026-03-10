package logging

import (
	"context"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func UnaryServerInterceptor() grpc.UnaryServerInterceptor {
	return func(ctx context.Context, req any, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (resp any, err error) {
		startedAt := time.Now()
		resp, err = handler(ctx, req)

		fields := []Field{
			F("method", info.FullMethod),
			F("duration_ms", time.Since(startedAt).Milliseconds()),
		}

		if err == nil {
			Info("grpc request handled", fields...)
			return resp, nil
		}

		st, ok := status.FromError(err)
		if !ok {
			st = status.New(codes.Unknown, err.Error())
		}
		fields = append(fields, F("code", st.Code().String()), F("error", err.Error()))

		switch st.Code() {
		case codes.InvalidArgument, codes.NotFound, codes.AlreadyExists, codes.PermissionDenied, codes.Unauthenticated, codes.FailedPrecondition, codes.Aborted, codes.OutOfRange, codes.Canceled, codes.ResourceExhausted:
			Warn("grpc request failed", fields...)
		default:
			Error("grpc request failed", fields...)
		}

		return resp, err
	}
}
