package server

import (
	"context"
	"net"
	"testing"

	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/peer"
)

func TestClientIPFromContextPrefersForwardedHeaders(t *testing.T) {
	ctx := metadata.NewIncomingContext(context.Background(), metadata.Pairs(
		"x-forwarded-for", "203.0.113.10, 10.0.0.2",
	))
	ctx = peer.NewContext(ctx, &peer.Peer{Addr: &net.TCPAddr{IP: net.ParseIP("172.18.0.4"), Port: 50051}})

	if got := clientIPFromContext(ctx); got != "203.0.113.10" {
		t.Fatalf("expected forwarded ip, got %q", got)
	}
}

func TestClientIPFromContextFallsBackToPeer(t *testing.T) {
	ctx := peer.NewContext(context.Background(), &peer.Peer{Addr: &net.TCPAddr{IP: net.ParseIP("172.18.0.4"), Port: 50051}})

	if got := clientIPFromContext(ctx); got != "172.18.0.4" {
		t.Fatalf("expected peer ip, got %q", got)
	}
}
