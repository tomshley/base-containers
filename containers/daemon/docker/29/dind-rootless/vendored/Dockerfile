# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC
#
# Docker-in-Docker (rootless, vendored)
# Derived from docker-library/docker (Apache-2.0)
# https://github.com/docker-library/docker

FROM --platform=$BUILDPLATFORM from_image_build_ref

# ---- Versions (pin explicitly) ----
ARG DOCKER_VERSION="29.1.5"
ARG BUILDX_VERSION="0.30.1"
ARG COMPOSE_VERSION="5.0.1"

# ---- Vendored artifact filenames ----
ARG DOCKER_X64_FILE="docker-${DOCKER_VERSION}.tgz"
ARG DOCKER_ARM64_FILE="docker-${DOCKER_VERSION}.tgz"
ARG DOCKER_ROOTLESS_X64_FILE="docker-rootless-extras-${DOCKER_VERSION}.tgz"
ARG DOCKER_ROOTLESS_ARM64_FILE="docker-rootless-extras-${DOCKER_VERSION}.tgz"
ARG BUILDX_X64_FILE="buildx-v${BUILDX_VERSION}.linux-amd64"
ARG BUILDX_ARM64_FILE="buildx-v${BUILDX_VERSION}.linux-arm64"
ARG COMPOSE_X64_FILE="docker-compose-v${COMPOSE_VERSION}.linux-x86_64"
ARG COMPOSE_ARM64_FILE="docker-compose-v${COMPOSE_VERSION}.linux-aarch64"

# ---- Upstream SHA256 checksums (recorded at vendoring time) ----
ARG DOCKER_X64_SHA256="882bb03f3fd36ad565b1362f5bbb5d5af5f2410a5c10cae3f9d3d54e2540adc2"
ARG DOCKER_ARM64_SHA256="c07ed6ce22375c4ba24cca554dc99cbc31ab2da24d893a5f2d4bd1854e8eaadd"
ARG DOCKER_ROOTLESS_X64_SHA256="e1914640fb749558f88019cac57ecb83e68e3dcba4fedfd99e5904f1fa27fba6"
ARG DOCKER_ROOTLESS_ARM64_SHA256="6dbb9c6146bdb34781250f31ad4cbb13b4dfeb3f3f557917d0e90418f58e0700"
ARG BUILDX_X64_SHA256="c37114fcd034025ec68e224657c8a5a850df472ded3ddcbca75ad3a7ebb9710d"
ARG BUILDX_ARM64_SHA256="31d012d52d6df68aef4b55db62330967b562811f0de30cdfaa4505f314797c76"
ARG COMPOSE_X64_SHA256="cdc1df64412ed009312afbc044b3625144d06c07736e2f7a77fb0460531b9327"
ARG COMPOSE_ARM64_SHA256="e3b36491a75f92c35ebfbbe6e4741bd2429664edf3971427983d67c0b21e7d1d"

# ---- Bring vendored artifacts in ----
COPY files/x86_64/${DOCKER_X64_FILE}            /tmp/docker-x64.tgz
COPY files/aarch64/${DOCKER_ARM64_FILE}          /tmp/docker-arm64.tgz
COPY files/x86_64/${DOCKER_ROOTLESS_X64_FILE}    /tmp/rootless-x64.tgz
COPY files/aarch64/${DOCKER_ROOTLESS_ARM64_FILE} /tmp/rootless-arm64.tgz
COPY files/x86_64/${BUILDX_X64_FILE}             /tmp/buildx-x64
COPY files/aarch64/${BUILDX_ARM64_FILE}          /tmp/buildx-arm64
COPY files/x86_64/${COMPOSE_X64_FILE}            /tmp/compose-x64
COPY files/aarch64/${COMPOSE_ARM64_FILE}         /tmp/compose-arm64

# ---- Base dependencies ----
RUN apk add --no-cache \
      ca-certificates \
      bash \
      curl \
      git \
      iproute2 \
      iptables \
      iptables-legacy \
      openssl \
      shadow-uidmap \
      fuse-overlayfs \
      slirp4netns \
      pigz \
      xz \
      zfs \
      btrfs-progs \
      e2fsprogs \
      e2fsprogs-extra \
      xfsprogs \
      wget \
      tini \
      coreutils \
 && update-ca-certificates

# ---- Docker user namespace support ----
RUN addgroup -S dockremap \
 && adduser -S -G dockremap dockremap \
 && echo 'dockremap:165536:65536' >> /etc/subuid \
 && echo 'dockremap:165536:65536' >> /etc/subgid

# ---- Rootless user ----
RUN adduser -h /home/rootless -g 'Rootless' -D -u 1000 rootless \
 && echo 'rootless:100000:65536' >> /etc/subuid \
 && echo 'rootless:100000:65536' >> /etc/subgid

# ---- Install Docker static binaries (vendored) ----
RUN set -eux; \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
      x86_64)  file="/tmp/docker-x64.tgz";  checksum="$DOCKER_X64_SHA256" ;; \
      aarch64) file="/tmp/docker-arm64.tgz"; checksum="$DOCKER_ARM64_SHA256" ;; \
      *) echo >&2 "unsupported architecture: $arch"; exit 1 ;; \
    esac; \
    echo "$checksum  $file" | sha256sum -c -; \
    tar --extract \
      --file "$file" \
      --strip-components 1 \
      --directory /usr/local/bin \
      --no-same-owner \
      docker; \
    rm -f /tmp/docker-x64.tgz /tmp/docker-arm64.tgz; \
    dockerd --version; \
    docker --version

# ---- Rootless extras (vendored) ----
RUN set -eux; \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
      x86_64)  file="/tmp/rootless-x64.tgz";  checksum="$DOCKER_ROOTLESS_X64_SHA256" ;; \
      aarch64) file="/tmp/rootless-arm64.tgz"; checksum="$DOCKER_ROOTLESS_ARM64_SHA256" ;; \
      *) echo >&2 "unsupported architecture: $arch"; exit 1 ;; \
    esac; \
    echo "$checksum  $file" | sha256sum -c -; \
    tar --extract \
      --file "$file" \
      --strip-components 1 \
      --directory /usr/local/bin \
      docker-rootless-extras/rootlesskit \
      docker-rootless-extras/vpnkit; \
    rm -f /tmp/rootless-x64.tgz /tmp/rootless-arm64.tgz; \
    rootlesskit --version

# ---- Buildx plugin (vendored) ----
RUN set -eux; \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
      x86_64)  file="/tmp/buildx-x64";  checksum="$BUILDX_X64_SHA256" ;; \
      aarch64) file="/tmp/buildx-arm64"; checksum="$BUILDX_ARM64_SHA256" ;; \
      *) echo >&2 "unsupported architecture: $arch"; exit 1 ;; \
    esac; \
    echo "$checksum  $file" | sha256sum -c -; \
    install -D -m 0755 "$file" /usr/local/libexec/docker/cli-plugins/docker-buildx; \
    rm -f /tmp/buildx-x64 /tmp/buildx-arm64

# ---- Docker Compose plugin (vendored) ----
RUN set -eux; \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
      x86_64)  file="/tmp/compose-x64";  checksum="$COMPOSE_X64_SHA256" ;; \
      aarch64) file="/tmp/compose-arm64"; checksum="$COMPOSE_ARM64_SHA256" ;; \
      *) echo >&2 "unsupported architecture: $arch"; exit 1 ;; \
    esac; \
    echo "$checksum  $file" | sha256sum -c -; \
    install -D -m 0755 "$file" /usr/local/libexec/docker/cli-plugins/docker-compose; \
    ln -s /usr/local/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose; \
    rm -f /tmp/compose-x64 /tmp/compose-arm64

# ---- Runtime directories ----
RUN mkdir -p /run/user /home/rootless/.local/share/docker \
 && chmod 1777 /run/user \
 && chown -R rootless:rootless /home/rootless

VOLUME /home/rootless/.local/share/docker

# ---- Entrypoint ----
COPY --chmod=755 files/dockerd-entrypoint.sh /usr/local/bin/dockerd-entrypoint.sh

USER rootless

ENTRYPOINT ["tini","--","dockerd-entrypoint.sh"]
