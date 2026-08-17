# syntax=docker/dockerfile:1@sha256:2780b5c3bab67f1f76c781860de469442999ed1a0d7992a5efdf2cffc0e3d769
# Node.js LTS on Wolfi — standard variant (includes shell, npm, npx).
# Built directly on wolfi-base — the foundation all other images build from.
# Use as the build stage in multi-stage Dockerfiles.
FROM cgr.dev/chainguard/wolfi-base:latest@sha256:0a8fd427de5882aed77471b0a432c3675eda6b6a0ae952b5d640b46da628cdbe

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
RUN apk add --no-cache \
      ca-certificates \
      tzdata \
      nodejs-22 \
      npm && \
    apk upgrade --no-cache

USER nonroot
