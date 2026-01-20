# Roadmap

This document outlines **intent**, not commitments.

## 0.2.x

This series focuses on **formalizing the container build and CI foundation**
introduced in 0.1.x, with an emphasis on determinism, reproducibility, and
template-driven workflows.

### Scope
- Establish GitLab CI/CD as a first-class consumer of shared Breakground templates.
- Lock base operating system and tooling versions used across all images.
- Validate multi-architecture builds (amd64 / arm64) using vendored artifacts.

### Inclusions
- Alpine base version upgrades and propagation through all dependent images.
- Explicit pinning and vendoring of Docker CLI, DinD, and entry tooling.
- Deterministic container tagging for branch, MR, and release pipelines.
- Minimal CI jobs (`load`, `push`) aligned with Git Flow semantics.

### Non-goals
- Adding test, security, or scanning jobs.
- Expanding the public image catalog.
- Providing backward-compatibility guarantees prior to 1.0.0.

## Short Term
- Finalize Alpine base image contract
- Stabilize runner images for CI/CD
- Harden DIND images
- Improve documentation

## Medium Term
- Additional language runtimes (as needed)
- Improved caching strategies
- CI automation for multi-arch builds

## Long Term
- Versioned releases
- Expanded security posture
- Broader OSS adoption

The roadmap may evolve as requirements and priorities change.
