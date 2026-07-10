# syntax=docker/dockerfile:1@sha256:2780b5c3bab67f1f76c781860de469442999ed1a0d7992a5efdf2cffc0e3d769
# Python 3.12 on Wolfi — standard variant (includes shell, pip, venv).
# Use as the build stage in multi-stage Dockerfiles.
FROM cgr.dev/chainguard/python:latest-dev@sha256:727c118ee34aab194fa2b25c0116f669fc1459fd6bda6e2f570a15c75c9fda4e

ARG BUILD_DATE
ARG GIT_REVISION
ARG IMAGE_VERSION=dev

LABEL org.opencontainers.image.source="https://github.com/platform-base-images/hardened-base"
LABEL org.opencontainers.image.version="${IMAGE_VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${GIT_REVISION}"
LABEL org.opencontainers.image.licenses="Apache-2.0"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

USER root
RUN apk upgrade --no-cache && \
    { grep -q '^nonroot:' /etc/passwd || printf 'nonroot:x:65532:65532:nonroot:/home/nonroot:/sbin/nologin\n' >> /etc/passwd; } && \
    { grep -q '^nonroot:' /etc/group  || printf 'nonroot:x:65532:\n' >> /etc/group; }

USER nonroot
