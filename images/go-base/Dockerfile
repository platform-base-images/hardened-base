# syntax=docker/dockerfile:1@sha256:2780b5c3bab67f1f76c781860de469442999ed1a0d7992a5efdf2cffc0e3d769
# Go toolchain on Wolfi — standard variant (full Go toolchain, includes shell).
# Use as the build stage in multi-stage Dockerfiles; pair with Dockerfile.distroless for runtime.
FROM cgr.dev/chainguard/go:latest-dev@sha256:dcc2c58871e6ea1cb28f8c83468c719adc9cd41f33786d88e6f52d9be6dd5115

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
