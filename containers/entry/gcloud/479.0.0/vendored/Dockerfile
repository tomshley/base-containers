# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

# Vendored Google Cloud SDK (gcloud)
#
# NOTE:
# The Google Cloud SDK is vendored to guarantee a specific upstream
# release independent of Alpine package availability or drift.
# This image installs repo-vendored official Google artifacts and
# is intended for explicit composition in CI runners.

FROM --platform=$BUILDPLATFORM from_image_build_ref

ENV LANG=C.UTF-8
ENV CLOUDSDK_PYTHON_SITEPACKAGES=1

# ---- Artifact identity (Google Cloud SDK) ----
ARG GCLOUD_VERSION="479.0.0"

ARG GCLOUD_X64_FILE="google-cloud-cli-${GCLOUD_VERSION}-linux-x86_64.tar.gz"
ARG GCLOUD_ARM64_FILE="google-cloud-cli-${GCLOUD_VERSION}-linux-arm.tar.gz"

# ---- Upstream SHA256 checksums (recorded at vendoring time) ----
ARG GCLOUD_X64_SHA256="82b01bc36bd60ea9ce0284de3e424f7b09f54acc9118b353f15951d33c5fe15c"
ARG GCLOUD_ARM64_SHA256="84d5686ad0d9b5c39476911134b97f7a1e84032972b13b68d4aea22b691563d7"

# ---- Bring vendored artifacts in ----
COPY files/${GCLOUD_X64_FILE} /tmp/
COPY files/${GCLOUD_ARM64_FILE} /tmp/

RUN set -eux; \
    apk add --no-cache \
      ca-certificates \
      bash \
      coreutils; \
    update-ca-certificates; \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
      x86_64)  file="$GCLOUD_X64_FILE";  checksum="$GCLOUD_X64_SHA256" ;; \
      aarch64) file="$GCLOUD_ARM64_FILE"; checksum="$GCLOUD_ARM64_SHA256" ;; \
      *) echo >&2 "unsupported architecture: $arch"; exit 1 ;; \
    esac; \
    echo "$checksum  /tmp/$file" | sha256sum -c -; \
    tar -xzf "/tmp/$file" -C /opt; \
    ln -s /opt/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud; \
    ln -s /opt/google-cloud-sdk/bin/gsutil /usr/local/bin/gsutil; \
    ln -s /opt/google-cloud-sdk/bin/gcloud /usr/local/bin/gke-gcloud-auth-plugin; \
    rm -rf /tmp/* /var/cache/apk/*

ENV PATH="/opt/google-cloud-sdk/bin:${PATH}"

ENTRYPOINT ["gcloud"]
