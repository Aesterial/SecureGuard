package ratelimitdomain

import (
	"net"
	"strings"
	"time"
)

type Bucket string

const (
	AuthorizeBucket Bucket = "authorize"
	RegisterBucket  Bucket = "register"
	MetaBucket      Bucket = "meta"
)

type Rule struct {
	Limit  int
	Window time.Duration
}

func (r Rule) IsZero() bool {
	return r.Limit <= 0 || r.Window <= 0
}

type Rules struct {
	Authorize Rule
	Register  Rule
	Meta      Rule
}

func FirstForwardedIP(value string) string {
	for _, part := range strings.Split(value, ",") {
		if ip := NormalizeIP(part); ip != "" {
			return ip
		}
	}
	return ""
}

func NormalizeIP(value string) string {
	value = strings.TrimSpace(value)
	if value == "" {
		return ""
	}
	if host, _, err := net.SplitHostPort(value); err == nil {
		value = host
	}
	value = strings.Trim(value, "[]")
	ip := net.ParseIP(value)
	if ip == nil {
		return ""
	}
	return ip.String()
}

func NormalizeKey(value string) string {
	value = strings.TrimSpace(value)
	if value == "" {
		return "unknown"
	}
	value = strings.ReplaceAll(value, " ", "_")
	value = strings.ReplaceAll(value, ":", "_")
	value = strings.ReplaceAll(value, "/", "_")
	value = strings.ReplaceAll(value, "\\", "_")
	value = strings.ReplaceAll(value, ",", "_")
	return value
}
