FROM golang:1.26-alpine AS build

WORKDIR /src

COPY server/internal/go.mod server/internal/go.sum ./server/internal/
COPY server/starter/go.mod server/starter/go.sum ./server/starter/

RUN cd /src/server/internal && go mod download
RUN cd /src/server/starter && go mod download

COPY server/internal ./server/internal
COPY server/starter ./server/starter

RUN cd /src/server/starter && CGO_ENABLED=0 GOOS=linux go build -o /out/secureguard-server .

FROM alpine:3.22

RUN apk add --no-cache ca-certificates postgresql-client

WORKDIR /app

COPY --from=build /out/secureguard-server /app/secureguard-server
COPY server/migrations/scheme/sqlc.sql /app/migrations/sqlc.sql
COPY server/docker-entrypoint.sh /app/docker-entrypoint.sh

RUN chmod +x /app/docker-entrypoint.sh

EXPOSE 50051

ENTRYPOINT ["/app/docker-entrypoint.sh"]
