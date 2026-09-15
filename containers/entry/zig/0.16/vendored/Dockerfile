# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

# NOTE:
# Zig is vendored as a pre-built static binary distribution.
# We vendor because CI runners must not reach out to the internet
# for toolchain downloads (reproducibility + air-gap readiness).
# This image tracks Zig v0.16.x exactly.
#
# Vendoring steps:
#   1. Download from https://ziglang.org/download/
#      - zig-x86_64-linux-0.16.0.tar.xz
#      - zig-aarch64-linux-0.16.0.tar.xz
#   2. Record sha256 checksums (from https://ziglang.org/download/index.json)
#   3. Place in files/ directory

# NOTE: Uses $TARGETPLATFORM rather than $BUILDPLATFORM
# because the Zig binary distribution contains native arch-specific binaries.
# With $BUILDPLATFORM, cross-builds would install the wrong architecture
# binary since apk --print-arch reports the build host arch, not target.
# Trade-off: cross-builds use QEMU emulation (slower) but produce correct images.
FROM --platform=$TARGETPLATFORM from_image_build_ref

ENV LANG=C.UTF-8

# ---- Artifact identity (Zig, upstream pre-built binary distribution) ----
ARG ZIG_VERSION="0.16.0"

ARG ZIG_X64_FILE="zig-x86_64-linux-${ZIG_VERSION}.tar.xz"
ARG ZIG_ARM64_FILE="zig-aarch64-linux-${ZIG_VERSION}.tar.xz"

# ---- Upstream-published SHA256 checksums (recorded at vendoring time) ----
ARG ZIG_X64_SHA256="70e49664a74374b48b51e6f3fdfbf437f6395d42509050588bd49abe52ba3d00"
ARG ZIG_ARM64_SHA256="ea4b09bfb22ec6f6c6ceac57ab63efb6b46e17ab08d21f69f3a48b38e1534f17"

ARG BINARIES_PREFIX="/opt"

# ---- Bring vendored artifacts in ----
COPY files/${ZIG_X64_FILE} /tmp/
COPY files/${ZIG_ARM64_FILE} /tmp/

RUN set -eux; \
    apk add --no-cache \
      bash \
      ca-certificates \
      coreutils; \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
      x86_64)  file="$ZIG_X64_FILE";  checksum="$ZIG_X64_SHA256" ;; \
      aarch64) file="$ZIG_ARM64_FILE"; checksum="$ZIG_ARM64_SHA256" ;; \
      *) echo >&2 "unsupported architecture: $arch"; exit 1 ;; \
    esac; \
    echo "$checksum  /tmp/$file" | sha256sum -c -; \
    mkdir -p ${BINARIES_PREFIX}/zig; \
    tar xJf "/tmp/$file" -C ${BINARIES_PREFIX}/zig --strip-components=1; \
    rm -rf /tmp/* /var/cache/apk/*

ENV PATH="${BINARIES_PREFIX}/zig:${PATH}"

COPY --chmod=755 files/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["sh"]
