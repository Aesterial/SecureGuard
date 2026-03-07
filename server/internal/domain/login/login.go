package logindomain

import (
	"crypto/rand"
	"encoding/binary"
	"strings"
)

type Require struct {
	Username string
	Password string
}

func (r Require) IsCredentialsValid() bool {
	return r.Username != "" && r.Password != ""
}

const (
	minUsernameLen = 6
	maxUsernameLen = 20
)

func (r Require) Normalize() Require {
	raw := strings.TrimSpace(r.Username)
	raw = strings.ToLower(raw)

	clean := r.sanitizeUsername()

	if len(clean) > maxUsernameLen {
		clean = clean[:maxUsernameLen]
	}

	if len(clean) < minUsernameLen {
		clean = r.generateUsername(minUsernameLen, maxUsernameLen)
	}

	r.Username = clean
	return r
}

func (r Require) sanitizeUsername() string {
	b := make([]byte, 0, len(r.Username))

	for i := 0; i < len(r.Username); i++ {
		c := r.Username[i]

		allow := (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')

		if allow {
			b = append(b, c)
		}
	}

	return string(b)
}

func (r Require) generateUsername(minLen, maxLen int) string {
	const letters = "abcdefghijklmnopqrstuvwxyz0123456789"
	const prefix = "user"

	n := randInt(maxLen-minLen+1) + minLen

	out := make([]byte, 0, n)
	out = append(out, prefix...)

	for len(out) < n {
		out = append(out, letters[randInt(len(letters))])
	}

	if len(out) > n {
		out = out[:n]
	}

	return string(out)
}

func randInt(n int) int {
	if n <= 0 {
		return 0
	}
	var buf [8]byte
	_, _ = rand.Read(buf[:])
	v := binary.LittleEndian.Uint64(buf[:])
	return int(v % uint64(n))
}

type RegisterRequire struct {
	Require
	Phrase string
}

type AuthorizeRequire struct {
	Require
}

func (r RegisterRequire) IsValid() bool {
	return r.Username != "" && r.Password != "" && r.Phrase != ""
}
