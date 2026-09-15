# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

FROM --platform=$TARGETPLATFORM from_image_build_ref

ENV LANG=C.UTF-8 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

RUN apk add --no-cache \
      python3 \
      py3-pip \
 && ln -sf /usr/bin/python3 /usr/local/bin/python \
 && python --version

ENTRYPOINT ["python"]
