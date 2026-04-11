# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

# Use case: Python Uvicorn (Python 3.12)
#
# Runtime image — build-time tooling (system pip, setuptools) is excluded.
# The venv retains its own pip so downstream images can install app dependencies.
#
# - Multi-stage: foundation Python builds the venv, base-alpine provides the runtime
# - isolated /opt/venv with uvicorn pre-installed
# - non-root user for production workloads
# - no application code
# - intended for direct consumption by FastAPI / Starlette / ASGI services

# --- Stage 1: build venv on foundation image (has system pip) ---
FROM --platform=$BUILDPLATFORM from_image_build_ref-foundation-runtime-python-3_12-upstream AS builder

RUN python -m venv /opt/venv \
 && /opt/venv/bin/pip install --no-cache-dir "uvicorn[standard]==0.44.0" \
 && /opt/venv/bin/uvicorn --version

# --- Stage 2: runtime (python3 only, no system pip/setuptools) ---
FROM --platform=$BUILDPLATFORM from_image_build_ref-base-alpine-3_23-upstream

RUN apk add --no-cache python3 \
 && ln -sf /usr/bin/python3 /usr/local/bin/python

COPY --from=builder /opt/venv /opt/venv

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:${PATH}"

RUN addgroup -g 1001 -S appuser \
 && adduser -u 1001 -S appuser -G appuser -h /app -s /sbin/nologin \
 && chown -R appuser:appuser /opt/venv

WORKDIR /app

USER appuser

ENTRYPOINT ["uvicorn"]
