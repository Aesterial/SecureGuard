FROM golang:1.26-alpine AS build

ARG COMMIT_HASH=dev
ARG BUILD_TIME=1970-01-01T00:00:00Z

WORKDIR /src

COPY internal/go.mod internal/go.sum ./internal/
COPY starter/go.mod starter/go.sum ./starter/

RUN cd /src/internal && go mod download
RUN cd /src/starter && go mod download

COPY internal ./internal
COPY starter ./starter

RUN cd /src/starter && CGO_ENABLED=0 GOOS=linux go build \
	-ldflags="-s -w -X github.com/aesterial/secureguard/internal/shared/metadata.CommitHash=${COMMIT_HASH} -X github.com/aesterial/secureguard/internal/shared/metadata.BuildTime=${BUILD_TIME}" \
	-o /out/secureguard-server .

FROM alpine:3.22

RUN apk add --no-cache ca-certificates postgresql-client

WORKDIR /app

COPY --from=build /out/secureguard-server /app/secureguard-server
COPY migrations/scheme/sqlc.sql /app/migrations/sqlc.sql
COPY docker-entrypoint.sh /app/docker-entrypoint.sh

RUN chmod +x /app/docker-entrypoint.sh

EXPOSE 50051

ENTRYPOINT ["/app/docker-entrypoint.sh"]
