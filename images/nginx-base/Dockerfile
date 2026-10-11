# syntax=docker/dockerfile:1@sha256:2780b5c3bab67f1f76c781860de469442999ed1a0d7992a5efdf2cffc0e3d769
# Hardened Nginx on Wolfi — standard variant.
# Runs as uid 101, listens on 8080, ships with security headers and server_tokens off.
FROM cgr.dev/chainguard/nginx:latest@sha256:028368a7e271b3e0aed3bdc82195de6b38a2fee2bdd2a0b7ce1c4b944907098c

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
