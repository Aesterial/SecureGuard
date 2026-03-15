package statsdomain

import (
	"reflect"
	"testing"
	"time"
)

func TestNewLatencyUsesPercentileValues(t *testing.T) {
	data := []float32{50, 10, 30, 40, 20}
	original := append([]float32(nil), data...)

	got := NewLatency(data)
	if got.P50 != 30 || got.P90 != 50 {
		t.Fatalf("unexpected latency values: %#v", got)
	}
	if !reflect.DeepEqual(data, original) {
		t.Fatalf("input slice must not be mutated")
	}
}

func TestNewTimeRangeUsesProvidedDate(t *testing.T) {
	loc := time.FixedZone("UTC+3", 3*60*60)
	at := time.Date(2026, time.March, 15, 13, 42, 10, 0, loc)

	got := NewTimeRange(at)
	wantStart := time.Date(2026, time.March, 15, 0, 0, 0, 0, loc)
	wantEnd := time.Date(2026, time.March, 16, 0, 0, 0, 0, loc)

	if !got.Start.Equal(wantStart) || !got.End.Equal(wantEnd) {
		t.Fatalf("unexpected range: %#v", got)
	}
}
