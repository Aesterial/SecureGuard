package dbconnection

import (
	"context"
	"errors"
	"fmt"
	"net/url"
	"strings"

	configapp "github.com/aesterial/secureguard/internal/app/config"
	"github.com/jackc/pgx/v5/pgxpool"
)

func Connect() (*pgxpool.Pool, error) {
	cfg := configapp.Get().Database
	if strings.TrimSpace(cfg.URL) != "" {
		dsn, err := normalize(cfg.URL)
		if err != nil {
			return nil, errors.New("invalid database url provided")
		}
		return pgxpool.New(context.Background(), dsn)
	}

	host := strings.TrimSpace(cfg.Host)
	port := strings.TrimSpace(cfg.Port)
	user := strings.TrimSpace(cfg.User)
	name := strings.TrimSpace(cfg.Name)
	if host == "" || port == "" || user == "" || name == "" {
		return nil, errors.New("database config is incomplete: set POSTGRES_URL or POSTGRES_HOST, POSTGRES_PORT, POSTGRES_USER, POSTGRES_NAME")
	}

	sslmode := "disable"
	if cfg.Tls {
		sslmode = "require"
	}
	dsn := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=%s",
		host,
		port,
		user,
		cfg.Password,
		name,
		sslmode,
	)
	return pgxpool.New(context.Background(), dsn)
}

func normalize(raw string) (string, error) {
	u, err := url.Parse(raw)
	if err != nil {
		return "", err
	}
	if u.User != nil {
		username := u.User.Username()
		if password, ok := u.User.Password(); ok {
			u.User = url.UserPassword(username, password)
		} else {
			u.User = url.User(username)
		}
	}
	return u.String(), nil
}
