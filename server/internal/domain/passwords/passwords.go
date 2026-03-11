package passdomain

import (
	"net/url"
	"strings"
	"time"

	"github.com/aesterial/secureguard/internal/domain"
)

type Target int

const (
	ServiceTarget Target = iota
	LoginTarget
	PassTarget
)

func ParseService(s string) Service {
	s = strings.TrimSpace(s)

	result := Service{name: s}
	if s == "" {
		return result
	}

	if !strings.Contains(s, ".") && !strings.Contains(s, "://") {
		return result
	}

	raw := s
	if !strings.Contains(raw, "://") {
		raw = "https://" + raw
	}

	u, err := url.Parse(raw)
	if err != nil || u.Hostname() == "" {
		return result
	}

	host := strings.TrimPrefix(strings.ToLower(u.Hostname()), "www.")
	result.name = serviceNameFromHost(host)
	result.url = &host

	return result
}

func serviceNameFromHost(host string) string {
	parts := strings.Split(host, ".")
	if len(parts) == 0 {
		return host
	}
	return parts[0]
}

type Service struct {
	url  *string
	name string
}

type Password struct {
	ID       domain.UUID
	Service  Service
	Login    string
	Password string
	Created  time.Time
}

type Passwords []*Password
