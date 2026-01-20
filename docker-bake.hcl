# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

#region Variables (OSS-safe defaults)

variable "BASE_CONTAINERS_REGISTRY" {
  default = "docker.io"
}

variable "BASE_CONTAINERS_NAMESPACE" {
  default = "library"
}

variable "BASE_CONTAINERS_PROJECT" {
  default = "base-containers"
}

variable "BASE_CONTAINERS_TAG" {
  default = "semver"
}

variable "BASE_CONTAINERS_TAG_LATEST" {
  default = "latest"
}

variable "BASE_CONTAINERS_PLATFORMS" {
  default = "linux/amd64,linux/arm64"
}

variable "BASE_CONTAINERS_IMAGE_BASE" {
  default = "${BASE_CONTAINERS_REGISTRY}/${BASE_CONTAINERS_NAMESPACE}/${BASE_CONTAINERS_PROJECT}"
}

#endregion Variables

#region Groups (ORDERED)

group "base" {
  targets = [
    "base-alpine-3_23-upstream",
    "base-alpine-edge-upstream"
  ]
}

group "foundation" {
  targets = [
    "foundation-runtime-java-17-jdk-openjdk-upstream",
    "foundation-runtime-java-17-jdk-zulu-musl-vendored",
    "foundation-runtime-python-3_12-upstream"
  ]
}

group "entry" {
  targets = [
    "entry-opentofu-1_11-vendored",
    "entry-terraform-1_11-upstream",
    "entry-docker-cli-29-vendored",
    "entry-gcloud-479_0_0-vendored"
  ]
}

group "usecase" {
  targets = [
    "usecase-openjdk-jre17",
    "usecase-akka-http-jre17"
  ]
}

group "daemons" {
  targets = [
    "daemon-docker-29-dind-rootless-vendored"
  ]
}

group "experimental" {
  targets = []
}

group "default" {
  targets = [
    "base-alpine-3_23-upstream",
    "base-alpine-edge-upstream",

    "foundation-runtime-java-17-jdk-openjdk-upstream",
    "foundation-runtime-java-17-jdk-zulu-musl-vendored",
    "foundation-runtime-python-3_12-upstream",

    "entry-opentofu-1_11-vendored",
    "entry-terraform-1_11-upstream",
    "entry-docker-cli-29-vendored",
    "entry-gcloud-479_0_0-vendored",

    "usecase-openjdk-jre17",
    "usecase-akka-http-jre17",

    "daemon-docker-29-dind-rootless-vendored"
  ]
}

#endregion Groups

#region Common target settings

target "common" {
  platforms = split(",", BASE_CONTAINERS_PLATFORMS)
}

#endregion Common

#region Base images

target "base-alpine-3_23-upstream" {
  inherits = ["common"]
  context  = "containers/base/alpine/3.23/upstream"

  tags = [
    "${BASE_CONTAINERS_IMAGE_BASE}/base-alpine-3_23-upstream:${BASE_CONTAINERS_TAG}",
    "${BASE_CONTAINERS_IMAGE_BASE}/base-alpine-3_23-upstream:${BASE_CONTAINERS_TAG_LATEST}"
  ]
}

target "base-alpine-edge-upstream" {
  inherits = ["common"]
  context  = "containers/base/alpine/edge/upstream"

  tags = [
    "${BASE_CONTAINERS_IMAGE_BASE}/base-alpine-edge-upstream:${BASE_CONTAINERS_TAG}",
    "${BASE_CONTAINERS_IMAGE_BASE}/base-alpine-edge-upstream:${BASE_CONTAINERS_TAG_LATEST}"
  ]
}

#endregion Base images

#region Foundation images
#region Foundation runtime images
#region Foundation runtime java 17 images

target "foundation-runtime-java-17-jdk-openjdk-upstream" {
  inherits   = ["common"]
  context    = "containers/foundation/runtime/java/17/jdk/openjdk/upstream"
  depends_on = ["base-alpine-3_23-upstream"]

  contexts = {
    from_image_build_ref = "target:base-alpine-3_23-upstream"
  }

  tags = [
    "${BASE_CONTAINERS_IMAGE_BASE}/foundation-runtime-java-17-jdk-openjdk-upstream:${BASE_CONTAINERS_TAG}",
    "${BASE_CONTAINERS_IMAGE_BASE}/foundation-runtime-java-17-jdk-openjdk-upstream:${BASE_CONTAINERS_TAG_LATEST}"
  ]
}

target "foundation-runtime-java-17-jdk-zulu-musl-vendored" {
  inherits   = ["common"]
  context    = "containers/foundation/runtime/java/17/jdk/zulu/musl/vendored"
  depends_on = ["base-alpine-3_23-upstream"]

  contexts = {
    from_image_build_ref = "target:base-alpine-3_23-upstream"
  }

  tags = [
    "${BASE_CONTAINERS_IMAGE_BASE}/foundation-runtime-java-17-jdk-zulu-musl-vendored:${BASE_CONTAINERS_TAG}",
    "${BASE_CONTAINERS_IMAGE_BASE}/foundation-runtime-java-17-jdk-zulu-musl-vendored:${BASE_CONTAINERS_TAG_LATEST}"
  ]
}

#endregion Foundation runtime java 17 images

target "foundation-runtime-python-3_12-upstream" {
  inherits   = ["common"]
  context    = "containers/foundation/runtime/python/3.12/upstream"
  depends_on = ["base-alpine-3_23-upstream"]

  contexts = {
    from_image_build_ref = "target:base-alpine-3_23-upstream"
  }

  tags = [
    "${BASE_CONTAINERS_IMAGE_BASE}/foundation-runtime-python-3_12-upstream:${BASE_CONTAINERS_TAG}",
    "${BASE_CONTAINERS_IMAGE_BASE}/foundation-runtime-python-3_12-upstream:${BASE_CONTAINERS_TAG_LATEST}"
  ]
}

#endregion Foundation runtime images
#endregion Foundation images

#region Entry images

target "entry-docker-cli-29-vendored" {
  inherits   = ["common"]
  context    = "containers/entry/docker-cli/29/vendored"
  depends_on = ["base-alpine-3_23-upstream"]

  contexts = {
    from_image_build_ref = "target:base-alpine-3_23-upstream"
  }

  tags = [
    "${BASE_CONTAINERS_IMAGE_BASE}/entry-docker-cli-29-vendored:${BASE_CONTAINERS_TAG}",
    "${BASE_CONTAINERS_IMAGE_BASE}/entry-docker-cli-29-vendored:${BASE_CONTAINERS_TAG_LATEST}"
  ]
}

target "entry-gcloud-479_0_0-vendored" {
  inherits   = ["common"]
  context    = "containers/entry/gcloud/479.0.0/vendored"
  depends_on = ["base-alpine-3_23-upstream"]

  contexts = {
    from_image_build_ref = "target:base-alpine-3_23-upstream"
  }

  tags = [
    "${BASE_CONTAINERS_IMAGE_BASE}/entry-gcloud-479_0_0-vendored:${BASE_CONTAINERS_TAG}",
    "${BASE_CONTAINERS_IMAGE_BASE}/entry-gcloud-479_0_0-vendored:${BASE_CONTAINERS_TAG_LATEST}"
  ]
}

target "entry-opentofu-1_11-vendored" {
  inherits   = ["common"]
  context    = "containers/entry/opentofu/1.11/vendored"
  depends_on = ["base-alpine-3_23-upstream"]

  contexts = {
    from_image_build_ref = "target:base-alpine-3_23-upstream"
  }

  tags = [
    "${BASE_CONTAINERS_IMAGE_BASE}/entry-opentofu-1_11-vendored:${BASE_CONTAINERS_TAG}",
    "${BASE_CONTAINERS_IMAGE_BASE}/entry-opentofu-1_11-vendored:${BASE_CONTAINERS_TAG_LATEST}"
  ]
}

target "entry-terraform-1_11-upstream" {
  inherits   = ["common"]
  context    = "containers/entry/terraform/1.11/vendored"
  depends_on = ["base-alpine-3_23-upstream"]

  contexts = {
    from_image_build_ref = "target:base-alpine-3_23-upstream"
  }

  tags = [
    "${BASE_CONTAINERS_IMAGE_BASE}/entry-terraform-1_11-upstream:${BASE_CONTAINERS_TAG}",
    "${BASE_CONTAINERS_IMAGE_BASE}/entry-terraform-1_11-upstream:${BASE_CONTAINERS_TAG_LATEST}"
  ]
}

#endregion Entry images

#region Usecase images

target "usecase-openjdk-jre17" {
  inherits   = ["common"]
  context    = "containers/usecase/openjdk-jre17"
  depends_on = [
    "base-alpine-3_23-upstream",
    "foundation-runtime-java-17-jdk-openjdk-upstream"
  ]

  contexts = {
    from_image_build_ref-base-alpine-3_23-upstream = "target:base-alpine-3_23-upstream"
    from_image_build_ref-foundation-runtime-java-17-jdk-openjdk-upstream = "target:foundation-runtime-java-17-jdk-openjdk-upstream"
  }

  tags = [
    "${BASE_CONTAINERS_IMAGE_BASE}/usecase-openjdk-jre17:${BASE_CONTAINERS_TAG}",
    "${BASE_CONTAINERS_IMAGE_BASE}/usecase-openjdk-jre17:${BASE_CONTAINERS_TAG_LATEST}"
  ]
}

target "usecase-akka-http-jre17" {
  inherits   = ["common"]
  context    = "containers/usecase/akka-http-jre17"
  depends_on = ["foundation-runtime-java-17-jdk-openjdk-upstream"]

  contexts = {
    from_image_build_ref = "target:foundation-runtime-java-17-jdk-openjdk-upstream"
  }

  tags = [
    "${BASE_CONTAINERS_IMAGE_BASE}/usecase-akka-http-jre17:${BASE_CONTAINERS_TAG}",
    "${BASE_CONTAINERS_IMAGE_BASE}/usecase-akka-http-jre17:${BASE_CONTAINERS_TAG_LATEST}"
  ]
}

#endregion Usecase images

#region Daemon images

target "daemon-docker-29-dind-rootless-vendored" {
  inherits   = ["common"]
  context    = "containers/daemon/docker/29/dind-rootless/vendored"
  depends_on = ["base-alpine-3_23-upstream"]

  contexts = {
    from_image_build_ref = "target:base-alpine-3_23-upstream"
  }

  tags = [
    "${BASE_CONTAINERS_IMAGE_BASE}/daemon-docker-29-dind-rootless-vendored:${BASE_CONTAINERS_TAG}",
    "${BASE_CONTAINERS_IMAGE_BASE}/daemon-docker-29-dind-rootless-vendored:${BASE_CONTAINERS_TAG_LATEST}"
  ]
}

#endregion Daemon images

#region Experimental (reserved)

# Intentionally empty.
# Future policy or experimental targets may live here.

#endregion Experimental
