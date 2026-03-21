package ratelimitdomain

import "testing"

func TestFirstForwardedIP(t *testing.T) {
	got := FirstForwardedIP("203.0.113.10, 10.0.0.2")
	if got != "203.0.113.10" {
		t.Fatalf("expected first public ip, got %q", got)
	}
}

func TestNormalizeIP(t *testing.T) {
	got := NormalizeIP("[2001:db8::1]:9090")
	if got != "2001:db8::1" {
		t.Fatalf("expected normalized ipv6, got %q", got)
	}
}

func TestNormalizeKey(t *testing.T) {
	got := NormalizeKey(" authorize:203.0.113.10/24 ")
	if got != "authorize_203.0.113.10_24" {
		t.Fatalf("unexpected normalized key: %q", got)
	}
}
