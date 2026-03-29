# API build

This directory contains the protobuf contracts used by:

- the Go backend in `server/`
- the Tauri desktop client in `client/desktop/`
- the Dart terminal client in `client/cli/`

## 1. Initialize third-party proto submodules

```bash
git submodule update --init --recursive api/third_party/googleapis api/third_party/grpc-web
```

## 2. Install local protoc plugins

Local plugins are used to avoid Buf Registry access issues during generation.

```bash
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
cargo install protoc-gen-prost
cargo install protoc-gen-tonic
dart pub global activate protoc_plugin
```

## 3. Ensure plugin binaries are in `PATH`

- Go: `%USERPROFILE%\go\bin`
- Rust: `%USERPROFILE%\.cargo\bin`
- Dart: `%LOCALAPPDATA%\Pub\Cache\bin`

## 4. Generate server and client stubs

```bash
cd api
buf generate
```

## Generated outputs

- Go server stubs: `server/internal/api/...`
- Rust desktop stubs: `client/desktop/grpc/...`
- Dart CLI stubs: `client/cli/lib/src/api/...`

## Generator config

The generation targets are defined in [buf.gen.yaml](./buf.gen.yaml).
