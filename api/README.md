# API build

1. Initialize third-party proto submodules:

```bash
git submodule update --init --recursive api/third_party/googleapis api/third_party/grpc-web
```

2. Install local protoc plugins (avoids Buf Registry 403 on remote plugins):

```bash
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
cargo install protoc-gen-prost
cargo install protoc-gen-tonic
```

3. Ensure `protoc-gen-*` binaries are in `PATH`:

- Go: `%USERPROFILE%\go\bin`
- Rust: `%USERPROFILE%\.cargo\bin`

4. Generate server and client stubs:

```bash
cd api
buf generate
```

Generated outputs:
- Go server stubs: `server/internal/api/...`
- Rust client stubs: `client/grpc/...`
