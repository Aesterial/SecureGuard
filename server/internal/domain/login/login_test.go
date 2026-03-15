package logindomain

import "testing"

func TestNormalizeSanitizesAndTruncatesUsername(t *testing.T) {
	got := (Require{Username: "abcDEF123___", Password: "pass"}).Normalize()
	if got.Username != "abc123" {
		t.Fatalf("expected sanitized username abc123, got %q", got.Username)
	}

	long := (Require{Username: "abcdefghijklmnopqrstuvwxyz0123456789"}).Normalize()
	if len(long.Username) != maxUsernameLen {
		t.Fatalf("expected username length %d, got %d", maxUsernameLen, len(long.Username))
	}
}

func TestNormalizeGeneratesUsernameForShortInput(t *testing.T) {
	got := (Require{Username: "A!"}).Normalize()
	if len(got.Username) < minUsernameLen || len(got.Username) > maxUsernameLen {
		t.Fatalf("unexpected generated username length: %d", len(got.Username))
	}
	if got.Username[:4] != "user" {
		t.Fatalf("expected generated username prefix user, got %q", got.Username)
	}
	for i := 0; i < len(got.Username); i++ {
		c := got.Username[i]
		allowed := (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')
		if !allowed {
			t.Fatalf("generated username contains invalid char %q", c)
		}
	}
}

func TestRandIntNonPositiveReturnsZero(t *testing.T) {
	if got := randInt(0); got != 0 {
		t.Fatalf("expected 0, got %d", got)
	}
	if got := randInt(-1); got != 0 {
		t.Fatalf("expected 0, got %d", got)
	}
}
