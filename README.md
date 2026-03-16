<h1 align="center">
  <img src="./client/src-tauri/icons/icon.png" width="96" alt="SecureGuard logo" />
  <br />
  SecureGuard
</h1>

<p align="center">
  <i>Windows-first desktop password vault with local encryption, OS hardening, and a Go gRPC backend.</i>
</p>

<p align="center">
  <a href="./LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square" alt="license" /></a>
  <img src="https://img.shields.io/badge/platform-Windows-0078D6?style=flat-square&logo=windows" alt="platform windows" />
  <img src="https://img.shields.io/badge/stack-Tauri%20%2B%20Rust%20%2B%20Go%20%2B%20PostgreSQL-222?style=flat-square" alt="tech stack" />
</p>

## Overview

`SecureGuard` is a monorepo for a desktop password manager with three main parts:

- `client/`: Tauri desktop app (`Rust + HTML/CSS/JS`)
- `server/`: Go gRPC backend with layered `domain/app/infra` structure
- `api/`: protobuf contracts and generated code inputs

The current codebase is an active MVP. The desktop app is already usable for the core vault flow, while the backend exposes a wider API surface than the UI currently consumes.

## Current State

### Desktop client

- Account registration and login through gRPC
- Local password encryption before sending data to backend
- Supported encryption modes:
  - `AES-256-GCM + Argon2id`
  - `AES-256-GCM + SHA-256`
- Password vault flow:
  - create entries
  - list entries
  - delete entries
  - decrypt-and-copy via seed phrase
- Clipboard auto-clear after 30 seconds
- RU/EN interface
- Local UI settings:
  - language
  - encryption algorithm
  - screenshot guard
  - startup with Windows
  - auto-lock
  - delete confirmation
  - context-menu blocking
- Windows-specific protection hooks and elevated launch flow

### Backend and API

- gRPC services registered in `server/starter/start.go`:
  - `LoginService`
  - `UserService`
  - `PasswordService`
  - `StatsService`
- PostgreSQL persistence through `sqlc`
- Session-based authentication with background cleanup worker
- Structured logging subsystem
- Optional Kafka-backed log transport and log reader
- Hourly and daily stats persistence workers
- Buf-based protobuf generation for Go and Rust clients
- CI workflows for Go and Rust static analysis

### Known boundaries

- The desktop client currently focuses on login and password-vault flows.
- `UserService` and `StatsService` are available on the backend, but are not fully surfaced in the desktop UI yet.
- The repository is Windows-first. The Tauri app contains Windows-only integrations for screenshot protection and startup management.
- `setup.bat` is a legacy scaffold script and is not part of the current monorepo development flow.

## Repository Layout

```text
SecureGuard/
├── client/
│   ├── src/                # Frontend HTML/CSS/JS
│   ├── src-tauri/          # Tauri shell, crypto, OS integrations
│   └── grpc/               # Generated Rust gRPC stubs
├── server/
│   ├── internal/           # Domain, app, infra, generated Go stubs
│   ├── starter/            # gRPC server bootstrap entrypoint
│   └── migrations/         # Schema and sqlc queries
├── api/
│   ├── xyz/secureguard/... # Protobuf contracts
│   └── third_party/        # Proto dependencies
├── run.bat                 # Main local run helper for Windows
└── .github/                # CI and repository automation
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

For backend-only local infrastructure with reverse proxying, use the root Docker stack:

```bash
docker compose up --build
```

This stack starts:

- `db`: PostgreSQL 16
- `backend`: Go gRPC service from `server/starter`
- `caddy`: public reverse proxy with automatic TLS

Notes:

- Caddy exposes ports `80/443` and proxies h2c traffic to the backend on port `50051`.
- The backend container waits for PostgreSQL, applies `server/migrations/scheme/sqlc.sql`, and then starts the gRPC server.
- Database data is stored in the named volume `secureguard-postgres-data`.
- Caddy stores ACME state in persistent Docker volumes.
- The checked-in `Caddyfile` is a public deployment template and uses `example.com`, `www.example.com`, and `admin@example.com` placeholders. Replace them with your real domain and email before deployment.

## Manual Development

### 1. Start PostgreSQL

```bash
docker run --name secureguard-postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=secureguard -p 5432:5432 -d postgres:16-alpine
```

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

If you want to keep backend on another port, export one of these variables before launching the client:

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

These commands match the direction of the current CI workflows in `.github/workflows`.

## API and Code Generation

See [api/README.md](./api/README.md) for generation details.

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

This project is licensed under the [MIT License](./LICENSE).
