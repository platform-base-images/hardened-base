# syntax=docker/dockerfile:1@sha256:2780b5c3bab67f1f76c781860de469442999ed1a0d7992a5efdf2cffc0e3d769
# OpenJDK + Maven on Wolfi — standard variant (full JDK + Maven, includes shell).
# Use as the build stage in multi-stage Dockerfiles.
FROM cgr.dev/chainguard/maven:latest-dev@sha256:a08efa799d029893f28df73d23ff1290325455037aaf4cc206799b545a4dce8f

ARG BUILD_DATE
ARG GIT_REVISION

LABEL org.opencontainers.image.source="https://github.com/platform-base-images/hardened-base"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.revision="${GIT_REVISION}"
LABEL org.opencontainers.image.licenses="Apache-2.0"

# Avoids blocking on /dev/random during JVM startup in containers
ENV JAVA_TOOL_OPTIONS="-Djava.security.egd=file:/dev/./urandom" \
    MAVEN_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

WORKDIR /app

USER nonroot
