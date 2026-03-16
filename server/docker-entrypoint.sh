#!/bin/sh
set -eu

: "${POSTGRES_HOST:=db}"
: "${POSTGRES_PORT:=5432}"
: "${POSTGRES_USER:=postgres}"
: "${POSTGRES_PASSWORD:=postgres}"
: "${POSTGRES_NAME:=secureguard}"
: "${BOOT_PORT:=50051}"

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

apply_schema() {
  if [ -n "${POSTGRES_URL:-}" ]; then
    psql "${POSTGRES_URL}" -v ON_ERROR_STOP=1 -f /app/migrations/sqlc.sql
    return
  fi

  export PGPASSWORD="${POSTGRES_PASSWORD}"
  psql "host=${POSTGRES_HOST} port=${POSTGRES_PORT} user=${POSTGRES_USER} dbname=${POSTGRES_NAME} sslmode=disable" \
    -v ON_ERROR_STOP=1 \
    -f /app/migrations/sqlc.sql
}

wait_for_db
apply_schema

exec /app/secureguard-server
