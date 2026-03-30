# SecureGuard CLI

`client/cli` is the Dart terminal client for `SecureGuard`. It talks to the same Go gRPC backend as the desktop app and exposes a text UI for authentication, vault operations, sessions, settings, and staff stats.

## Features

- Server setup screen with metadata loading and compatibility checks
- Register and authorize flows over gRPC
- Local encryption and decryption for vault entries
- Password vault flow:
  - list entries
  - create entries
  - update entries
  - delete entries
  - decrypt login or password and copy it to the clipboard for `30s`
- Session list and revoke flow
- RU/EN localization
- Theme and crypt-mode toggles
- Staff-only stats screen

## Requirements

- `Dart SDK 3.11+`
- A running `SecureGuard` backend
- On Linux, one of `wl-copy`, `xclip`, or `xsel` for clipboard support

## Install Dependencies

```bash
cd client/cli
dart pub get
```

## Run

For the local backend from `server/starter/.env`, use:

```bash
dart run bin/secureguard_cli.dart --server http://127.0.0.1:8080
```

If you omit `--server`, the CLI uses `https://localhost` by default.

You can also bake a different default endpoint into the executable:

```bash
dart compile exe "-DSECUREGUARD_DEFAULT_SERVER=http://127.0.0.1:8080" bin/secureguard_cli.dart -o build/secureguard-cli.exe
```

Available flags:

- `-h`, `--help` - show CLI help
- `-v`, `--version` - print version
- `-s`, `--server` - set the backend endpoint for the current session

Notes:

- When `--server` is provided, the endpoint is locked for that run.
- When `--server` is omitted, the endpoint can be changed from the server setup screen inside the TUI.
- `http://...` endpoints use insecure gRPC credentials, `https://...` endpoints use TLS.

## Navigation

- `Arrow Up` / `Arrow Down` - move selection
- `Arrow Left` / `Arrow Right` or `PageUp` / `PageDown` - switch pages in long lists
- `Enter` - open the selected action
- `Esc` - go back
- `Ctrl+C` - exit
- `L` / `Д` - login screen
- `P` / `З` - passwords screen
- `S` / `Ы` - sessions screen
- `T` / `Е` - settings screen
- `A` / `Ф` - admin stats screen
- `O` / `Щ` - logout
- `1` to `9` - jump to a visible item on the current page

## Screens

### Server setup

- Configure endpoint
- Fetch server info
- Check client/server compatibility

### Login

- Register a new account
- Authorize an existing account
- Store session token locally for the current run

### Passwords

- Load the first page of vault entries
- Create a new encrypted entry
- Update service URL, login, or password
- Delete an entry
- Decrypt an entry and temporarily copy login or password to the clipboard

### Sessions

- List active or revoked sessions
- Revoke a selected active session

### Settings

- Toggle language between RU and EN
- Toggle theme
- Toggle crypt mode between `Argon2id` and `SHA-256`

### Stats

- Available only for staff users
- Load total counters and daily activity snapshots

## Development

Run tests:

```bash
dart test
```

Build an executable:

```bash
dart compile exe bin/secureguard_cli.dart -o build/secureguard-cli.exe
```

## Structure

- `bin/secureguard_cli.dart` - entrypoint and argument parsing
- `lib/src/tui/` - screens, renderers, localization, modal flow
- `lib/src/services/` - application services
- `lib/src/api/` - generated Dart protobuf and gRPC code
- `test/` - unit tests

## Generated API

The protobuf and gRPC stubs in `lib/src/api/` are generated from [`api/buf.gen.yaml`](../../api/buf.gen.yaml). See [api/README.md](../../api/README.md) for the generation workflow.
