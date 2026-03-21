package server

import (
	"context"

	ratelimitdomain "github.com/aesterial/secureguard/internal/domain/ratelimit"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/peer"
)

func clientIPFromContext(ctx context.Context) string {
	if ctx == nil {
		return "unknown"
	}
	if ip := forwardedIPFromContext(ctx); ip != "" {
		return ip
	}
	if p, ok := peer.FromContext(ctx); ok && p != nil && p.Addr != nil {
		if ip := ratelimitdomain.NormalizeIP(p.Addr.String()); ip != "" {
			return ip
		}
	}
	return "unknown"
}

func forwardedIPFromContext(ctx context.Context) string {
	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return ""
	}
	for _, header := range []string{"x-forwarded-for", "x-real-ip"} {
		for _, raw := range md.Get(header) {
			if ip := ratelimitdomain.FirstForwardedIP(raw); ip != "" {
				return ip
			}
		}
	}
	return ""
}
