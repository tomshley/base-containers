# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

# NOTE:
# Rust is vendored as a standalone static-musl toolchain.
# We vendor because CI runners must not reach out to the internet
# for toolchain downloads (reproducibility + air-gap readiness).
# This image tracks Rust v1.83.x exactly.
#
# Vendoring steps:
#   1. Download from https://static.rust-lang.org/dist/
#      - rust-1.83.0-x86_64-unknown-linux-musl.tar.xz
#      - rust-1.83.0-aarch64-unknown-linux-musl.tar.xz
#   2. Record sha256 checksums
#   3. Place in files/ directory

# NOTE: Uses $TARGETPLATFORM (not $BUILDPLATFORM like other entry images)
# because the Rust standalone installer contains native arch-specific binaries.
# With $BUILDPLATFORM, cross-builds would install the wrong architecture
# toolchain since apk --print-arch reports the build host arch, not target.
# Trade-off: cross-builds use QEMU emulation (slower) but produce correct images.
FROM --platform=$TARGETPLATFORM from_image_build_ref

ENV LANG=C.UTF-8

# ---- Artifact identity (Rust, upstream static-musl standalone installer) ----
ARG RUST_VERSION="1.83.0"

ARG RUST_X64_FILE="rust-${RUST_VERSION}-x86_64-unknown-linux-musl.tar.xz"
ARG RUST_ARM64_FILE="rust-${RUST_VERSION}-aarch64-unknown-linux-musl.tar.xz"

# ---- Upstream-published SHA256 checksums (recorded at vendoring time) ----
ARG RUST_X64_SHA256="0afd3628e568861bc5295da728da3d27b1ee8db1ea7d182f7a6f2db789227d9f"
ARG RUST_ARM64_SHA256="026340facccb5cf2e0aba7f4507add11f1b6d101c7943fcf1c961fca1a935f84"

ARG BINARIES_PREFIX="/opt"

# ---- Bring vendored artifacts in ----
COPY files/${RUST_X64_FILE} /tmp/
COPY files/${RUST_ARM64_FILE} /tmp/

RUN set -eux; \
    apk add --no-cache \
      bash \
      ca-certificates \
      coreutils \
      musl-dev; \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
      x86_64)  file="$RUST_X64_FILE";  checksum="$RUST_X64_SHA256" ;; \
      aarch64) file="$RUST_ARM64_FILE"; checksum="$RUST_ARM64_SHA256" ;; \
      *) echo >&2 "unsupported architecture: $arch"; exit 1 ;; \
    esac; \
    echo "$checksum  /tmp/$file" | sha256sum -c -; \
    mkdir -p /tmp/rust-extract; \
    tar xJf "/tmp/$file" -C /tmp/rust-extract --strip-components=1; \
    /tmp/rust-extract/install.sh --prefix=${BINARIES_PREFIX}/rust --without=rust-docs; \
    rm -rf /tmp/* /var/cache/apk/*

ENV CARGO_HOME=${BINARIES_PREFIX}/rust
ENV PATH="${BINARIES_PREFIX}/rust/bin:${PATH}"

COPY --chmod=755 files/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["sh"]
