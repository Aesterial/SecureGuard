package safe

import (
	"context"
	"errors"
	"fmt"
	"reflect"
	"runtime/debug"
	"sync"
	"time"

	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/jackc/pgx/v5"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type PanicError struct {
	Value any
	Stack []byte
}

func (e *PanicError) Error() string {
	return fmt.Sprintf("panic recovered: %v", e.Value)
}

func Go(ctx context.Context, fn func(context.Context) error, onError func(context.Context, error)) {
	if fn == nil {
		return
	}
	if ctx == nil {
		ctx = context.Background()
	}

	go func(ctx context.Context) {
		if err := run(ctx, fn); err != nil && onError != nil {
			onError(ctx, err)
		}
	}(ctx)
}

func run(ctx context.Context, fn func(context.Context) error) (err error) {
	defer func() {
		if r := recover(); r != nil {
			err = &PanicError{
				Value: r,
				Stack: debug.Stack(),
			}
		}
	}()

	return fn(ctx)
}

func Recovery(errPointer *error) func() {
	return func() {
		if recv := recover(); recv != nil {
			stack := debug.Stack()
			err := fmt.Errorf("panic received: %v", recv)
			fmt.Println(err.Error(), string(stack))
			if errPointer != nil {
				*errPointer = err
			}
		}
	}
}

func skippableForHydration(err error) bool {
	if err == nil {
		return false
	}
	if errors.Is(err, pgx.ErrNoRows) {
		return true
	}
	if status.Code(err) == codes.NotFound {
		return true
	}
	var appErr apperrors.ErrorST
	if errors.As(err, &appErr) {
		return appErr.GRPCStatus().Code() == codes.NotFound
	}
	return false
}

func Hydration[R any, E any](timeout time.Duration, fn func(context.Context, ...any) (R, error), sFn []func(context.Context, E) (E, error), count int) (R, error) {
	var empty R
	if count < 0 {
		return empty, errors.New("invalid args")
	}
	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()
	var wg sync.WaitGroup
	var once sync.Once
	var fErr error
	logErr := func(err error, logTag string) {
		if err == nil {
			return
		}
		once.Do(func() {
			fErr = err
			cancel()
		})
	}
	data, err := fn(ctx)
	if err != nil {
		return empty, err
	}
	v := reflect.ValueOf(data)
	t := reflect.TypeOf(data)
	switch {
	case !v.IsValid() || t == nil:
		return empty, errors.New("empty response")
	case t.Kind() == reflect.Slice:
		if len(sFn) == 0 {
			return data, nil
		}
		if count == 0 {
			count = v.Len()
		}
		if count <= 0 {
			count = 1
		}
		response := reflect.MakeSlice(t, v.Len(), v.Len())
		sem := make(chan struct{}, count)
		for i := range v.Len() {
			element := v.Index(i).Interface()
			elem, ok := element.(E)
			if !ok {
				return empty, fmt.Errorf("invalid element type at index %d: %T", i, element)
			}
			wg.Go(func() {
				select {
				case sem <- struct{}{}:
				case <-ctx.Done():
					return
				}
				defer func() { <-sem }()
				current := elem
				for _, hydrateFn := range sFn {
					if hydrateFn == nil {
						continue
					}
					current, err = hydrateFn(ctx, current)
					if err != nil {
						if skippableForHydration(err) {
							return
						}
						logErr(err, "safe.hydration")
						return
					}
				}
				response.Index(i).Set(reflect.ValueOf(current))
			})
		}
		wg.Wait()
		if fErr != nil {
			return empty, fErr
		}
		filtered := reflect.MakeSlice(t, 0, response.Len())
		for i := range response.Len() {
			item := response.Index(i)
			if !item.IsZero() {
				filtered = reflect.Append(filtered, item)
			}
		}
		result, ok := filtered.Interface().(R)
		if !ok {
			return empty, errors.New("cast error")
		}
		return result, nil
	default:
		if len(sFn) == 0 {
			return data, nil
		}
		elem, ok := any(data).(E)
		if !ok {
			return empty, fmt.Errorf("invalid data type: %T", data)
		}
		current := elem
		for _, hydrateFn := range sFn {
			if hydrateFn == nil {
				continue
			}
			current, err = hydrateFn(ctx, current)
			if err != nil {
				if skippableForHydration(err) {
					return empty, nil
				}
				return empty, err
			}
		}
		result, ok := any(current).(R)
		if !ok {
			return empty, errors.New("cast error")
		}
		return result, nil
	}
}

func GoAsync[T any](ctx context.Context, timeout time.Duration, fn func(context.Context, ...any) (T, error), args ...any) (T, error) {
	type res[B any] struct {
		data B
		err  error
	}
	var empty T
	if fn == nil {
		return empty, errors.New("invalid function")
	}
	if ctx == nil {
		ctx = context.Background()
	}
	cancel := func() {}
	if timeout > 0 {
		ctx, cancel = context.WithTimeout(ctx, timeout)
	}
	defer cancel()
	result := make(chan res[T], 1)
	go func() {
		var r res[T]
		defer func() { result <- r }()
		defer Recovery(&r.err)()
		r.data, r.err = fn(ctx, args...)
	}()
	select {
	case resp := <-result:
		return resp.data, resp.err
	case <-ctx.Done():
		return empty, ctx.Err()
	}
}
