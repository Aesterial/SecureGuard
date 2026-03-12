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
	passapp "github.com/aesterial/secureguard/internal/app/passwords"
	sessionsapp "github.com/aesterial/secureguard/internal/app/sessions"
	usersapp "github.com/aesterial/secureguard/internal/app/users"
	interceptors "github.com/aesterial/secureguard/internal/infra/server/interceptors"
	"github.com/grpc-ecosystem/go-grpc-middleware/v2/interceptors/recovery"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"

	dbclient "github.com/aesterial/secureguard/internal/infra/db"
	"github.com/aesterial/secureguard/internal/infra/db/repos"
	"github.com/aesterial/secureguard/internal/infra/server"
	"github.com/aesterial/secureguard/internal/shared/logging"

	loginpb "github.com/aesterial/secureguard/internal/api/v1/login/v1"
	passpb "github.com/aesterial/secureguard/internal/api/v1/passwords/v1"
	userpb "github.com/aesterial/secureguard/internal/api/v1/users/v1"
)

func main() {
	cfg := configapp.Get()

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	logger, err := logging.New(logging.Config{
		Service: cfg.Logging.Service,
		Level:   cfg.Logging.Level,
		Kafka: logging.KafkaConfig{
			Enabled:  cfg.Kafka.Enabled,
			Brokers:  cfg.Kafka.Brokers,
			Topic:    cfg.Kafka.Topic,
			ClientID: cfg.Kafka.ClientID,
		},
	})
	if err != nil {
		println("failed to initialize logger: " + err.Error())
		return
	}
	defer logger.Close()
	logging.SetDefault(logger)
	logging.Info("logger initialized", logging.F("kafka_enabled", cfg.Kafka.Enabled), logging.F("log_level", cfg.Logging.Level))

	conn, err := dbclient.New()
	if err != nil {
		logging.Critical("failed to connect to db", logging.F("error", err.Error()))
		return
	}
	defer conn.Pool.Close()

	usrRepo := repos.NewUserRepository(conn.Querier())
	sesRepo := repos.NewSessionsRepository(conn.Querier())
	passRepo := repos.NewPasswordsRepository(conn.Querier())

	usrService := usersapp.NewUserService(usrRepo)
	sesService := sessionsapp.NewSessionService(sesRepo)
	passService := passapp.NewPassService(passRepo)
	loginService := loginapp.NewLoginService(usrRepo, sesService)

	authentificator := server.NewAuthentificator(sesService, usrService)
	usrServer := server.NewUserService(usrService, authentificator)
	loginServer := server.NewLoginService(usrService, loginService, authentificator)
	passServer := server.NewPasswordsService(passService, authentificator)

	server := grpc.NewServer(
		grpc.ChainUnaryInterceptor(
			interceptors.LoggingServerInterceptor(),
			recovery.UnaryServerInterceptor(
				recovery.WithRecoveryHandlerContext(interceptors.ServerPanicRecovery),
			),
		),
	)
	if cfg.Debug {
		reflection.Register(server)
	}
	loginpb.RegisterLoginServiceServer(server, loginServer)
	userpb.RegisterUserServiceServer(server, usrServer)
	passpb.RegisterPasswordServiceServer(server, passServer)
	listener, err := net.Listen("tcp", fmt.Sprintf("0.0.0.0:%d", cfg.Boot.Port))
	if err != nil {
		logging.Critical("failed to listen", logging.F("error", err.Error()))
		return
	}
	srvErr := make(chan error, 1)
	go func() {
		logging.Info("grpc server started", logging.F("port", cfg.Boot.Port))
		srvErr <- server.Serve(listener)
	}()
	select {
	case <-ctx.Done():
		logging.Warn("shutdown signal received", logging.F("signal", ctx.Err().Error()))
		done := make(chan struct{})
		go func() {
			server.GracefulStop()
			close(done)
		}()

		select {
		case <-done:
			logging.Info("grpc server stopped gracefully")
		case <-time.After(10 * time.Second):
			server.Stop()
			logging.Warn("graceful shutdown timeout exceeded, forcing stop")
		}
	case err = <-srvErr:
		if err != nil && !errors.Is(err, grpc.ErrServerStopped) {
			logging.Critical("grpc server crashed", logging.F("error", err.Error()))
		}
	}
}
