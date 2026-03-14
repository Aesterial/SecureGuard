package loggingapp

import (
	"context"
	"testing"
	"time"
)

type testReader struct {
	entries []Entry
}

func (r testReader) Read(_ context.Context, query Query) ([]Entry, error) {
	out := make([]Entry, 0, len(r.entries))
	for _, entry := range r.entries {
		if query.Matches(entry) {
			out = append(out, entry)
		}
	}
	return out, nil
}

func (testReader) Close() error { return nil }

func TestRequestDurationsFiltersByMethod(t *testing.T) {
	service := &Service{
		logger: noopLogger{},
		reader: testReader{
			entries: []Entry{
				{
					Message: "grpc request handled",
					Fields: map[string]string{
						"method":      "/users.v1.UserService/GetProfile",
						"duration_ms": "12",
					},
				},
				{
					Message: "grpc request handled",
					Fields: map[string]string{
						"method":      "/users.v1.UserService/GetProfile",
						"duration_ms": "27",
					},
				},
				{
					Message: "grpc request handled",
					Fields: map[string]string{
						"method":      "/login.v1.LoginService/Authorize",
						"duration_ms": "99",
					},
				},
			},
		},
	}

	durations, err := service.RequestDurations(context.Background(), RequestDurationsQuery{
		Method: "/users.v1.UserService/GetProfile",
	})
	if err != nil {
		t.Fatalf("RequestDurations returned error: %v", err)
	}
	if len(durations) != 2 {
		t.Fatalf("expected 2 durations, got %d", len(durations))
	}
	if durations[0] != 12*time.Millisecond || durations[1] != 27*time.Millisecond {
		t.Fatalf("unexpected durations: %v", durations)
	}
}

func TestRequestDurationsSkipsInvalidDuration(t *testing.T) {
	service := &Service{
		logger: noopLogger{},
		reader: testReader{
			entries: []Entry{
				{
					Message: "grpc request handled",
					Fields: map[string]string{
						"duration_ms": "10",
					},
				},
				{
					Message: "grpc request handled",
					Fields: map[string]string{
						"duration_ms": "bad",
					},
				},
			},
		},
	}

	durations, err := service.RequestDurations(context.Background(), RequestDurationsQuery{})
	if err != nil {
		t.Fatalf("RequestDurations returned error: %v", err)
	}
	if len(durations) != 1 {
		t.Fatalf("expected 1 duration, got %d", len(durations))
	}
	if durations[0] != 10*time.Millisecond {
		t.Fatalf("unexpected duration: %v", durations[0])
	}
}
