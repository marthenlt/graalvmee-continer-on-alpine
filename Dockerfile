FROM alpine:latest

MAINTAINER Marthen Luther <marthen.luther@oracle.com>

ENV JAVA_VERSION=graalvm-ee-java8-20.3.2 \
    JAVA_HOME=/opt/java/graalvm-ee-java8-20.3.2\
    GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc \
    GLIBC_VERSION=2.29-r0 \
    LANG=C.UTF-8

COPY graalvm-ee-java8-linux-amd64-20.3.2.tar.gz .

RUN apk -U upgrade \
    && apk add libstdc++ bash curl \
    && for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION} glibc-i18n-${GLIBC_VERSION}; do curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done \
    && apk add --allow-untrusted /tmp/*.apk \
    && rm -v /tmp/*.apk \
#    && ( /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true ) \
    && echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh  \
    && /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib \
    && tar -zxf graalvm-ee-java8-linux-amd64-20.3.2.tar.gz \
    && rm -f graalvm-ee-java8-linux-amd64-20.3.2.tar.gz \
    && mkdir -p /opt/java \
    && rm -rf ${JAVA_VERSION}/*src.zip \
              ${JAVA_VERSION}/jre/plugin \
              ${JAVA_VERSION}/jre/bin/javaws \
              ${JAVA_VERSION}/jre/bin/orbd \
              ${JAVA_VERSION}/jre/bin/pack200 \
              ${JAVA_VERSION}/jre/bin/policytool \
              ${JAVA_VERSION}/jre/bin/rmid \
              ${JAVA_VERSION}/jre/bin/rmiregistry \
              ${JAVA_VERSION}/jre/bin/servertool \
              ${JAVA_VERSION}/jre/bin/tnameserv \
              ${JAVA_VERSION}/jre/bin/unpack200 \
              ${JAVA_VERSION}/jre/lib/javaws.jar \
              ${JAVA_VERSION}/jre/lib/deploy* \
              ${JAVA_VERSION}/jre/lib/desktop \
              ${JAVA_VERSION}/jre/lib/*javafx* \
              ${JAVA_VERSION}/jre/lib/*jfx* \
              ${JAVA_VERSION}/jre/lib/amd64/libdecora_sse.so \
              ${JAVA_VERSION}/jre/lib/amd64/libprism_*.so \
              ${JAVA_VERSION}/jre/lib/amd64/libfxplugins.so \
              ${JAVA_VERSION}/jre/lib/amd64/libglass.so \
              ${JAVA_VERSION}/jre/lib/amd64/libgstreamer-lite.so \
              ${JAVA_VERSION}/jre/lib/amd64/libjavafx*.so \
              ${JAVA_VERSION}/jre/lib/amd64/libjfx*.so \
              ${JAVA_VERSION}/jre/lib/ext/jfxrt.jar \
              ${JAVA_VERSION}/jre/lib/oblique-fonts \
              ${JAVA_VERSION}/jre/lib/plugin.jar \
              /tmp/* /var/cache/apk/* \
    && mv ${JAVA_VERSION} /opt/java/.

ENV PATH=${PATH}:${JAVA_HOME}/bin
