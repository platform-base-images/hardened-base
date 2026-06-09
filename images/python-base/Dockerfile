# syntax=docker/dockerfile:1@sha256:2780b5c3bab67f1f76c781860de469442999ed1a0d7992a5efdf2cffc0e3d769
# Python 3.12 on Wolfi — standard variant (includes shell, pip, venv).
# Use as the build stage in multi-stage Dockerfiles.
FROM cgr.dev/chainguard/python:latest-dev@sha256:11cfc0818fe08d6ddd3d171368fca030bc271a605bd427db3ce0b414a4678368

ARG BUILD_DATE
ARG GIT_REVISION

LABEL org.opencontainers.image.source="https://github.com/platform-base-images/hardened-base"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${GIT_REVISION}"
LABEL org.opencontainers.image.licenses="Apache-2.0"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

USER nonroot
