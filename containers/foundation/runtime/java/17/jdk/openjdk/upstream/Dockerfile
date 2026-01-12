# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2017–present Tomshley LLC

FROM --platform=$BUILDPLATFORM from_image_build_ref

ENV LANG=C.UTF-8

# OpenJDK 17 from Alpine community (native, upstream)
# apk add --no-cache guarantees no /var/cache/apk is created
RUN apk add --no-cache openjdk17-jdk \
 && { [ ! -d /var/cache/apk ] || [ -z "$(ls -A /var/cache/apk)" ]; }

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH="$JAVA_HOME/bin:$PATH"

RUN java -version
CMD ["jshell"]