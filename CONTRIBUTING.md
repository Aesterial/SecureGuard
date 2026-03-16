# Contributing

## Scope

`SecureGuard` is a monorepo with three main areas:

- `client/`: Tauri desktop application
- `server/`: Go backend
- `api/`: protobuf contracts and generated interfaces

Keep changes scoped to one area when possible. If a feature spans contracts, backend, and generated code, keep those parts together in one branch and explain the dependency in the pull request.

## Ownership

Review ownership is defined in [CODEOWNERS](./CODEOWNERS).

Current review split:

- backend and API contracts: `@Ivanskem`
- desktop client: `@xvalegendary`
- shared repository policy and automation: both owners

## Branch and PR expectations

- Use a short-lived feature or fix branch.
- Keep commits coherent and easy to review.
- If you change protobuf contracts, include regenerated code in the same branch.
- If you change runtime behavior, include or update tests where practical.
- In the PR description, include:
  - what changed
  - why it changed
  - how it was verified
  - any follow-up work or known limitations

## Commit style

Commit messages should follow the repository convention documented in [.github/COMMIT_STYLE.md](./.github/COMMIT_STYLE.md).

Recommended format:

```text
<type>(<scope>): <summary>
```

Examples:

```text
feat(server): add Docker entrypoint for database bootstrap
docs(readme): document compose-based local run
fix(client): handle unauthenticated copy flow
```

## Local checks

### Backend

```bash
cd server/internal
go test ./...

cd ../starter
go test ./...
```

### Desktop client

```bash
cd client/src-tauri
cargo fmt --all -- --check
cargo clippy --all-targets --all-features -- -D warnings
cargo build --all-targets --all-features --locked
```

### Frontend shell

```bash
cd client
npm ci
```

## Docker workflow

For local backend infrastructure, use the root-level Docker files:

- [docker-compose.yml](./docker-compose.yml)
- [Caddyfile](./Caddyfile)
- [server/Dockerfile](./server/Dockerfile)

The compose stack starts:

- PostgreSQL
- the Go backend
- Caddy as a reverse proxy to the gRPC service

## Notes

- `setup.bat` is a legacy scaffold script and is not the main development flow.
- `run.bat` remains the Windows-first helper for local app development.
