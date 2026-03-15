package repos

import (
	"testing"

	loggingdomain "github.com/aesterial/secureguard/internal/domain/logging"
)

func TestBuildRealtimeTopServicesSkipsInvalidMethods(t *testing.T) {
	entries := []loggingdomain.Entry{
		{},
		{Fields: map[string]string{"method": ""}},
		{Fields: map[string]string{"method": "   "}},
		{Fields: map[string]string{"method": "/xyz.secureguard.v1.passwords.v1.PasswordService/List"}},
		{Fields: map[string]string{"method": "/xyz.secureguard.v1.passwords.v1.PasswordService/List"}},
		{Fields: map[string]string{"method": "StatsService/Today"}},
	}

	got := buildRealtimeTopServices(entries)

	if _, exists := got[""]; exists {
		t.Fatalf("expected empty method to be skipped, got: %#v", got)
	}

	if got["PasswordService/List"] != 2 {
		t.Fatalf("expected PasswordService/List=2, got: %#v", got)
	}

	if got["StatsService/Today"] != 1 {
		t.Fatalf("expected StatsService/Today=1, got: %#v", got)
	}
}

func TestCountHourlyServiceUsageSkipsInvalidAndRegister(t *testing.T) {
	entries := []loggingdomain.Entry{
		{},
		{Fields: map[string]string{"method": ""}},
		{Fields: map[string]string{"method": "/xyz.secureguard.v1.login.v1.LoginService/Register"}},
		{Fields: map[string]string{"method": "/xyz.secureguard.v1.login.v1.LoginService/Authorize"}},
		{Fields: map[string]string{"method": "/xyz.secureguard.v1.passwords.v1.PasswordService/List"}},
	}

	got := countHourlyServiceUsage(entries)

	if got != 2 {
		t.Fatalf("expected 2 service usages, got %d", got)
	}
}
