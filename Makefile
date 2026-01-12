#
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC
#

.DEFAULT_GOAL := help

#region Secure environment overrides
# ------------------------------------------------------------------------------
# Optional secure environment overrides
# ------------------------------------------------------------------------------

ifneq ("$(wildcard .secure-files/.env)","")
  $(info Loading .secure-files/.env)
  include .secure-files/.env
  export
endif
#endregion Secure environment overrides

#region Docker / BuildKit defaults
# ------------------------------------------------------------------------------
# Docker / BuildKit defaults
# ------------------------------------------------------------------------------

export DOCKER_BUILDKIT ?= 1
export DOCKER_CLI_EXPERIMENTAL ?= enabled
export BUILDKIT_PROGRESS ?= plain
#endregion Docker / BuildKit defaults

#region Versioning
# ------------------------------------------------------------------------------
# VERSION-derived defaults (CI can override)
# ------------------------------------------------------------------------------

VERSION_FILE ?= VERSION
VERSION := $(shell cat $(VERSION_FILE) 2>/dev/null || echo dev)
#endregion Versioning

#region Registry coordinates
export BASE_CONTAINERS_REGISTRY   ?= docker.io
export BASE_CONTAINERS_NAMESPACE  ?= library
export BASE_CONTAINERS_PROJECT    ?= base-containers
#endregion Registry coordinates

#region Tagging
# Multi-arch defaults (Bake consumes this)
export BASE_CONTAINERS_PLATFORMS  ?= linux/amd64,linux/arm64

# Primary tag defaults to VERSION (or dev)
export BASE_CONTAINERS_TAG        ?= $(VERSION)

# Composable tag and "latest" tag
ifeq ($(origin BASE_CONTAINERS_TAG_LATEST), undefined)
  ifeq ($(BASE_CONTAINERS_TAG),$(VERSION))
    export BASE_CONTAINERS_TAG_LATEST = latest
  else
    export BASE_CONTAINERS_TAG_LATEST = latest-$(BASE_CONTAINERS_TAG)
  endif
endif
#endregion Tagging

#region Local platform detection
# ------------------------------------------------------------------------------
# Local single-arch helper (needed for --load)
# ------------------------------------------------------------------------------

UNAME_M := $(shell uname -m)

ifeq ($(UNAME_M),x86_64)
  LOCAL_PLATFORM ?= linux/amd64
else ifeq ($(UNAME_M),aarch64)
  LOCAL_PLATFORM ?= linux/arm64
else ifeq ($(UNAME_M),arm64)
  LOCAL_PLATFORM ?= linux/arm64
else ifneq (,$(findstring armv7,$(UNAME_M)))
  LOCAL_PLATFORM ?= linux/arm/v7
else ifneq (,$(findstring armv6,$(UNAME_M)))
  LOCAL_PLATFORM ?= linux/arm/v6
else
  LOCAL_PLATFORM ?= linux/amd64
endif

#endregion Local platform detection

#region Help
# ------------------------------------------------------------------------------
# Help
# ------------------------------------------------------------------------------

.PHONY: help
help:
	@echo "Tomshley Base Containers"
	@echo
	@echo "Targets:"
	@echo "  make build              Build supported images (multi-arch)"
	@echo "  make push               Build+push supported images (multi-arch)"
	@echo "  make build-experimental Build experimental images"
	@echo "  make build-local         Build supported images for LOCAL_PLATFORM=$(LOCAL_PLATFORM)"
	@echo "  make build-load          Build+load supported images for LOCAL_PLATFORM=$(LOCAL_PLATFORM)"
	@echo
	@echo "Resolved variables:"
	@echo "  BASE_CONTAINERS_REGISTRY=$(BASE_CONTAINERS_REGISTRY)"
	@echo "  BASE_CONTAINERS_NAMESPACE=$(BASE_CONTAINERS_NAMESPACE)"
	@echo "  BASE_CONTAINERS_PROJECT=$(BASE_CONTAINERS_PROJECT)"
	@echo "  BASE_CONTAINERS_TAG=$(BASE_CONTAINERS_TAG)"
	@echo "  BASE_CONTAINERS_TAG_LATEST=$(BASE_CONTAINERS_TAG_LATEST)"
	@echo "  BASE_CONTAINERS_PLATFORMS=$(BASE_CONTAINERS_PLATFORMS)"
#endregion Help

#region Checks
# ------------------------------------------------------------------------------
# Checks
# ------------------------------------------------------------------------------

.PHONY: check
check:
	@command -v docker >/dev/null || { echo "docker not found"; exit 1; }
	@docker buildx version >/dev/null || { echo "docker buildx not available"; exit 1; }

.PHONY: login-check
login-check:
	@echo "Checking registry login for $(BASE_CONTAINERS_REGISTRY)…"
	@docker buildx imagetools inspect \
		$(BASE_CONTAINERS_REGISTRY)/$(BASE_CONTAINERS_NAMESPACE)/$(BASE_CONTAINERS_PROJECT):login-check \
		>/dev/null 2>&1 || { \
		echo "❌ Not logged in or insufficient permissions for $(BASE_CONTAINERS_REGISTRY)"; \
		echo "   Run: docker login $(BASE_CONTAINERS_REGISTRY)"; \
		exit 1; }
	@echo "✅ Registry login OK"
#endregion Checks

#region Build targets
# ------------------------------------------------------------------------------
# Build targets
# ------------------------------------------------------------------------------

.PHONY: build
build: check
	docker buildx bake default

.PHONY: push
push: check login-check
	docker buildx bake default --push

.PHONY: build-experimental
build-experimental: check
	docker buildx bake experimental

.PHONY: build-local
build-local: check
	docker buildx bake default --set '*.platform=$(LOCAL_PLATFORM)'

.PHONY: build-load
build-load: check
	docker buildx bake default --set '*.platform=$(LOCAL_PLATFORM)' --load
#endregion Build targets
