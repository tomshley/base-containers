#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2024–2026 Tomshley LLC

set -e

# Default to allure if no command specified
if [ $# -eq 0 ]; then
    set -- allure
fi

# Execute the command
exec "$@"
