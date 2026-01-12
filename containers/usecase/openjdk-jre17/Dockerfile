# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

# Use case: Vednored OpenJDK 17 JRE
# - built via jlink from a foundation JDK
# - generic, framework-agnostic
# - intended for direct consumption by applications

FROM --platform=$BUILDPLATFORM from_image_build_ref-foundation-runtime-java-17-jdk-openjdk-upstream AS jre-headless

RUN jlink \
    --add-modules ALL-MODULE-PATH \
    --strip-java-debug-attributes \
    --no-man-pages \
    --no-header-files \
    --compress=2 \
    --output /javaruntime

FROM --platform=$BUILDPLATFORM from_image_build_ref-base-alpine-3_19-upstream

ENV JAVA_HOME=/opt/java/javaruntime
ENV PATH="${JAVA_HOME}/bin:${PATH}"

COPY --from=jre-headless /javaruntime $JAVA_HOME

RUN apk add --no-cache bash && \
    java -version && \
    rm -rf /var/cache/apk/*

WORKDIR /

# Neutral ENTRYPOINT: application supplies arguments
ENTRYPOINT ["java"]
