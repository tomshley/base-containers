# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

# Use case: Pekko HTTP (Java 21)
# - optimized JVM defaults for Pekko on JDK 21
# - no application code
# - intended for direct consumption by Pekko HTTP services

FROM --platform=$BUILDPLATFORM from_image_build_ref

# Pekko HTTP–appropriate JVM defaults
# - G1GC: balanced latency/throughput (Pekko docs don't mandate a specific GC)
# - MaxGCPauseMillis=200: target max pause for G1GC
# - MaxRAMPercentage=75: leaves room for metaspace, code cache, NIO buffers
# - ExitOnOutOfMemoryError: matches pekko.jvm-exit-on-fatal-error=on
# - parallelism-factor=1.0: Pekko default (1 thread per core)
# - parallelism-max=64: Pekko default cap
# - request-timeout=30s: conservative override of Pekko's 20s default
ENV JAVA_OPTS_DEFAULT="\
  -XX:+UseG1GC \
  -XX:MaxGCPauseMillis=200 \
  -XX:MaxRAMPercentage=75 \
  -XX:+ExitOnOutOfMemoryError \
  -Dpekko.actor.default-dispatcher.fork-join-executor.parallelism-factor=1.0 \
  -Dpekko.actor.default-dispatcher.fork-join-executor.parallelism-max=64 \
  -Dpekko.http.server.request-timeout=30s \
"

# Allow downstream override/extension
ENV JAVA_OPTS="${JAVA_OPTS_DEFAULT}"

ENTRYPOINT ["java"]
