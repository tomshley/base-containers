# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

FROM --platform=$BUILDPLATFORM from_image_build_ref


ENV LANG=C.UTF-8

# ---- Artifact identity (Docker CLI, upstream static) ----
ARG DOCKER_VERSION="29.1.5"

ARG DOCKER_X64_FILE="docker-${DOCKER_VERSION}.tgz"
ARG DOCKER_ARM64_FILE="docker-${DOCKER_VERSION}.tgz"

# ---- Upstream-published SHA256 checksums ----
ARG DOCKER_X64_SHA256="882bb03f3fd36ad565b1362f5bbb5d5af5f2410a5c10cae3f9d3d54e2540adc2"
ARG DOCKER_ARM64_SHA256="c07ed6ce22375c4ba24cca554dc99cbc31ab2da24d893a5f2d4bd1854e8eaadd"

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