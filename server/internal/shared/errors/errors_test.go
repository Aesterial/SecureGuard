package apperrors

import (
	stderrors "errors"
	"strings"
	"testing"

	"google.golang.org/grpc/codes"
	"google.golang.org/protobuf/types/known/emptypb"
)

func TestWrap(t *testing.T) {
	if Wrap(nil) != nil {
		t.Fatalf("expected nil for Wrap(nil)")
	}

	wrappedExisting := Wrap(InvalidArguments)
	if !stderrors.Is(wrappedExisting, InvalidArguments) {
		t.Fatalf("expected same application error, got %v", wrappedExisting)
	}

	wrapped := Wrap(stderrors.New("boom"))
	var appErr ErrorST
	if !stderrors.As(wrapped, &appErr) {
		t.Fatalf("expected ErrorST, got %T", wrapped)
	}
	if appErr.GRPCStatus().Code() != codes.Internal {
		t.Fatalf("expected internal code, got %s", appErr.GRPCStatus().Code())
	}
	if !strings.Contains(appErr.Error(), "boom") {
		t.Fatalf("expected wrapped message to contain source error, got %q", appErr.Error())
	}
}

func TestWithDetailsAndIs(t *testing.T) {
	enriched := InvalidArguments.WithDetails(&emptypb.Empty{})
	if len(enriched.GRPCStatus().Details()) != 1 {
		t.Fatalf("expected one detail in grpc status")
	}

	custom := InvalidArguments.AddErrDetails("extra")
	if !custom.Is(stderrors.New(custom.Error())) {
		t.Fatalf("expected Is to match same error text")
	}
	if custom.Is(stderrors.New("another")) {
		t.Fatalf("expected Is to reject different text")
	}
}
