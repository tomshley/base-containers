# Changelog

All notable changes to this project are documented in this file.

This project follows Semantic Versioning.

---

## v0.5.0

### Added
- Python Uvicorn usecase image (`usecase/python-uvicorn`) for Python 3.12 ASGI services.
- Built on `foundation-runtime-python-3_12-upstream` (Alpine system Python).
- Isolated `/opt/venv` with `uvicorn[standard]` pre-installed.
- Non-root `appuser` (UID 1001) for production workloads.
- Corresponding bake target (`usecase-python-uvicorn`) wired into usecase and default groups.

### Changed
- Removed IDE-specific credential ignores and Snyk AI rules from `.gitignore`.

---

## v0.4.2

### Added
- Allure 2.30.0 CLI entry image (`entry/allure/2.30.0/vendored`) for amd64 and arm64.
- Vendored tarball tracked via Git LFS with SHA256 verification at build time.
- No JRE bundled — consuming runner must provide Java 17+ (JDK 21 recommended).
- Corresponding bake target (`entry-allure-2_30_0-vendored`) wired into entry and default groups.

---

## v0.4.1

### Fixed
- `entry/rust/1.83/vendored`: Added missing `bash` dependency required by Rust's `install.sh` installer script.

---

## v0.4.0

### Added
- Rust 1.83.0 static-musl toolchain entry image (`entry/rust/1.83/vendored`) for x86_64 and aarch64.
- Vendored tarballs tracked via Git LFS for air-gap readiness.
- SHA256 checksum verification at build time.
- Corresponding bake target (`entry-rust-1_83-vendored`) wired into entry and default groups.

---

## v0.3.5

### Changed
- `usecase/pekko-http-jre21`: Rewritten as self-contained multi-stage build with Temurin JRE-equivalent jlink (`java.se` + curated `jdk.*` modules), `--strip-native-debug-symbols`, and default CDS archive generation. No longer layers on `usecase/openjdk-jre21`.
- `docker-bake.hcl`: `usecase-pekko-http-jre21` target now depends on `foundation-runtime-java-21-jdk-openjdk-upstream` and `base-alpine-3_23-upstream` directly.
- `README.md`: Removed all Akka HTTP references.

### Removed
- `usecase/akka-http-jre17`: Image and bake target removed. No downstream consumers remain.

### Fixed
- Estimated ~40–60 MiB compressed image size reduction for Pekko HTTP services (~185 MiB → ~115–130 MiB).

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
