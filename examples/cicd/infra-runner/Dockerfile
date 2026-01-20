# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

# ---- OpenTofu ----
FROM entry-opentofu-1_11-vendored AS tofu

# ---- Terraform ----
FROM entry-terraform-1_11-upstream AS terraform

# ---- Google Cloud SDK ----
FROM entry-gcloud-479_0_0-vendored AS gcloud

# ---- Final runner ----
FROM base-alpine-3_23-upstream

# OpenTofu
COPY --from=tofu /usr/local/bin/tofu /usr/local/bin/tofu

# Terraform
COPY --from=terraform /usr/local/bin/terraform /usr/local/bin/terraform

# Google Cloud SDK
COPY --from=gcloud /opt/google-cloud-sdk /opt/google-cloud-sdk

# Runtime deps
RUN apk add --no-cache \
      ca-certificates \
      bash \
      git \
      openssh

ENV PATH="/opt/google-cloud-sdk/bin:${PATH}"
ENV CLOUDSDK_CORE_DISABLE_PROMPTS=1

ENTRYPOINT ["tofu"]