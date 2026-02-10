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
- Application container images (e.g. Pekko HTTP services)

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

The repository is organized around **lifecycle roles** and a strict **image identity** model.

There are three orthogonal axes:

1. **Role** (base, foundation, entry, usecase, daemon)
2. **Identity** (major version, non-default variants like `edge` or `rootless`)
3. **Source model** (`upstream` vs `vendored`)

- **Upstream** images derive their artifacts from external projects or registries at build time.
- **Vendored** images embed and checksum artifacts directly in this repository to ensure reproducibility and supply-chain stability.

These axes are always explicit and never implicit.

---

## Registry Access

Container images are published to a **private GitLab Container Registry**.

### For CI/CD Consumers (GitLab Job Tokens)

Downstream GitLab projects that need to pull these images in CI pipelines must be added to the **CI/CD job token allowlist** for this project. This is configured under:

> **Settings → CI/CD → Job token permissions → CI/CD job token allowlist**

Only projects explicitly allowlisted can authenticate using `$CI_JOB_TOKEN` to pull images.

### For Direct Access

Direct access to container images (outside of allowlisted CI pipelines) is **not publicly available**.

To request access, contact **Tomshley LLC**:

- **Website:** [tomshley.com](https://tomshley.com)
- **Email:** oss@tomshley.com

Tomshley LLC reserves the right to grant or deny access at its discretion.

---

## Installation

Images are not available on public registries. After obtaining access, pull images using your configured registry coordinates.

Example (OS base, stable Alpine, upstream):

```bash
docker pull $REGISTRY/$NAMESPACE/base-containers/base-alpine-3_23-upstream:latest
```

Example (OS base, Alpine edge, upstream):

```bash
docker pull $REGISTRY/$NAMESPACE/base-containers/base-alpine-edge-upstream:latest
```

> Note: `latest` is **scoped to a single image identity**.
> It never spans multiple versions, variants, or source models.

---

## Usage

### CI/CD Pipelines (Entry tooling layers)

Entry images are **composable tooling layers** designed to be extended or copied from.
They are not required to define ENTRYPOINTs.

Example (OpenTofu, vendored):

```dockerfile
FROM entry-opentofu-1_11-vendored AS tofu
```

Example (Docker CLI with Buildx, vendored):

```dockerfile
FROM entry-docker-cli-buildx-29-vendored AS docker
```

### Application Images (Pekko HTTP)

Example (Pekko HTTP on JRE 21, usecase):

```dockerfile
FROM usecase-pekko-http-jre21:latest
COPY target/app.jar /app/app.jar
EXPOSE 8080
CMD ["java", "-jar", "/app/app.jar"]
```

---

## Project Structure

```
containers/
  base/           — OS userlands (Alpine 3.23, edge)
  foundation/     — non-OS layers
    runtime/      — language runtimes (Java 17, Java 21, Python 3.12)
  entry/          — composable tooling (Docker CLI, OpenTofu, Terraform, gcloud)
  usecase/        — application-ready images (JRE 17, JRE 21, Pekko HTTP)
  daemon/         — long-running services (Docker DinD rootless)
  experimental/   — unsupported experiments

examples/
  cicd/           — buildable, normative usage patterns

ci/
  gitlab/         — shared CI templates

assets/
  brand/

VERSION
```

---

## Build System

```bash
docker buildx bake
docker buildx bake --push
```

Bake targets are the authoritative build identities; image tags are aliases of those targets.

See `docker-bake.hcl` for the complete list of targets and groups.

---

## Internal CI/CD Templates

This project provides reusable GitLab CI templates intended to be consumed by downstream projects.

Key behaviors:

- **Merge Requests**
  - Image push jobs are automatically skipped to avoid blocking MR pipelines.
- **Credentials**
  - CI-provided registry credentials are preferred by default.
  - Local or developer credentials are only used outside CI.
- **Tagging**
  - Images are tagged immutably using commit-derived identifiers.
  - Feature and non-release refs do not publish registry aliases.
- **Manual Jobs**
  - Manual container-push steps exist only for release flows and are not required for validation pipelines.

These behaviors are intentional and designed to minimize friction while preserving release safety.

---

## Versioning

A top-level `VERSION` file is the single source of truth for project release metadata.

- **Image identity** is expressed in the image name
- **Build and CI metadata** are expressed in tags

There is no global, cross-image `latest`.

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

---

## CI/CD (GitLab)

This repository uses a **minimal, intentional GitLab CI/CD setup** designed to
support reproducible container builds while validating shared CI abstractions
from the *Breakground* project.

### Design Goals

- Keep CI logic **boring and explicit**
- Avoid CI-only artifacts or hidden build steps
- Treat the container registry as the artifact boundary
- Reuse generic Git Flow and stage definitions without coupling build logic

### CI Structure

The pipeline composes four generic templates provided by Breakground:

- **`.stages-base.yml`**
  - Defines the global stage layout (`build`, `deploy`, etc.)
  - Does not define jobs or tools

- **`.gitflow-base.yml`**
  - Derives Git Flow context (feature, release, hotfix, tag)
  - Computes an immutable build revision
  - Provides manual flow hooks

- **`.container-tags.yml`**
  - Resolves deterministic container tags for branch, MR, and release pipelines

- **`.artifact-publish-policy.yml`**
  - Controls when artifact publishing jobs are enabled (tag-gated, manual)

This repository then supplies **only the container-specific implementation**.

### Active Jobs

Currently, two jobs are defined:

- **load** (`build` stage)
  - Runs `make build-load`
  - Builds and loads supported images locally
  - Does not publish artifacts

- **publish-containers** (`deploy` stage, tag-gated via `.flow-artifact-publish`)
  - Runs `make push`
  - Publishes supported and experimental images to the registry

Additional stages (validate, test, security, etc.) are intentionally present but unused.

### Runtime Environment

- **Job image:** `docker:29.1.5-alpine3.23`
- **DinD service:** `docker:29.1.5-dind-alpine3.23`
- **Runner:** `saas-linux-xlarge-amd64`

> Note: Docker does not publish `*-dind-alpine` tags.
> The DinD image is already Alpine-based and must use `*-dind`.

### Secrets Handling

A GitLab **secure file** named `.env` may be provided.

- GitLab exposes the file as a temporary path via the `ENV` variable
- CI copies it to `.secure-files/.env`
- The Makefile conditionally loads and exports it if present

This keeps secret handling:
- out of CI logic
- consistent with local builds
- compatible with air-gapped environments

### Intentional Omissions

The following are **explicitly deferred** and may be added later without
changing the CI structure:

- Test jobs
- Security scanning
- Performance or e2e testing
- Custom runner images

---
