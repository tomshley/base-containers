# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

# NOTE:
# Zig is vendored as a pre-built static binary distribution.
# We vendor because CI runners must not reach out to the internet
# for toolchain downloads (reproducibility + air-gap readiness).
# This image tracks Zig v0.15.x exactly.
#
# Vendoring steps:
#   1. Download from https://ziglang.org/download/
#      - zig-x86_64-linux-0.15.2.tar.xz
#      - zig-aarch64-linux-0.15.2.tar.xz
#   2. Record sha256 checksums (from https://ziglang.org/download/index.json)
#   3. Place in files/ directory

# NOTE: Uses $TARGETPLATFORM (not $BUILDPLATFORM like other entry images)
# because the Zig binary distribution contains native arch-specific binaries.
# With $BUILDPLATFORM, cross-builds would install the wrong architecture
# binary since apk --print-arch reports the build host arch, not target.
# Trade-off: cross-builds use QEMU emulation (slower) but produce correct images.
FROM --platform=$TARGETPLATFORM from_image_build_ref

ENV LANG=C.UTF-8

# ---- Artifact identity (Zig, upstream pre-built binary distribution) ----
ARG ZIG_VERSION="0.15.2"

ARG ZIG_X64_FILE="zig-x86_64-linux-${ZIG_VERSION}.tar.xz"
ARG ZIG_ARM64_FILE="zig-aarch64-linux-${ZIG_VERSION}.tar.xz"

# ---- Upstream-published SHA256 checksums (recorded at vendoring time) ----
ARG ZIG_X64_SHA256="02aa270f183da276e5b5920b1dac44a63f1a49e55050ebde3aecc9eb82f93239"
ARG ZIG_ARM64_SHA256="958ed7d1e00d0ea76590d27666efbf7a932281b3d7ba0c6b01b0ff26498f667f"

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
