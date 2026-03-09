package configapp

import (
	"os"
	"strconv"
	"strings"

	cfgdomain "github.com/aesterial/secureguard/internal/domain/config"

	"github.com/joho/godotenv"
)

var env cfgdomain.Config

func envValue(keys ...string) string {
	for _, key := range keys {
		if key == "" {
			continue
		}
		raw := strings.TrimSpace(os.Getenv(key))
		if raw != "" {
			return raw
		}
	}
	return ""
}

func parseType[T any](key string, def T) T {
	raw := strings.TrimSpace(os.Getenv(key))
	if raw == "" {
		return def
	}

	switch any(def).(type) {
	case int:
		v, err := strconv.Atoi(raw)
		if err != nil {
			return def
		}
		return any(v).(T)

	case bool:
		v, err := strconv.ParseBool(raw)
		if err != nil {
			return def
		}
		return any(v).(T)

	case string:
		return any(raw).(T)

	case float64:
		v, err := strconv.ParseFloat(raw, 64)
		if err != nil {
			return def
		}
		return any(v).(T)

	default:
		return def
	}
}

func ensure() {
	_ = godotenv.Load(".env")
	env = cfgdomain.Config{
		Database: cfgdomain.Database{
			URL:      envValue("POSTGRES_URL"),
			Name:     envValue("POSTGRES_NAME"),
			Host:     envValue("POSTGRES_HOST"),
			Port:     envValue("POSTGRES_PORT"),
			Tls:      parseType("POSTGRES_TLS", false),
			User:     envValue("POSTGRES_USER"),
			Password: envValue("POSTGRES_PASSWORD"),
		},
		Boot: cfgdomain.Boot{
			Port: parseType("BOOT_PORT", 50051),
		},
		Debug: parseType("DEBUG_MODE", false),
	}
}

func Get() cfgdomain.Config {
	if !env.IsLoaded() {
		ensure()
	}
	return env
}
