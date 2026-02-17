# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2024–2026 Tomshley LLC
#
# Allure Command-line tool entry container
# NOTE: This container does NOT bundle a JRE. The consuming runner must provide Java.
# Allure 2.30.0 requires Java 17+ (JDK 21 recommended).

FROM --platform=$BUILDPLATFORM from_image_build_ref

ENV LANG=C.UTF-8

# ---- Artifact identity (Allure, upstream tarball) ----
ARG ALLURE_VERSION="2.30.0"

ARG ALLURE_FILE="allure-${ALLURE_VERSION}.tgz"
ARG ALLURE_SHA256="8d87629caee2b76303c2b5999b13c747962a661855228daf3190c25f7f3e8a05"

ARG BINARIES_PREFIX="/opt"

# ---- Bring vendored artifacts in ----
COPY files/${ALLURE_FILE} /tmp/

RUN set -eux; \
    apk add --no-cache \
      ca-certificates \
      coreutils; \
    echo "${ALLURE_SHA256}  /tmp/${ALLURE_FILE}" | sha256sum -c -; \
    mkdir -p ${BINARIES_PREFIX}/allure; \
    tar xzf "/tmp/${ALLURE_FILE}" -C ${BINARIES_PREFIX}/allure --strip-components=1; \
    rm -rf /tmp/* /var/cache/apk/*

ENV PATH="${BINARIES_PREFIX}/allure/bin:${PATH}"

COPY --chmod=755 files/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["allure"]
