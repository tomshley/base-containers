# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

# NOTE:
# SBT is vendored to eliminate build-time network dependencies.
# SBT is architecture-independent (JVM launcher), so only one
# artifact is needed regardless of platform.
# This image tracks SBT v1.12.x exactly.

FROM --platform=$BUILDPLATFORM from_image_build_ref

ENV LANG=C.UTF-8

# ---- Artifact identity (SBT, upstream GitHub release) ----
ARG SBT_VERSION="1.12.2"
ARG SBT_FILE="sbt-${SBT_VERSION}.tgz"

# ---- Upstream-published SHA256 checksum ----
# Recorded at vendoring time
ARG SBT_SHA256="97bb77df50ac33e3f8c87d1415c1d66bb58586f6fe032b7808fd783f949531f0"

ARG BINARIES_PREFIX="/opt"

# ---- Bring vendored artifact in ----
COPY files/${SBT_FILE} /tmp/

RUN set -eux; \
    apk add --no-cache \
      ca-certificates \
      coreutils; \
    echo "${SBT_SHA256}  /tmp/${SBT_FILE}" | sha256sum -c -; \
    mkdir -p ${BINARIES_PREFIX}/sbt; \
    tar xzf "/tmp/${SBT_FILE}" -C ${BINARIES_PREFIX}/sbt --strip-components=1; \
    rm -rf /tmp/* /var/cache/apk/*

ENV SBT_HOME=${BINARIES_PREFIX}/sbt
ENV PATH="${SBT_HOME}/bin:${PATH}"

COPY --chmod=755 files/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["sh"]
