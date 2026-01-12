# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

# Use case: Akka HTTP (Java 17)
# - optimized JVM defaults
# - no application code
# - intended for direct consumption by Akka HTTP services

FROM --platform=$BUILDPLATFORM from_image_build_ref

# Akka HTTP–appropriate JVM defaults
# These are policy decisions, not capabilities
ENV JAVA_OPTS_DEFAULT="\
  -XX:+UseG1GC \
  -XX:MaxGCPauseMillis=200 \
  -XX:MaxRAMPercentage=75 \
  -XX:+ExitOnOutOfMemoryError \
  -Dakka.actor.default-dispatcher.fork-join-executor.parallelism-factor=2.0 \
  -Dakka.actor.default-dispatcher.fork-join-executor.parallelism-max=64 \
  -Dakka.http.server.request-timeout=30s \
"

# Allow downstream override/extension
ENV JAVA_OPTS="${JAVA_OPTS_DEFAULT}"

ENTRYPOINT ["java"]
