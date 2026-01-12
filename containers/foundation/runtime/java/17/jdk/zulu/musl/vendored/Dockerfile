# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

FROM --platform=$BUILDPLATFORM from_image_build_ref

ENV LANG=C.UTF-8

# ---- Artifact identity (Zulu, musl-native) ----
ARG ZULU_BUILD="zulu17.62.17-ca"
ARG JAVA_VERSION="17.0.17"

ARG ZULU_X64_FILE="${ZULU_BUILD}-jdk${JAVA_VERSION}-linux_musl_x64.tar.gz"
ARG ZULU_ARM64_FILE="${ZULU_BUILD}-jdk${JAVA_VERSION}-linux_musl_aarch64.tar.gz"

# ---- Azul-published SHA256 checksums ----
ARG ZULU_X64_SHA256="d28c7e7b19b97e41de6971c7dc5d8e8c2bc2db577ae89353fd5682b676b2ba1d"
ARG ZULU_ARM64_SHA256="fb58f7585f382ed1ad25634090ba6da17b79f8dc4d850c9904bdf4195316ea64"

# ---- Bring vendored artifacts in ----
COPY files/${ZULU_X64_FILE} /tmp/
COPY files/${ZULU_ARM64_FILE} /tmp/

RUN set -eux; \
    apk add --no-cache \
      ca-certificates \
      tzdata \
      bash \
      coreutils; \
    update-ca-certificates; \
    arch="$(apk --print-arch)"; \
    case "$arch" in \
      x86_64)  file="$ZULU_X64_FILE";  checksum="$ZULU_X64_SHA256" ;; \
      aarch64) file="$ZULU_ARM64_FILE"; checksum="$ZULU_ARM64_SHA256" ;; \
      *) echo >&2 "unsupported architecture: $arch"; exit 1 ;; \
    esac; \
    echo "$checksum  /tmp/$file" | sha256sum -c -; \
    mkdir -p /opt/java; \
    tar -xzf "/tmp/$file" -C /opt/java --strip-components=1; \
    rm -rf /tmp/* /var/cache/apk/*

ENV JAVA_HOME=/opt/java
ENV PATH="$JAVA_HOME/bin:$PATH"

RUN java -version
CMD ["jshell"]