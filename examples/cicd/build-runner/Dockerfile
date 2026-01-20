# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

# ---- Docker CLI (vendored) ----
FROM entry-docker-cli-29-vendored AS docker

# ---- Buildx plugin (vendored via docker image) ----
FROM docker/buildx-bin:0.13.1 AS buildx

# ---- Final runner image ----
FROM base-alpine-3_23-upstream

# Docker CLI
COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker

# Buildx plugin
COPY --from=buildx /buildx /usr/libexec/docker/cli-plugins/docker-buildx

# Required runtime deps
RUN apk add --no-cache \
      ca-certificates \
      git \
      bash

ENV DOCKER_BUILDKIT=1
ENV DOCKER_CONFIG=/root/.docker

ENTRYPOINT ["docker"]
