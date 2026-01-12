<p>
  <img src="assets/brand/logo.svg" alt="Tomshley Logo" width="200"/>
</p>

# Tomshley Base Containers

Alpine-first, layered container images for CI/CD pipelines and application runtimes.

This repository is part of the **Tomshley – OSS IP Division** and is maintained by **Tomshley LLC**.
It provides foundational container images consumed by external CI/CD pipeline repositories and application repositories.

---

## Overview

Tomshley Base Containers provides a small, opinionated set of **Alpine-based container images** designed to act as stable foundations for:

- CI/CD pipeline execution environments
- Language and runtime base images
- Application container images (e.g. Akka HTTP services)

The project prioritizes correctness, minimalism, reproducibility, and long-term maintainability.

---

## Features

- Alpine-first images with minimal attack surface
- Clear, intentional image layering
- Buildx + Bake native build system
- Multi-architecture support (amd64, arm64)
- Rootless-first Docker-in-Docker images
- Explicit vendored vs upstream sourcing
- OSS- and enterprise-friendly licensing (Apache 2.0)

---

## Architecture, Naming & Sourcing

The repository is organized around **lifecycle roles** (OS bases, foundational layers, composable runners, and daemons) and a strict **image identity** model.

There are three orthogonal axes:

1. **Role** (base, foundation, runner, daemon)
2. **Identity** (major version, non-default variants like `edge` or `rootless`)
3. **Source model** (`upstream` vs `vendored`)

- **Upstream** images derive their artifacts from external projects or registries at build time.
- **Vendored** images embed and checksum artifacts directly in this repository to ensure reproducibility and supply‑chain stability.

These axes are always explicit and never implicit.

- See **ARCHITECTURE.md** for repository structure and layering rules.
- See **NAMING.md** for image naming, tagging, and variant conventions.

---

## Installation

Example (OS base, stable Alpine, upstream):

```bash
docker pull ghcr.io/tomshley/base-alpine-3_19-upstream:latest
```

Example (OS base, Alpine edge, upstream):

```bash
docker pull ghcr.io/tomshley/base-alpine-edge-upstream:latest
```

> Note: `latest` is **scoped to a single image identity**.  
> It never spans multiple versions, variants, or source models.

---

## Usage

### CI/CD Pipelines (Composable tooling layers)

Runners are **composable tooling layers** designed to be extended or copied from.
They are not required to define ENTRYPOINTs.

Example (tooling layer, upstream):

```dockerfile
FROM ghcr.io/tomshley/runner-sbt-1_9-upstream:latest
```

### Application Images (Akka HTTP)

Example (Java runtime, vendored):

```dockerfile
FROM ghcr.io/tomshley/runtime-java-17-jdk-vendored:latest
COPY target/app.jar /app/app.jar
EXPOSE 8080
CMD ["java", "-jar", "/app/app.jar"]
```

---

## Project Structure

```
base/
foundation/
runner/
daemon/
experimental/
examples/

assets/
  brand/

VERSION
```

- `base/` — OS userlands only (e.g. Alpine 3.19 vs edge as separate identities)
- `foundation/` — non‑OS layers:
  - `foundation/sys/` — low‑level system components (libc, libstdc++, etc.)
  - `foundation/runtime/` — language runtimes (Java, Python, Ruby, etc.)
  - `foundation/accel/` — hardware acceleration (CUDA, ROCm)
- `runner/` — composable tooling layers (sbt, opentofu, terraform)
- `daemon/` — long‑running services (Docker dind, rootless variants)
- `experimental/` — unsupported experiments
- `examples/` — buildable, normative usage patterns

---

## Build System

```bash
docker buildx bake
docker buildx bake --push
```

Bake targets are the authoritative build identities; image tags are aliases of those targets.

---

## Versioning

A top‑level `VERSION` file is the single source of truth for project release metadata.

- **Image identity** is expressed in the image name
- **Build and CI metadata** are expressed in tags

There is no global, cross‑image `latest`.

---

## Contributing

See CONTRIBUTING.md.

---

## Security

See SECURITY.md.

---

## License

Apache License 2.0. See LICENSE and NOTICE.md.

---

## Credits

Maintained by Tomshley LLC.
Tomshley and the Tomshley logo are trademarks of Tomshley LLC.
