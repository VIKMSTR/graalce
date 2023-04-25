
FROM alpine:latest as downloader
ARG TARGETOS
ARG TARGETARCH
#22.3.1
ARG GRAAL_VERSION
#17
ARG JAVA_VERSION 
RUN mkdir /build 
WORKDIR /build
RUN if [ "${TARGETARCH}" = "arm64" ];then wget -cO - https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAAL_VERSION}/graalvm-ce-java${JAVA_VERSION}-${TARGETOS}-aarch64-${GRAAL_VERSION}.tar.gz > graalvm.tar.gz ;else wget -cO - https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAAL_VERSION}/graalvm-ce-java${JAVA_VERSION}-${TARGETOS}-${TARGETARCH}-${GRAAL_VERSION}.tar.gz > graalvm.tar.gz;fi
RUN mkdir graalvm && tar xvf ./graalvm.tar.gz -C ./graalvm --strip-components 1 && rm ./graalvm.tar.gz

FROM ubuntu:lunar as prod
ARG TARGET_OS
ARG TARGET_ARCH
#22.3.1
ARG GRAAL_VERSION
#17
ARG JAVA_VERSION
#RUN mkdir /graalvm && PATH=~/graalvm/bin:$PATH && JAVA_HOME=/graalvm
ENV PATH=/graalvm/bin:$PATH 
ENV JAVA_HOME=/graalvm
RUN mkdir /graalvm
#WORKDIR /build
COPY --from=downloader /build/graalvm /graalvm
USER ubuntu
#RUN tar xvf ./graalvm.tar.gz -C /graalvm --strip-components 1 && rm ./graalvm.tar.gz
ENTRYPOINT [ "/bin/bash" ]