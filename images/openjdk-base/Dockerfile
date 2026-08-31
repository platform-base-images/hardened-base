# syntax=docker/dockerfile:1@sha256:2780b5c3bab67f1f76c781860de469442999ed1a0d7992a5efdf2cffc0e3d769
# OpenJDK + Maven on Wolfi — standard variant (full JDK + Maven, includes shell).
# Built directly on wolfi-base — the foundation all other images build from.
# Use as the build stage in multi-stage Dockerfiles.
FROM cgr.dev/chainguard/wolfi-base:latest@sha256:57108e597a8cf3bd376b810f1c3539c21942daefa242cb9dddaae30f8aac735d

ARG BUILD_DATE
ARG GIT_REVISION
ARG IMAGE_VERSION=dev

LABEL org.opencontainers.image.source="https://github.com/platform-base-images/hardened-base"
LABEL org.opencontainers.image.version="${IMAGE_VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${GIT_REVISION}"
LABEL org.opencontainers.image.licenses="Apache-2.0"

# Avoids blocking on /dev/random during JVM startup in containers
ENV JAVA_TOOL_OPTIONS="-Djava.security.egd=file:/dev/./urandom" \
    MAVEN_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

WORKDIR /app

USER root
RUN apk add --no-cache \
      ca-certificates \
      tzdata \
      openjdk-21 \
      openjdk-21-default-jdk \
      maven-3.9 && \
    apk upgrade --no-cache

USER nonroot
