package main

import (
	"context"
	"errors"
	"fmt"
	"net"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"

	configapp "github.com/aesterial/secureguard/internal/app/config"
	loginapp "github.com/aesterial/secureguard/internal/app/login"
	metaapp "github.com/aesterial/secureguard/internal/app/meta"
	passapp "github.com/aesterial/secureguard/internal/app/passwords"
	sessionsapp "github.com/aesterial/secureguard/internal/app/sessions"
	statsapp "github.com/aesterial/secureguard/internal/app/stats"
	usersapp "github.com/aesterial/secureguard/internal/app/users"
	interceptors "github.com/aesterial/secureguard/internal/infra/server/interceptors"
	sharedmetadata "github.com/aesterial/secureguard/internal/shared/metadata"
	"github.com/grpc-ecosystem/go-grpc-middleware/v2/interceptors/recovery"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"

	metapb "github.com/aesterial/secureguard/internal/api/v1/meta/v1"
	logging "github.com/aesterial/secureguard/internal/app/logging"
	ratelimitapp "github.com/aesterial/secureguard/internal/app/ratelimit"
	ratelimitdomain "github.com/aesterial/secureguard/internal/domain/ratelimit"
	dbclient "github.com/aesterial/secureguard/internal/infra/db"
	"github.com/aesterial/secureguard/internal/infra/db/repos"
	"github.com/aesterial/secureguard/internal/infra/ratelimit"
	serverInfra "github.com/aesterial/secureguard/internal/infra/server"

	loginpb "github.com/aesterial/secureguard/internal/api/v1/login/v1"
	passpb "github.com/aesterial/secureguard/internal/api/v1/passwords/v1"
	sessionspb "github.com/aesterial/secureguard/internal/api/v1/sessions/v1"
	statspb "github.com/aesterial/secureguard/internal/api/v1/stats/v1"
	userpb "github.com/aesterial/secureguard/internal/api/v1/users/v1"
)

func main() {
	cfg := configapp.Get()
	sharedmetadata.ServerName = cfg.Metadata.ServerName
	sharedmetadata.CommitHash = fillEmpty(sharedmetadata.CommitHash, strings.TrimSpace(os.Getenv("COMMIT_HASH")))
	sharedmetadata.BuildTime = fillEmpty(sharedmetadata.BuildTime, strings.TrimSpace(os.Getenv("BUILD_TIME")))

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
	statsRepo := repos.NewStatsRepository(conn.Querier())
	metaRepo := repos.NewMetaRepository(conn.Querier())

	limiterBackend, err := ratelimit.New(ctx, ratelimit.Config{
		Enabled:  cfg.RateLimit.Enabled,
		Addr:     cfg.Redis.Addr,
		Password: cfg.Redis.Password,
		DB:       cfg.Redis.DB,
		Prefix:   cfg.RateLimit.Prefix,
	})
	if err != nil {
		logging.Critical("failed to initialize redis rate limiter", logging.F("error", err.Error()))
		return
	}
	defer limiterBackend.Close()

	usrService := usersapp.NewUserService(usrRepo)
	sesService := sessionsapp.NewSessionService(sesRepo)
	sesWorker := sessionsapp.NewWorker(sesRepo)
	passService := passapp.NewPassService(passRepo)
	statsService := statsapp.NewStatsService(statsRepo)
	statsWorker := statsapp.NewPersistenceWorker(statsRepo)
	metaService := metaapp.NewService(metaRepo)
	loginService := loginapp.NewLoginService(usrRepo, sesService)
	rateLimiter := ratelimitapp.NewService(
		limiterBackend,
		ratelimitdomain.Rules{
			Authorize: ratelimitdomain.Rule{
				Limit:  cfg.RateLimit.AuthorizeLimit,
				Window: time.Duration(cfg.RateLimit.AuthorizeWindowSeconds) * time.Second,
			},
			Register: ratelimitdomain.Rule{
				Limit:  cfg.RateLimit.RegisterLimit,
				Window: time.Duration(cfg.RateLimit.RegisterWindowSeconds) * time.Second,
			},
			Meta: ratelimitdomain.Rule{
				Limit:  cfg.RateLimit.MetaLimit,
				Window: time.Duration(cfg.RateLimit.MetaWindowSeconds) * time.Second,
			},
		},
	)

	authentificator := serverInfra.NewAuthentificator(sesService, usrService)
	usrServer := serverInfra.NewUserService(usrService, authentificator)
	loginServer := serverInfra.NewLoginService(usrService, loginService, authentificator, rateLimiter)
	metaServer := serverInfra.NewMetaService(metaService, rateLimiter)
	passServer := serverInfra.NewPasswordsService(passService, authentificator)
	statsServer := serverInfra.NewStatsService(statsService, authentificator)
	sessionsServer := serverInfra.NewSessionsService(sesService, authentificator)

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
	metapb.RegisterMetaServiceServer(server, metaServer)
	loginpb.RegisterLoginServiceServer(server, loginServer)
	userpb.RegisterUserServiceServer(server, usrServer)
	passpb.RegisterPasswordServiceServer(server, passServer)
	statspb.RegisterStatsServiceServer(server, statsServer)
	sessionspb.RegisterSessionsServiceServer(server, sessionsServer)
	statsWorker.Start(ctx)
	sesWorker.Start(ctx)
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

func fillEmpty(current string, fallback string) string {
	if strings.TrimSpace(current) != "" {
		return current
	}
	return fallback
}
