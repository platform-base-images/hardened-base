# syntax=docker/dockerfile:1@sha256:2780b5c3bab67f1f76c781860de469442999ed1a0d7992a5efdf2cffc0e3d769
# OpenJDK + Maven on Wolfi — standard variant (full JDK + Maven, includes shell).
# Use as the build stage in multi-stage Dockerfiles.
FROM cgr.dev/chainguard/maven:latest-dev@sha256:0fc06dcdcf8dd87cb587f9ae8bc4692f2bcaa52faed9f4435517506a215b03c6

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
RUN apk upgrade --no-cache

USER nonroot
