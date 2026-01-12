# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC
#
# Docker-in-Docker (rootless, vendored)
# Derived from docker-library/docker (Apache-2.0)
# https://github.com/docker-library/docker

FROM --platform=$BUILDPLATFORM from_image_build_ref

# ---- Versions (pin explicitly) ----
ENV DOCKER_VERSION=29.1.4
ENV BUILDX_VERSION=0.30.1
ENV COMPOSE_VERSION=5.0.1

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

# ---- Install Docker static binaries (BusyBox + Docker 29+ safe) ----
RUN set -eux; \
  apkArch="$(apk --print-arch)"; \
  case "$apkArch" in \
    x86_64) url="https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" ;; \
    aarch64) url="https://download.docker.com/linux/static/stable/aarch64/docker-${DOCKER_VERSION}.tgz" ;; \
    *) echo "unsupported arch: $apkArch" >&2; exit 1 ;; \
  esac; \
  wget -O docker.tgz "$url"; \
  tar --extract \
    --file docker.tgz \
    --strip-components 1 \
    --directory /usr/local/bin \
    --no-same-owner \
    docker; \
  rm docker.tgz; \
  dockerd --version; \
  docker --version

# ---- Rootless extras (rootlesskit, vpnkit) ----
RUN set -eux; \
  apkArch="$(apk --print-arch)"; \
  case "$apkArch" in \
    x86_64) url="https://download.docker.com/linux/static/stable/x86_64/docker-rootless-extras-${DOCKER_VERSION}.tgz" ;; \
    aarch64) url="https://download.docker.com/linux/static/stable/aarch64/docker-rootless-extras-${DOCKER_VERSION}.tgz" ;; \
    *) echo "unsupported arch: $apkArch" >&2; exit 1 ;; \
  esac; \
  wget -O rootless.tgz "$url"; \
  tar --extract \
    --file rootless.tgz \
    --strip-components 1 \
    --directory /usr/local/bin \
    docker-rootless-extras/rootlesskit \
    docker-rootless-extras/vpnkit; \
  rm rootless.tgz; \
  rootlesskit --version

# ---- Buildx plugin ----
RUN set -eux; \
  apkArch="$(apk --print-arch)"; \
  case "$apkArch" in \
    x86_64) url="https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.linux-amd64" ;; \
    aarch64) url="https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.linux-arm64" ;; \
    *) echo "unsupported arch: $apkArch" >&2; exit 1 ;; \
  esac; \
  install -D -m 0755 <(wget -qO- "$url") /usr/local/libexec/docker/cli-plugins/docker-buildx

# ---- Docker Compose plugin ----
RUN set -eux; \
  apkArch="$(apk --print-arch)"; \
  case "$apkArch" in \
    x86_64) url="https://github.com/docker/compose/releases/download/v${COMPOSE_VERSION}/docker-compose-linux-x86_64" ;; \
    aarch64) url="https://github.com/docker/compose/releases/download/v${COMPOSE_VERSION}/docker-compose-linux-aarch64" ;; \
    *) echo "unsupported arch: $apkArch" >&2; exit 1 ;; \
  esac; \
  install -D -m 0755 <(wget -qO- "$url") /usr/local/libexec/docker/cli-plugins/docker-compose \
 && ln -s /usr/local/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose

# ---- Runtime directories ----
RUN mkdir -p /run/user /home/rootless/.local/share/docker \
 && chmod 1777 /run/user \
 && chown -R rootless:rootless /home/rootless

VOLUME /home/rootless/.local/share/docker

# ---- Entrypoint ----
COPY files/dockerd-entrypoint.sh /usr/local/bin/dockerd-entrypoint.sh

USER rootless

ENTRYPOINT ["tini","--","dockerd-entrypoint.sh"]
