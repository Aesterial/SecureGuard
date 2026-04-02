#!/bin/sh
set -eu

: "${POSTGRES_HOST:=db}"
: "${POSTGRES_PORT:=5432}"
: "${POSTGRES_USER:=postgres}"
: "${POSTGRES_PASSWORD:=postgres}"
: "${POSTGRES_NAME:=secureguard}"
: "${BOOT_PORT:=50051}"
: "${POSTGRES_TLS:=false}"

postgres_tls_mode() {
  if [ -n "${POSTGRES_TLS_MODE:-}" ]; then
    printf '%s' "${POSTGRES_TLS_MODE}"
    return
  fi

  case "${POSTGRES_TLS}" in
    1|true|TRUE|True|yes|YES|on|ON)
      printf '%s' "require"
      ;;
    *)
      printf '%s' "disable"
      ;;
  esac
}

wait_for_db() {
  if [ -n "${POSTGRES_URL:-}" ]; then
    until pg_isready -d "${POSTGRES_URL}" >/dev/null 2>&1; do
      echo "waiting for postgres via POSTGRES_URL..."
      sleep 2
    done
    return
  fi

  export PGPASSWORD="${POSTGRES_PASSWORD}"
  until pg_isready -h "${POSTGRES_HOST}" -p "${POSTGRES_PORT}" -U "${POSTGRES_USER}" -d "${POSTGRES_NAME}" >/dev/null 2>&1; do
    echo "waiting for postgres at ${POSTGRES_HOST}:${POSTGRES_PORT}..."
    sleep 2
  done
}

schema_already_initialized() {
  query="select to_regclass('public.users') is not null;"

  if [ -n "${POSTGRES_URL:-}" ]; then
    [ "$(psql "${POSTGRES_URL}" -tA -c "${query}")" = "t" ]
    return
  fi

  export PGPASSWORD="${POSTGRES_PASSWORD}"
  [ "$(psql "host=${POSTGRES_HOST} port=${POSTGRES_PORT} user=${POSTGRES_USER} dbname=${POSTGRES_NAME} sslmode=$(postgres_tls_mode)" -tA -c "${query}")" = "t" ]
}

apply_schema() {
  if schema_already_initialized; then
    echo "postgres schema already initialized, skipping bootstrap"
    return
  fi

  if [ -n "${POSTGRES_URL:-}" ]; then
    psql "${POSTGRES_URL}" -v ON_ERROR_STOP=1 -f /app/migrations/sqlc.sql
    return
  fi

  export PGPASSWORD="${POSTGRES_PASSWORD}"
  psql "host=${POSTGRES_HOST} port=${POSTGRES_PORT} user=${POSTGRES_USER} dbname=${POSTGRES_NAME} sslmode=$(postgres_tls_mode)" \
    -v ON_ERROR_STOP=1 \
    -f /app/migrations/sqlc.sql
}

wait_for_db
apply_schema

exec /app/secureguard-server
