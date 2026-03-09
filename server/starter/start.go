package main

import (
	"context"
	"errors"
	"fmt"
	"net"
	"os"
	"os/signal"
	"syscall"
	"time"

	configapp "github.com/aesterial/secureguard/internal/app/config"
	loginapp "github.com/aesterial/secureguard/internal/app/login"
	sessionsapp "github.com/aesterial/secureguard/internal/app/sessions"
	usersapp "github.com/aesterial/secureguard/internal/app/users"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"

	dbclient "github.com/aesterial/secureguard/internal/infra/db"
	"github.com/aesterial/secureguard/internal/infra/db/repos"
	"github.com/aesterial/secureguard/internal/infra/server"

	loginpb "github.com/aesterial/secureguard/internal/api/v1/login/v1"
	userpb "github.com/aesterial/secureguard/internal/api/v1/users/v1"
)

func main() {
	cfg := configapp.Get()

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	// db connection
	conn, err := dbclient.New()
	if err != nil {
		return
	}
	defer conn.Pool.Close()

	usrRepo := repos.NewUserRepository(conn.Querier())
	sesRepo := repos.NewSessionsRepository(conn.Querier())

	usrService := usersapp.NewUserService(usrRepo)
	sesService := sessionsapp.NewSessionService(sesRepo)
	loginService := loginapp.NewLoginService(usrRepo, sesService)

	authentificator := server.NewAuthentificator(sesService, usrService)
	usrServer := server.NewUserService(usrService, authentificator)
	loginServer := server.NewLoginService(usrService, loginService, authentificator)

	var opts []grpc.ServerOption
	opts = append(opts)

	server := grpc.NewServer(opts...)
	if cfg.IsDebug() {
		reflection.Register(server)
	}
	loginpb.RegisterLoginServiceServer(server, loginServer)
	userpb.RegisterUserServiceServer(server, usrServer)
	listener, err := net.Listen("tcp", fmt.Sprintf("0.0.0.0:%d", cfg.Boot.Port))
	if err != nil {
		return
	}
	srvErr := make(chan error, 1)
	go func() {
		// log start serving
		srvErr <- server.Serve(listener)
	}()
	select {
	case <-ctx.Done():
		done := make(chan struct{})
		go func() {
			server.GracefulStop()
			close(done)
		}()

		select {
		case <-done:
		case <-time.After(10 * time.Second):
			server.Stop()
		}
		// log stop
	case err = <-srvErr:
		if err != nil && !errors.Is(err, grpc.ErrServerStopped) {
			// crash
		}
	}
}
