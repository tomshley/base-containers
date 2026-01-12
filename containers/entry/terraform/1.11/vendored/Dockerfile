# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

# NOTE:
# Terraform is vendored to guarantee a specific upstream release
# independent of Alpine package availability or version lag.
# This image installs repo-vendored HashiCorp release artifacts
# to ensure reproducibility and stable behavior.

FROM --platform=$BUILDPLATFORM from_image_build_ref

ENV LANG=C.UTF-8

# ---- Artifact identity (Terraform, upstream HashiCorp release) ----
ARG TERRAFORM_VERSION="1.11.4"

ARG TERRAFORM_X64_FILE="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
ARG TERRAFORM_ARM64_FILE="terraform_${TERRAFORM_VERSION}_linux_arm64.zip"

# ---- Upstream-published SHA256 checksums ----
# Recorded at vendoring time
ARG TERRAFORM_X64_SHA256="1ce994251c00281d6845f0f268637ba50c0005657eb3cf096b92f753b42ef4dc"
ARG TERRAFORM_ARM64_SHA256="a43d1d0da9b9bab214a8305a39db0e40869572594ccf50c416a7756499143633"

# ---- Bring vendored artifacts in ----
COPY files/${TERRAFORM_X64_FILE} /tmp/
COPY files/${TERRAFORM_ARM64_FILE} /tmp/

RUN set -eux; \
    apk add --no-cache \
      ca-certificates \
      unzip \
      coreutils; \
    update-ca-certificates; \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
      x86_64)  file="$TERRAFORM_X64_FILE";  checksum="$TERRAFORM_X64_SHA256" ;; \
      aarch64) file="$TERRAFORM_ARM64_FILE"; checksum="$TERRAFORM_ARM64_SHA256" ;; \
      *) echo >&2 "unsupported architecture: $arch"; exit 1 ;; \
    esac; \
    echo "$checksum  /tmp/$file" | sha256sum -c -; \
    unzip "/tmp/$file" -d /usr/local/bin; \
    chmod +x /usr/local/bin/terraform; \
    rm -rf /tmp/* /var/cache/apk/*

ENTRYPOINT ["terraform"]