# syntax=docker/dockerfile:1@sha256:2780b5c3bab67f1f76c781860de469442999ed1a0d7992a5efdf2cffc0e3d769
# Hardened Nginx on Wolfi — standard variant.
# Built directly on wolfi-base — the foundation all other images build from.
# Runs as uid 101, listens on 8080, ships with security headers and server_tokens off.
FROM cgr.dev/chainguard/wolfi-base:latest@sha256:30f03343947c7ae3581fda727a6e2aa7b8ce7009b7bfc2ab8d5c9483ace5812f

ARG BUILD_DATE
ARG GIT_REVISION
ARG IMAGE_VERSION=dev

LABEL org.opencontainers.image.source="https://github.com/platform-base-images/hardened-base"
LABEL org.opencontainers.image.version="${IMAGE_VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${GIT_REVISION}"
LABEL org.opencontainers.image.licenses="Apache-2.0"

USER root
RUN apk add --no-cache \
      ca-certificates \
      tzdata \
      nginx-stable \
      nginx-stable-mime-types && \
    apk upgrade --no-cache && \
    { grep -q '^nginx:' /etc/group  || printf 'nginx:x:101:\n' >> /etc/group; } && \
    { grep -q '^nginx:' /etc/passwd || printf 'nginx:x:101:101:nginx:/var/lib/nginx:/sbin/nologin\n' >> /etc/passwd; } && \
    mkdir -p /var/www/html /var/log/nginx /var/lib/nginx/tmp && \
    chown -R 101:101 /var/www/html /var/log/nginx /var/lib/nginx

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080

USER 101:101
