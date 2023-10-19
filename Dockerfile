FROM --platform=$TARGETPLATFORM alpine:3.18.4 as protoc
ARG TARGETPLATFORM
ARG TARGETARCH
ARG BUILDPLATFORM
 
ENV PROTOC_VER 24.4

WORKDIR /tmp
RUN \
	if [ ${TARGETARCH} == arm64 ]; then \
		wget -O /tmp/protoc.zip \
		https://github.com/google/protobuf/releases/download/v${PROTOC_VER}/protoc-${PROTOC_VER}-linux-aarch_64.zip; \
	elif [ ${TARGETARCH} == amd64 ]; then \
		wget -O /tmp/protoc.zip \
		https://github.com/google/protobuf/releases/download/v${PROTOC_VER}/protoc-${PROTOC_VER}-linux-x86_64.zip; \
	else \
		echo >&2 "ERR: unsupported architecture."; exit 1; \
	fi

RUN mkdir -p /tmp/protoc && cd /tmp/protoc && unzip ../protoc.zip && tar czf /tmp/protoc.tar.gz *


FROM --platform=$TARGETPLATFORM golang:1.21.0
ARG TARGETPLATFORM
ARG TARGETARCH
ARG BUILDPLATFORM

# install apache-benchmark (ab)
RUN apt-get update && apt-get install -y --allow-unauthenticated apache2-utils && rm -rf /var/lib/apt/lists/*

COPY --from=protoc /tmp/protoc.tar.gz /tmp/
RUN cd /usr && tar xzf /tmp/protoc.tar.gz

ADD ./call-api.sh /usr/bin/call-api.sh
ADD ./get-request.http /get-request.http
ADD ./post-request.http /post-request.http

COPY --from=bufbuild/buf:1.26.1 /usr/local/bin/buf /usr/bin/buf
