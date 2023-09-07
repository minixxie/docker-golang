FROM alpine:3.18 as protoc
 
ENV PROTOC_VER 24.1
RUN cd /tmp && wget https://github.com/google/protobuf/releases/download/v${PROTOC_VER}/protoc-${PROTOC_VER}-linux-x86_64.zip
RUN mkdir -p /tmp/protoc && cd /tmp/protoc && unzip ../protoc-${PROTOC_VER}-linux-x86_64.zip
RUN cd /tmp/protoc && tar czf /tmp/protoc-${PROTOC_VER}-linux-x86_64.tar.gz *


FROM golang:1.21.0

# install apache-benchmark (ab)
RUN apt-get update && apt-get install -y --allow-unauthenticated apache2-utils && rm -rf /var/lib/apt/lists/*

ENV PROTOC_VER 24.1
COPY --from=protoc /tmp/protoc-${PROTOC_VER}-linux-x86_64.tar.gz /tmp/
RUN cd /usr && tar xzf /tmp/protoc-${PROTOC_VER}-linux-x86_64.tar.gz

ADD ./call-api.sh /usr/bin/call-api.sh
ADD ./get-request.http /get-request.http
ADD ./post-request.http /post-request.http

COPY --from=bufbuild/buf:1.26.1 /usr/local/bin/buf /usr/bin/buf
