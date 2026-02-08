# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC
#
# Docker CLI + Buildx + Compose plugins (vendored)
# Extends entry-docker-cli-29-vendored with build tooling.

FROM --platform=$BUILDPLATFORM from_image_build_ref

ENV LANG=C.UTF-8

# ---- Plugin versions ----
ARG BUILDX_VERSION="0.30.1"
ARG COMPOSE_VERSION="5.0.1"

# ---- Vendored artifact filenames ----
ARG BUILDX_X64_FILE="buildx-v${BUILDX_VERSION}.linux-amd64.tgz"
ARG BUILDX_ARM64_FILE="buildx-v${BUILDX_VERSION}.linux-arm64.tgz"
ARG COMPOSE_X64_FILE="docker-compose-v${COMPOSE_VERSION}.linux-x86_64.tgz"
ARG COMPOSE_ARM64_FILE="docker-compose-v${COMPOSE_VERSION}.linux-aarch64.tgz"

# ---- SHA256 checksums (of the .tgz archives) ----
ARG BUILDX_X64_SHA256="1eee5fce6cce09019742c2c87ef2f29f0b2ef8053c6b54dc7518f0556483beec"
ARG BUILDX_ARM64_SHA256="ece23f6016530f0ee5cd9c674c1715b6d15e940a295c57d3e59ed37ca7d0cdd5"
ARG COMPOSE_X64_SHA256="e4487ffa98fc33c5061313dd8634a1cf8af8eb59fa0948a905344ce524e0dbdb"
ARG COMPOSE_ARM64_SHA256="f16f457207d71c50c2928fd8216ad0dc398e8d3bd8ff3a8b1bca808654aa5a0b"

# ---- Bring vendored artifacts in ----
COPY files/x86_64/${BUILDX_X64_FILE}    /tmp/buildx-x64.tgz
COPY files/aarch64/${BUILDX_ARM64_FILE}  /tmp/buildx-arm64.tgz
COPY files/x86_64/${COMPOSE_X64_FILE}    /tmp/compose-x64.tgz
COPY files/aarch64/${COMPOSE_ARM64_FILE} /tmp/compose-arm64.tgz

# ---- Install Buildx plugin ----
RUN set -eux; \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
      x86_64)  file="/tmp/buildx-x64.tgz";  checksum="$BUILDX_X64_SHA256"; inner="buildx-v${BUILDX_VERSION}.linux-amd64" ;; \
      aarch64) file="/tmp/buildx-arm64.tgz"; checksum="$BUILDX_ARM64_SHA256"; inner="buildx-v${BUILDX_VERSION}.linux-arm64" ;; \
      *) echo >&2 "unsupported architecture: $arch"; exit 1 ;; \
    esac; \
    echo "$checksum  $file" | sha256sum -c -; \
    tar -xzf "$file" -C /tmp; \
    install -D -m 0755 "/tmp/$inner" /usr/local/lib/docker/cli-plugins/docker-buildx; \
    rm -f /tmp/buildx-x64.tgz /tmp/buildx-arm64.tgz "/tmp/$inner"

# ---- Install Compose plugin ----
RUN set -eux; \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
      x86_64)  file="/tmp/compose-x64.tgz";  checksum="$COMPOSE_X64_SHA256"; inner="docker-compose-v${COMPOSE_VERSION}.linux-x86_64" ;; \
      aarch64) file="/tmp/compose-arm64.tgz"; checksum="$COMPOSE_ARM64_SHA256"; inner="docker-compose-v${COMPOSE_VERSION}.linux-aarch64" ;; \
      *) echo >&2 "unsupported architecture: $arch"; exit 1 ;; \
    esac; \
    echo "$checksum  $file" | sha256sum -c -; \
    tar -xzf "$file" -C /tmp; \
    install -D -m 0755 "/tmp/$inner" /usr/local/lib/docker/cli-plugins/docker-compose; \
    rm -f /tmp/compose-x64.tgz /tmp/compose-arm64.tgz "/tmp/$inner"

ENTRYPOINT ["docker"]
