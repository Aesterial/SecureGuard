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
	return pgxpool.New(context.Background(), fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable", cfg.Host, cfg.Port, cfg.User, cfg.Password, cfg.Name))
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
