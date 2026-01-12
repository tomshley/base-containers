# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

FROM --platform=$BUILDPLATFORM from_image_build_ref

# NOTE:
# This is a vendored OpenTofu build.
# We vendor because Alpine stable lags upstream releases.
# This image tracks OpenTofu v1.11.x exactly.

FROM --platform=$BUILDPLATFORM from_image_build_ref

ENV LANG=C.UTF-8

# ---- Artifact identity (OpenTofu, upstream Alpine .apk) ----
ARG OPENTOFU_VERSION="1.11.2"

ARG OPENTOFU_X64_FILE="tofu_${OPENTOFU_VERSION}_amd64.apk"
ARG OPENTOFU_ARM64_FILE="tofu_${OPENTOFU_VERSION}_arm.apk"

# (recorded at vendoring time)
ARG OPENTOFU_X64_SHA256="f2857457968c09f0b332ff97544936b83920149a438a06a60513f86a7584d799"
ARG OPENTOFU_ARM64_SHA256="5d9f1c5d0008326c11bafe97a3e2712d2890e7369e18b63fddc6bac29c62e39b"

# ---- Bring vendored artifacts in ----
COPY files/${OPENTOFU_X64_FILE} /tmp/
COPY files/${OPENTOFU_ARM64_FILE} /tmp/

RUN set -eux; \
    apk add --no-cache \
      ca-certificates \
      coreutils; \
    update-ca-certificates; \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
      x86_64)  file="$OPENTOFU_X64_FILE";  checksum="$OPENTOFU_X64_SHA256" ;; \
      aarch64) file="$OPENTOFU_ARM64_FILE"; checksum="$OPENTOFU_ARM64_SHA256" ;; \
      *) echo >&2 "unsupported architecture: $arch"; exit 1 ;; \
    esac; \
    echo "$checksum  /tmp/$file" | sha256sum -c -; \
    apk add --no-cache --allow-untrusted "/tmp/$file"; \
    rm -rf /tmp/* /var/cache/apk/*

ENTRYPOINT ["tofu"]