# syntax=docker/dockerfile:1@sha256:2780b5c3bab67f1f76c781860de469442999ed1a0d7992a5efdf2cffc0e3d769
# Node.js LTS on Wolfi — standard variant (includes shell, npm, npx).
# Use as the build stage in multi-stage Dockerfiles.
FROM cgr.dev/chainguard/node:latest-dev@sha256:7137fadb43a7cee4a01495749973f3c8c44a1d02319d9beb543bdb21cb6e874e

ARG BUILD_DATE
ARG GIT_REVISION
ARG IMAGE_VERSION=dev

LABEL org.opencontainers.image.source="https://github.com/platform-base-images/hardened-base"
LABEL org.opencontainers.image.version="${IMAGE_VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${GIT_REVISION}"
LABEL org.opencontainers.image.licenses="Apache-2.0"

ENV NODE_ENV=production \
    NPM_CONFIG_LOGLEVEL=warn \
    NPM_CONFIG_UPDATE_NOTIFIER=false

WORKDIR /app

USER root
RUN apk upgrade --no-cache && \
    { grep -q '^nonroot:' /etc/passwd || printf 'nonroot:x:65532:65532:nonroot:/home/nonroot:/sbin/nologin\n' >> /etc/passwd; } && \
    { grep -q '^nonroot:' /etc/group  || printf 'nonroot:x:65532:\n' >> /etc/group; }

USER nonroot