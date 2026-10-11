# syntax=docker/dockerfile:1@sha256:2780b5c3bab67f1f76c781860de469442999ed1a0d7992a5efdf2cffc0e3d769
# Python 3.14 on Wolfi for model-serving workloads — standard variant.
# Built directly on wolfi-base — the foundation all other images build from.
#
# Same runtime as python-base, plus the native libraries ML wheels link against
# (onnxruntime, tokenizers, torch CPU) and governance-oriented defaults:
#   - Hugging Face libraries run offline: models must be baked in at build time,
#     where they can be scanned and signed, never pulled at runtime.
#   - torch.load defaults to weights_only=True, blocking pickle code execution.
#   - /models is root-owned and read-only to nonroot, so a compromised process
#     cannot swap the model it is serving.
# ML libraries themselves are not included — Wolfi does not package them for
# Python 3.14, and each app should pin and scan its own wheels.
FROM cgr.dev/chainguard/wolfi-base:latest@sha256:1c451d46a0d5c4e9f2b38e0e8d3e299564a1aa95c21973efcc1980a9d1d2e73e

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
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    MODEL_DIR=/models \
    HF_HUB_OFFLINE=1 \
    HF_DATASETS_OFFLINE=1 \
    TRANSFORMERS_OFFLINE=1 \
    HF_HUB_DISABLE_TELEMETRY=1 \
    TORCH_FORCE_WEIGHTS_ONLY_LOAD=1

WORKDIR /app

USER root
RUN apk add --no-cache \
      ca-certificates \
      tzdata \
      python-3.14 \
      py3.14-pip \
      libstdc++ \
      libgomp && \
    apk upgrade --no-cache && \
    install -d -o root -g root -m 0555 /models

USER nonroot
