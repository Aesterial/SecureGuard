package statsapp

import (
	"testing"
	"time"
)

func TestNextHourBoundary(t *testing.T) {
	at := time.Date(2026, time.March, 15, 10, 37, 12, 0, time.UTC)
	got := nextHourBoundary(at)
	want := time.Date(2026, time.March, 15, 11, 0, 0, 0, time.UTC)

	if !got.Equal(want) {
		t.Fatalf("expected %v, got %v", want, got)
	}
}

func TestNextMidnightBoundary(t *testing.T) {
	at := time.Date(2026, time.March, 15, 23, 37, 12, 0, time.UTC)
	got := nextMidnightBoundary(at)
	want := time.Date(2026, time.March, 16, 0, 0, 0, 0, time.UTC)

	if !got.Equal(want) {
		t.Fatalf("expected %v, got %v", want, got)
	}
}
