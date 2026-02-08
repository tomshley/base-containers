# Changelog

All notable changes to this project are documented in this file.

This project follows Semantic Versioning.

---

## v0.3.0

### Added
- Java 21 OpenJDK foundation image (`foundation/runtime/java/21/jdk/openjdk/upstream`).
- JRE 21 usecase image (`usecase/openjdk-jre21`).
- Pekko HTTP JRE 21 usecase image (`usecase/pekko-http-jre21`).
- Docker CLI 29 buildx-vendored entry image with Buildx v0.30.1 and Compose v5.0.1.
- Corresponding bake targets for all new images.

### Changed
- `.gitattributes` updated for LFS tracking of vendored binary artifacts.
- `.gitignore` streamlined and reorganized.
- Existing JRE 17 usecase Dockerfile aligned with new layering conventions.

---

## v0.2.0

### Added
- GitLab CI/CD pipeline definition with Breakground template composition.
- Shared CI template for deterministic container tag resolution (tag vs branch/MR semantics).
- Idempotent Buildx builder creation target (`make createbuildx`).

### Changed
- Alpine base image updated from 3.19 to 3.23 across bake targets, base images, and examples.
- Docker toolchain pinned to 29.1.5 (Docker CLI vendored + DinD/rootless daemon).
- Registry authentication behavior: CI-provided credentials are authoritative; local defaults are optional.
- `make push` no longer enforces a registry login pre-check (CI handles auth; local use remains flexible).

### Fixed
- OpenTofu ARM64 artifact naming and checksum alignment (`*_arm64.apk`).
- Documentation updated to describe CI/CD structure and secret `.env` handling without release “highlights”.

---

## v0.1.0

### Added
- Initial base-containers repository foundation
- Alpine-first layered image architecture
- Base, runner, language, and DIND image taxonomy
- Production vs experimental DIND separation
- Buildx + docker-bake.hcl as the authoritative build system
- VERSION-based image tagging contract
- Thin Makefile wrapper for local development
- SPDX headers and Apache-2.0 licensing
- NOTICE, LICENSE, and OSS documentation
- Brand and metadata placeholders
