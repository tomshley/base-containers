# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

FROM --platform=$BUILDPLATFORM alpine:3.23

RUN apk update && apk upgrade \
  && apk add ca-certificates \
  && rm -rf /var/cache/apk/*


