<h1 align="center">SecureGuard</h1>

<p align="center">
  <a href="./README.md"><strong>English</strong></a> |
  <a href="./README.ru.md">Русский</a>
</p>

<p align="center">
  <img src="./.github/assets/illustration.svg" alt="SecureGuard illustration" />
</p>

<p align="center">
  <i>Windows-first desktop password vault with local encryption, OS hardening, and a Go gRPC backend.</i>
</p>

<p align="center">
  <a href="https://github.com/Aesterial/SecureGuard/actions/workflows/go-link-static.yml">
    <img src="https://github.com/Aesterial/SecureGuard/actions/workflows/go-link-static.yml/badge.svg?branch=main" alt="Go CI status" />
  </a>
  <a href="https://github.com/Aesterial/SecureGuard/actions/workflows/rust-link-static.yml">
    <img src="https://github.com/Aesterial/SecureGuard/actions/workflows/rust-link-static.yml/badge.svg?branch=main" alt="Rust CI status" />
  </a>
  <a href="./LICENSE">
    <img src="https://img.shields.io/badge/license-AGPL--3.0-3e4c75.svg?style=flat-square" alt="AGPL-3.0 license" />
  </a>
  <img src="https://img.shields.io/badge/platform-Windows-0078D6?style=flat-square&logo=windows" alt="Windows platform" />
  <img src="https://img.shields.io/badge/stack-Tauri%20%2B%20Rust%20%2B%20Go%20%2B%20PostgreSQL-222?style=flat-square" alt="Tech stack" />
</p>

## Overview

`SecureGuard` is a monorepo for a desktop password manager with three main parts:

- `client/`: Tauri desktop app (`Rust + HTML/CSS/JS`)
- `server/`: Go gRPC backend with layered `domain/app/infra` structure
- `api/`: protobuf contracts and generation inputs for Go and Rust clients

The repository is currently an active MVP. The desktop app already covers the core vault flow, while the backend exposes a broader API surface for sessions, settings, metadata, and admin statistics.

## Documentation

Project materials prepared for development and presentation:

- [docs/PROJECT_DOCS.md](./docs/PROJECT_DOCS.md) - full project documentation
- [docs/USER_FAQ.md](./docs/USER_FAQ.md) - end-user FAQ
- [api/README.md](./api/README.md) - protobuf and generation notes

## Current State

### Desktop client

- Account registration and login over gRPC
- Local vault-key envelope generation from a seed phrase before registration
- Local password encryption before data is sent to the backend
- Supported encryption modes:
  - `AES-256-GCM + Argon2id`
  - `AES-256-GCM + SHA-256`
- Password vault flow:
  - create entries
  - list entries
  - delete entries
  - decrypt-and-copy via seed phrase
- Staff-only read-only admin statistics screen
- Clipboard auto-clear with default `30s` timeout and configurable presets
- RU/EN interface
- Local UI settings:
  - language
  - encryption algorithm
  - screenshot guard
  - light theme
  - startup with Windows
  - auto-logout timer
  - clipboard timeout
  - delete confirmation
  - context-menu blocking
- Windows-specific screenshot protection, startup integration, and release-only protection hooks

### Backend and API

- gRPC services registered in `server/starter/start.go`:
  - `MetaService`
  - `LoginService`
  - `UserService`
  - `PasswordService`
  - `StatsService`
  - `SessionsService`
- PostgreSQL persistence through `sqlc`
- Session-based authentication with client metadata binding and a background cleanup worker
- Optional Redis-backed rate limiting for register/login/meta endpoints
- Structured logging subsystem
- Optional Kafka-backed log transport and log reader
- Hourly and daily stats persistence workers
- Buf-based protobuf generation for Go and Rust clients
- GitHub Actions workflows for Go and Rust link/static analysis

### Known boundaries

- The desktop client currently focuses on authentication, vault management, settings, and staff stats.
- The desktop UI does not expose password updates, session management, or key rotation, even though backend/API support exists for some of those flows.
- The admin statistics screen depends on the Kafka log reader path. In the minimal local setup with `KAFKA_ENABLED=false`, staff analytics are not available.
- The server does not receive the raw seed phrase during registration. It stores a wrapped master key plus salt/KDF params in `users_keys`, so the system is safer than the old design but still not a strict zero-knowledge vault.
- The repository is Windows-first. The Tauri app contains Windows-only integrations for screenshot protection and startup management.

## Repository Layout

```text
SecureGuard/
|-- client/
|   |-- src/                # Frontend HTML/CSS/JS
|   |-- src-tauri/          # Tauri shell, crypto, OS integrations
|   `-- grpc/               # Generated Rust gRPC stubs
|-- server/
|   |-- internal/           # Domain, app, infra, generated Go stubs
|   |-- starter/            # gRPC server bootstrap entrypoint
|   `-- migrations/         # Schema and sqlc queries
|-- api/
|   |-- xyz/secureguard/... # Protobuf contracts
|   `-- third_party/        # Proto dependencies
|-- docs/                   # Project docs and FAQ
|-- run.bat                 # Main local run helper for Windows
`-- .github/                # CI workflows and repository assets
```

## Prerequisites

- Windows 10/11
- `Rust` stable
- `Node.js` with `npm`
- `Go 1.26.1` or compatible with the checked-in `go.mod`
- `Docker` if you want `run.bat` to auto-start PostgreSQL
- `Git` with submodule support

## Quick Start

1. Clone the repository:

```bash
git clone https://github.com/Aesterial/SecureGuard.git
cd SecureGuard
```

2. Initialize protobuf dependencies:

```bash
git submodule update --init --recursive api/third_party/googleapis api/third_party/grpc-web
```

3. Install frontend dependencies:

```bash
cd client
npm ci
cd ..
```

4. Configure backend environment:

```powershell
Copy-Item server/starter/.env.example server/starter/.env
```

Update `server/starter/.env` so the desktop client and backend use the same port:

```env
POSTGRES_HOST=127.0.0.1
POSTGRES_PORT=5432
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_NAME=secureguard
POSTGRES_TLS=false

BOOT_PORT=8080
LOG_SERVICE=secureguard
LOG_LEVEL=info
KAFKA_ENABLED=false
DEBUG_MODE=false
```

Why `8080`: the Tauri client defaults to `http://127.0.0.1:8080` in `client/src-tauri/src/api.rs`.

Notes:

- `server/starter/.env.example` is tuned for the local desktop flow and keeps Kafka-backed analytics plus Redis rate limiting disabled by default.
- The root `docker compose` stack still enables Kafka and rate limiting through its own container defaults, so you do not need to turn them on in the minimal local setup.
- The minimal desktop flow works with the lean config above; the staff analytics screen does not.

5. Start everything with the helper script:

```bat
run.bat
```

`run.bat` can:

- stop previously running app processes
- create `server/starter/.env` when missing
- start PostgreSQL in Docker if it is not running locally
- apply `server/migrations/scheme/sqlc.sql`
- start the Go gRPC backend
- run the Tauri app in `dev` or `build` mode

## Docker Compose

For the full backend stack with analytics and reverse proxying, use the root Docker stack:

```bash
docker compose up --build
```

This stack starts:

- `db`: PostgreSQL 16
- `redis`: rate-limit storage
- `kafka`: log transport and analytics reader source
- `backend`: Go gRPC service from `server/starter`
- `caddy`: public reverse proxy with automatic TLS

Notes:

- Caddy exposes ports `80/443` and proxies h2c traffic to the backend on port `50051`.
- The backend container waits for PostgreSQL, applies `server/migrations/scheme/sqlc.sql`, and then starts the gRPC server.
- In this stack, backend defaults enable `KAFKA_ENABLED=true` and `RATE_LIMIT_ENABLED=true`.
- Database data is stored in the named volume `secureguard-postgres-data`.
- Redis and Kafka data are also persisted in named Docker volumes.
- Caddy stores ACME state in persistent Docker volumes.
- The checked-in `Caddyfile` is a public deployment template and uses `example.com`, `www.example.com`, and `admin@example.com` placeholders. Replace them with your real domain and email before deployment.

## Manual Development

### 1. Start PostgreSQL

```bash
docker run --name secureguard-postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=secureguard -p 5432:5432 -d postgres:16-alpine
```

This is enough for the core vault flow. If you want staff analytics or rate limiting locally, use the root `docker compose` stack instead so `Redis` and `Kafka` are available.

### 2. Apply schema

```bash
docker exec -i secureguard-postgres psql -U postgres -d secureguard < server/migrations/scheme/sqlc.sql
```

### 3. Start backend

```bash
cd server/starter
go run .
```

### 4. Start desktop app

```bash
cd client
npm run dev
```

If you want to keep the backend on another port, export one of these variables before launching the client:

- `SECUREGUARD_GRPC_ENDPOINT`
- `SECUREGUARD_BACKEND`

Example:

```powershell
$env:SECUREGUARD_GRPC_ENDPOINT = "http://127.0.0.1:50051"
cd client
npm run dev
```

## Local Quality Checks

### Go

```bash
cd server/internal
go test ./...

cd ../starter
go test ./...
```

### Rust

```bash
cd client/src-tauri
cargo fmt --all -- --check
cargo clippy --all-targets --all-features -- -D warnings
cargo build --all-targets --all-features --locked
```

These commands match the current CI workflows in `.github/workflows/go-link-static.yml` and `.github/workflows/rust-link-static.yml`.

## API and Code Generation

See [api/README.md](./api/README.md) for full generation details.

Short version:

1. Install generators:

```bash
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
cargo install protoc-gen-prost
cargo install protoc-gen-tonic
```

2. Ensure generator binaries are in `PATH`:

- Go: `%USERPROFILE%\go\bin`
- Rust: `%USERPROFILE%\.cargo\bin`

3. Generate code:

```bash
cd api
buf generate
```

Generated outputs:

- Go stubs: `server/internal/api/...`
- Rust stubs: `client/grpc/...`

## Contributing

- Use the owners in `CODEOWNERS` when routing reviews.
- Follow [CONTRIBUTING.md](./CONTRIBUTING.md).
- Follow the commit rules in `.github/COMMIT_STYLE.md`.
- Keep changes scoped to one area when possible.
- If you touch protobuf contracts, include generated code updates in the same branch.

## License

This project is licensed under the [GNU AGPL-3.0](./LICENSE).
