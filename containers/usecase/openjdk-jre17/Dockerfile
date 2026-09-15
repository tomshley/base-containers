# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

# Use case: Vendored OpenJDK 17 JRE
# - built via jlink from a foundation JDK
# - generic, framework-agnostic
# - intended for direct consumption by applications

FROM --platform=$TARGETPLATFORM from_image_build_ref-foundation-runtime-java-17-jdk-openjdk-upstream AS jre-headless

RUN jlink \
    --add-modules ALL-MODULE-PATH \
    --strip-java-debug-attributes \
    --no-man-pages \
    --no-header-files \
    --compress=2 \
    --output /javaruntime

FROM --platform=$TARGETPLATFORM from_image_build_ref-base-alpine-3_23-upstream

ENV JAVA_HOME=/opt/java/javaruntime
ENV PATH="${JAVA_HOME}/bin:${PATH}"

COPY --from=jre-headless /javaruntime $JAVA_HOME

RUN apk add --no-cache bash && \
    java -version

WORKDIR /

# Neutral ENTRYPOINT: application supplies arguments
ENTRYPOINT ["java"]
