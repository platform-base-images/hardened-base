# syntax=docker/dockerfile:1@sha256:2780b5c3bab67f1f76c781860de469442999ed1a0d7992a5efdf2cffc0e3d769
# Wolfi OS base — the foundation all other images build from.
# Pin updated weekly by Renovate. Run `make scan IMAGE=wolfi-base` to verify CVE count.
FROM cgr.dev/chainguard/wolfi-base:latest@sha256:42df77a9974d6ec8b17a5ee8bc23b532600a44d705acef2409e0933c1251b45f

ARG BUILD_DATE
ARG GIT_REVISION

LABEL org.opencontainers.image.source="https://github.com/platform-base-images/hardened-base"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${GIT_REVISION}"
LABEL org.opencontainers.image.licenses="Apache-2.0"

RUN apk add --no-cache \
    ca-certificates \
    tzdata

USER nonroot
CMD ["/bin/sh"]