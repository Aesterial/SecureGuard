<h1 align="center">
  <img src="./client/src-tauri/icons/icon.png" width="96" alt="SecureGuard logo" />
  <br />
  SecureGuard
</h1>

<p align="center">
  <i align="center">Secure desktop password vault with local encryption, Windows hardening, and a Go gRPC backend.</i>
</p>

<p align="center">
  <a href="./LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square" alt="license" /></a>
  <img src="https://img.shields.io/badge/platform-Windows-0078D6?style=flat-square&logo=windows" alt="platform windows" />
  <img src="https://img.shields.io/badge/stack-Tauri%20%2B%20Rust%20%2B%20Go%20%2B%20PostgreSQL-222?style=flat-square" alt="tech stack" />
</p>

## Introduction

`SecureGuard` is a desktop password manager focused on local-first security:

- Tauri desktop client (`Rust + HTML/CSS/JS`)
- gRPC backend (`Go`)
- PostgreSQL for persistence
- local encryption for stored passwords before they are sent to backend
- Windows-oriented protection controls (screenshot blocking, startup control, anti-capture hardening)

The project follows a monorepo layout with separate `client`, `server`, and `api` modules.

<details open>
<summary>Features</summary>
<br />

- Account registration and authorization (gRPC)
- Session-based authentication
- Password entry encryption via:
  - `AES-256-GCM + Argon2id` (default)
  - `AES-256-GCM + SHA-256` (fast mode)
- Seed phrase-based decryption flow
- Clipboard auto-clear (30 seconds after copy)
- Language preferences (`ru`, `en`)
- UI preferences (theme/encryption/lang options in settings)
- Screenshot Guard and Windows startup toggles
- Proto-first API contracts with generated Go and Rust stubs

</details>

## Architecture

```text
SecureGuard/
├── client/                 # Tauri desktop app (Rust + web UI)
│   ├── src/                # Frontend (HTML/CSS/JS)
│   ├── src-tauri/          # Rust commands and OS integrations
│   └── grpc/               # Generated Rust gRPC stubs
├── server/
│   ├── starter/            # gRPC server bootstrap (main entrypoint)
│   ├── internal/           # Domain/app/infra layers
│   └── migrations/         # SQL schema and sqlc queries
└── api/
    ├── xyz/secureguard/... # Protobuf contracts
    └── third_party/        # Proto dependencies (git submodules)
```

## Quick Start (Windows)

<details open>
<summary>Prerequisites</summary>
<br />

- `Rust` (stable)
- `Node.js` (with `npm`)
- `Go` (see `server/internal/go.mod`, currently `go 1.26.1`)
- `Docker` (optional, but used by `run.bat` to auto-start PostgreSQL)
- `Git` (for submodules)

</details>

1. Clone repository:

```bash
git clone https://github.com/Aesterial/SecureGuard.git
cd SecureGuard
```

2. Initialize proto submodules:

```bash
git submodule update --init --recursive api/third_party/googleapis api/third_party/grpc-web
```

3. Make sure backend port is aligned with client:

- Client default endpoint: `http://127.0.0.1:8080`
- In `server/starter/.env`, set:

```env
BOOT_PORT=8080
```

4. Run helper script:

```bat
run.bat
```

The script can:
- stop previous app instances
- start PostgreSQL container if needed
- apply DB schema from `server/migrations/scheme/sqlc.sql`
- run backend (`go run .` in `server/starter`)
- run Tauri client in dev/build mode

## Manual Development

1. Install client dependencies:

```bash
cd client
npm ci
```

2. Configure backend environment:

```bash
cd ../server/starter
copy .env.example .env
```

Then ensure:

```env
BOOT_PORT=50051
POSTGRES_HOST=127.0.0.1
POSTGRES_PORT=5432
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_NAME=secureguard
```

3. Start PostgreSQL:

```bash
docker run --name secureguard-postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=secureguard -p 5432:5432 -d postgres:16-alpine
```

4. Apply schema:

```bash
# run from repository root
docker exec -i secureguard-postgres psql -U postgres -d secureguard < server/migrations/scheme/sqlc.sql
```

5. Start backend:

```bash
cd server/starter
go run .
```

6. Start desktop app:

```bash
cd client
npm run dev
```

## API and Code Generation

For protobuf regeneration:

1. Install plugins:

```bash
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
cargo install protoc-gen-prost
cargo install protoc-gen-tonic
```

2. Ensure plugin binaries are in `PATH`:
- Go: `%USERPROFILE%\go\bin`
- Rust: `%USERPROFILE%\.cargo\bin`

3. Generate code:

```bash
cd api
buf generate
```

Outputs:
- Go server stubs: `server/internal/api/...`
- Rust client stubs: `client/grpc/...`

## Project Status

Current state is an active MVP:

- Login/User services are wired in `server/starter/start.go`
- Password repository and protobuf contracts exist
- Password gRPC server wiring is not yet registered in starter

If you plan production use, complete service registration and run a full security review first.

## Contributing

Contributions are welcome through issues and pull requests.

Recommended flow:
1. Fork and create a feature branch
2. Keep changes scoped and documented
3. Include reproduction steps for fixes
4. Open PR with technical context and test notes

## License

This project is licensed under the [MIT License](./LICENSE).
