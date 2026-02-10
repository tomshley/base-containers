# Roadmap

This document outlines **intent**, not commitments.

## Completed

### 0.2.x — Container Build and CI Foundation

- GitLab CI/CD with Breakground template composition
- Alpine 3.23 base version across all images
- Docker toolchain pinned to 29.1.5
- Deterministic container tagging
- Multi-architecture builds (amd64 / arm64)

### 0.3.x — Runtime and Entry Expansion

- Java 21 OpenJDK foundation image
- JRE 21 and Pekko HTTP usecase images
- Docker CLI 29 with Buildx and Compose (vendored)
- Python 3.12 foundation image

### 0.4.x — Rust Toolchain

- Rust 1.83 static-musl vendored entry image (x86_64 + aarch64)

## Short Term

- Finalize Alpine base image contract
- Stabilize entry images for CI/CD
- Harden DinD images
- Improve documentation

## Medium Term

- Additional language runtimes (as needed)
- Improved caching strategies

## Long Term

- Versioned releases with stability guarantees
- Expanded security posture
- Broader OSS adoption

The roadmap may evolve as requirements and priorities change.
