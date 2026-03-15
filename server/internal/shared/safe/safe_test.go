package safe

import (
	"context"
	"errors"
	"reflect"
	"testing"
	"time"

	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
)

func TestRunRecoversPanic(t *testing.T) {
	err := run(context.Background(), func(context.Context) error {
		panic("boom")
	})
	if err == nil {
		t.Fatalf("expected panic error")
	}
	var panicErr *PanicError
	if !errors.As(err, &panicErr) {
		t.Fatalf("expected PanicError, got %T", err)
	}
	if panicErr.Value != "boom" {
		t.Fatalf("unexpected panic value: %v", panicErr.Value)
	}
}

func TestHydrationSliceSkipsNotFoundElements(t *testing.T) {
	got, err := Hydration[[]int, int](
		time.Second,
		func(context.Context, ...any) ([]int, error) {
			return []int{1, 2, 3}, nil
		},
		[]func(context.Context, int) (int, error){
			func(_ context.Context, value int) (int, error) {
				if value == 2 {
					return 0, apperrors.NotFound
				}
				return value * 10, nil
			},
		},
		2,
	)
	if err != nil {
		t.Fatalf("Hydration returned error: %v", err)
	}
	want := []int{10, 30}
	if !reflect.DeepEqual(got, want) {
		t.Fatalf("unexpected hydrated result: got %#v want %#v", got, want)
	}
}

func TestHydrationRejectsNegativeWorkersCount(t *testing.T) {
	_, err := Hydration[[]int, int](
		time.Second,
		func(context.Context, ...any) ([]int, error) { return []int{1}, nil },
		nil,
		-1,
	)
	if err == nil {
		t.Fatalf("expected invalid args error")
	}
}

func TestGoAsyncHonorsTimeout(t *testing.T) {
	_, err := GoAsync[int](context.Background(), 5*time.Millisecond, func(ctx context.Context, _ ...any) (int, error) {
		select {
		case <-time.After(50 * time.Millisecond):
			return 1, nil
		case <-ctx.Done():
			return 0, ctx.Err()
		}
	})
	if !errors.Is(err, context.DeadlineExceeded) {
		t.Fatalf("expected deadline exceeded, got %v", err)
	}
}
