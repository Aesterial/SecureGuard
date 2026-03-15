package configapp

import (
	"reflect"
	"testing"

	cfgdomain "github.com/aesterial/secureguard/internal/domain/config"
)

func resetConfigEnv(t *testing.T) {
	t.Helper()
	env = cfgdomain.Config{}
	t.Cleanup(func() {
		env = cfgdomain.Config{}
	})
}

func TestEnvValueReturnsFirstNotEmpty(t *testing.T) {
	resetConfigEnv(t)
	t.Setenv("KEY_ONE", "")
	t.Setenv("KEY_TWO", " value ")

	got := envValue("KEY_ONE", "KEY_TWO")
	if got != "value" {
		t.Fatalf("expected value, got %q", got)
	}
}

func TestParseListUsesDefaultsAndTrimsValues(t *testing.T) {
	resetConfigEnv(t)
	defaults := []string{"127.0.0.1:9092"}
	t.Setenv("BROKERS", " 127.0.0.1:9092, , 10.0.0.1:9092 ")

	got := parseList("BROKERS", defaults)
	want := []string{"127.0.0.1:9092", "10.0.0.1:9092"}
	if !reflect.DeepEqual(got, want) {
		t.Fatalf("unexpected list: got %#v want %#v", got, want)
	}
}

func TestParseTypeSupportsCommonTypes(t *testing.T) {
	resetConfigEnv(t)

	t.Setenv("P_INT", "8080")
	if got := parseType("P_INT", 5000); got != 8080 {
		t.Fatalf("expected parsed int, got %d", got)
	}

	t.Setenv("P_BOOL", "true")
	if got := parseType("P_BOOL", false); !got {
		t.Fatalf("expected parsed bool true")
	}

	t.Setenv("P_STR", "debug")
	if got := parseType("P_STR", "info"); got != "debug" {
		t.Fatalf("expected parsed string, got %q", got)
	}
}

func TestGetCachesLoadedConfig(t *testing.T) {
	resetConfigEnv(t)

	t.Setenv("BOOT_PORT", "7001")
	first := Get()
	if first.Boot.Port != 7001 {
		t.Fatalf("expected first port 7001, got %d", first.Boot.Port)
	}

	t.Setenv("BOOT_PORT", "9001")
	second := Get()
	if second.Boot.Port != 7001 {
		t.Fatalf("expected cached port 7001, got %d", second.Boot.Port)
	}
}
