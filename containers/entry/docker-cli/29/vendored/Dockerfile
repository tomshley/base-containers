# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

FROM --platform=$BUILDPLATFORM from_image_build_ref


ENV LANG=C.UTF-8

# ---- Artifact identity (Docker CLI, upstream static) ----
ARG DOCKER_VERSION="29.0.1"

ARG DOCKER_X64_FILE="docker-${DOCKER_VERSION}.tgz"
ARG DOCKER_ARM64_FILE="docker-${DOCKER_VERSION}.tgz"

# ---- Upstream-published SHA256 checksums ----
ARG DOCKER_X64_SHA256="db22bdfb32820540fa7ffedf5e0f3157e238c53be485103b71f083f5580f45a5"
ARG DOCKER_ARM64_SHA256="c5ebae5a51a273aa40141b08157a18950525c1204888a01fa34dac0f45eb17e8"

# ---- Bring vendored artifacts in ----
COPY files/x86_64/${DOCKER_X64_FILE} /tmp/docker-x64.tgz
COPY files/aarch64/${DOCKER_ARM64_FILE} /tmp/docker-arm64.tgz

RUN set -eux; \
    apk add --no-cache \
      ca-certificates \
      tar \
      coreutils; \
    update-ca-certificates; \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
      x86_64)  file="/tmp/docker-x64.tgz"; checksum="$DOCKER_X64_SHA256" ;; \
      aarch64) file="/tmp/docker-arm64.tgz"; checksum="$DOCKER_ARM64_SHA256" ;; \
      *) echo >&2 "unsupported architecture: $arch"; exit 1 ;; \
    esac; \
    echo "$checksum  $file" | sha256sum -c -; \
    tar -xzf "$file" -C /tmp; \
    mv /tmp/docker/docker /usr/local/bin/docker; \
    chmod +x /usr/local/bin/docker; \
    rm -rf /tmp/* /var/cache/apk/*

ENTRYPOINT ["docker"]