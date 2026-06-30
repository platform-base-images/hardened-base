# syntax=docker/dockerfile:1@sha256:2780b5c3bab67f1f76c781860de469442999ed1a0d7992a5efdf2cffc0e3d769
# Go toolchain on Wolfi — standard variant (full Go toolchain, includes shell).
# Use as the build stage in multi-stage Dockerfiles; pair with Dockerfile.distroless for runtime.
FROM cgr.dev/chainguard/go:latest-dev@sha256:6791de9c48e3a2e7f5f03a5a02821c1273421a7f22b9ee564e777adda9c3f225

ARG BUILD_DATE
ARG GIT_REVISION

LABEL org.opencontainers.image.source="https://github.com/platform-base-images/hardened-base"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${GIT_REVISION}"
LABEL org.opencontainers.image.licenses="Apache-2.0"

# CGO_ENABLED=0 produces a fully static binary with no libc dependency
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOPATH=/go \
    GOPROXY=https://proxy.golang.org,direct

WORKDIR /app

USER nonroot
