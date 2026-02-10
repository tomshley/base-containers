# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

# Use case: Pekko HTTP (Java 21)
# - Temurin JRE-equivalent jlink with stripped native debug symbols
# - optimized JVM defaults for Pekko on JDK 21
# - CDS archive for faster startup
# - no application code
# - intended for direct consumption by Pekko HTTP services

FROM --platform=$BUILDPLATFORM from_image_build_ref-foundation-runtime-java-21-jdk-openjdk-upstream AS jre-pekko

RUN apk add --no-cache binutils && \
    jlink \
    --add-modules java.se,\
jdk.charsets,jdk.crypto.cryptoki,jdk.crypto.ec,jdk.dynalink,\
jdk.httpserver,jdk.jfr,jdk.localedata,\
jdk.management,jdk.management.agent,jdk.management.jfr,\
jdk.naming.dns,jdk.naming.rmi,jdk.net,jdk.nio.mapmode,\
jdk.attach,jdk.sctp,jdk.security.auth,jdk.security.jgss,jdk.unsupported,\
jdk.xml.dom,jdk.zipfs \
    --strip-java-debug-attributes \
    --strip-native-debug-symbols=exclude-debuginfo-files \
    --no-man-pages \
    --no-header-files \
    --compress=zip-9 \
    --output /javaruntime

FROM --platform=$BUILDPLATFORM from_image_build_ref-base-alpine-3_23-upstream

ENV JAVA_HOME=/opt/java/javaruntime
ENV PATH="${JAVA_HOME}/bin:${PATH}"

COPY --from=jre-pekko /javaruntime $JAVA_HOME

RUN apk add --no-cache bash && \
    java -version

# Generate default CDS archive for core JDK classes (matches Temurin behavior)
# Runs before JAVA_OPTS to avoid inheriting framework-specific -D flags
RUN java -Xshare:dump

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

WORKDIR /

ENTRYPOINT ["java"]
