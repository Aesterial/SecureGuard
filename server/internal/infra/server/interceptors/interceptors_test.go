package interceptors

import (
	"context"
	"errors"
	"testing"

	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func TestServerPanicRecoveryReturnsServerError(t *testing.T) {
	err := ServerPanicRecovery(context.Background(), "panic payload")
	if !errors.Is(err, apperrors.ServerError) {
		t.Fatalf("expected server error, got %v", err)
	}
}

func TestLoggingServerInterceptorSuccess(t *testing.T) {
	interceptor := LoggingServerInterceptor()
	info := &grpc.UnaryServerInfo{FullMethod: "/xyz.secureguard.v1.users.v1.UserService/Info"}
	req := "request"
	called := false

	resp, err := interceptor(context.Background(), req, info, func(ctx context.Context, in any) (any, error) {
		called = true
		if in != req {
			t.Fatalf("unexpected req in handler: %v", in)
		}
		return "ok", nil
	})
	if err != nil {
		t.Fatalf("expected nil error, got %v", err)
	}
	if !called {
		t.Fatalf("expected handler call")
	}
	if resp != "ok" {
		t.Fatalf("unexpected response: %v", resp)
	}
}

func TestLoggingServerInterceptorStatusError(t *testing.T) {
	interceptor := LoggingServerInterceptor()
	info := &grpc.UnaryServerInfo{FullMethod: "/xyz.secureguard.v1.passwords.v1.PasswordService/List"}
	expected := status.Error(codes.NotFound, "missing")

	resp, err := interceptor(context.Background(), nil, info, func(context.Context, any) (any, error) {
		return nil, expected
	})
	if resp != nil {
		t.Fatalf("expected nil response, got %v", resp)
	}
	if status.Code(err) != codes.NotFound {
		t.Fatalf("expected not found code, got %v", status.Code(err))
	}
}

func TestLoggingServerInterceptorPlainError(t *testing.T) {
	interceptor := LoggingServerInterceptor()
	info := &grpc.UnaryServerInfo{FullMethod: "/xyz.secureguard.v1.login.v1.LoginService/Authorize"}
	expected := errors.New("boom")

	resp, err := interceptor(context.Background(), nil, info, func(context.Context, any) (any, error) {
		return nil, expected
	})
	if resp != nil {
		t.Fatalf("expected nil response, got %v", resp)
	}
	if !errors.Is(err, expected) {
		t.Fatalf("expected original error, got %v", err)
	}
}
