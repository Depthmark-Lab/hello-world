# ─────────────────────────────────────────────────────────────────────────────
# Stage 1: Builder
# Compile the Go binary with CGO disabled for static linking
# ─────────────────────────────────────────────────────────────────────────────
FROM golang:1.24-alpine AS builder

WORKDIR /build

# Copy dependency files first (better layer caching)
COPY go.mod ./
RUN go mod download

# Copy source
COPY cmd/ ./cmd/

# Build static binary
ARG TARGETOS=linux
ARG TARGETARCH=amd64
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build -ldflags="-s -w" -o /hello-world ./cmd/hello-world

# ─────────────────────────────────────────────────────────────────────────────
# Stage 2: Runtime
# Distroless static image — no shell, no package manager, minimal attack surface
# ─────────────────────────────────────────────────────────────────────────────
FROM gcr.io/distroless/static-debian12:nonroot

LABEL maintainer="Alexandre Delisle <oss@adelisle.com>"
LABEL description="Hello World"
# x-release-please-start-version
LABEL version="1.3.0"
# x-release-please-end

# Copy the static binary from builder
COPY --from=builder /hello-world /hello-world

# Distroless nonroot image runs as uid 65534 by default
USER nonroot:nonroot

# Entrypoint
ENTRYPOINT ["/hello-world"]
