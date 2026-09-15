#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC
#
# Pass-through entrypoint for CI job images.
# Allows the image to be used as a GitLab/Bitbucket CI job image
# (runner needs to exec arbitrary shell commands) while still
# supporting standalone: docker run <image> <tool> <args>
set -e
exec "$@"
