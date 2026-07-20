# syntax=docker/dockerfile:1@sha256:2780b5c3bab67f1f76c781860de469442999ed1a0d7992a5efdf2cffc0e3d769
# Hardened Nginx on Wolfi — standard variant.
# Runs as uid 101, listens on 8080, ships with security headers and server_tokens off.
FROM cgr.dev/chainguard/nginx:latest@sha256:65ad444a372b9f69821ef15acb95c46e9cffdd520bbdc4f8a72d5d38d7c1ca92

ARG BUILD_DATE
ARG GIT_REVISION
ARG IMAGE_VERSION=dev

LABEL org.opencontainers.image.source="https://github.com/platform-base-images/hardened-base"
LABEL org.opencontainers.image.version="${IMAGE_VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${GIT_REVISION}"
LABEL org.opencontainers.image.licenses="Apache-2.0"

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080

USER 101:101
