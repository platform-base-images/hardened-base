# syntax=docker/dockerfile:1@sha256:2780b5c3bab67f1f76c781860de469442999ed1a0d7992a5efdf2cffc0e3d769
# Go toolchain on Wolfi — standard variant (full Go toolchain, includes shell).
# Use as the build stage in multi-stage Dockerfiles; pair with Dockerfile.distroless for runtime.
FROM cgr.dev/chainguard/go:latest-dev@sha256:c0c5ae1297b2bd63308f45d8936d1d14f3046ca8e2b75cc37e87552732ab9bea

ARG BUILD_DATE
ARG GIT_REVISION
ARG IMAGE_VERSION=dev

LABEL org.opencontainers.image.source="https://github.com/platform-base-images/hardened-base"
LABEL org.opencontainers.image.version="${IMAGE_VERSION}"
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
