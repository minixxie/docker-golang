FROM alpine:3.7 as protoc
 
ENV PROTOC_VER 3.5.1
RUN cd /tmp && wget https://github.com/google/protobuf/releases/download/v${PROTOC_VER}/protoc-${PROTOC_VER}-linux-x86_64.zip
RUN mkdir -p /tmp/protoc && cd /tmp/protoc && unzip ../protoc-${PROTOC_VER}-linux-x86_64.zip
RUN cd /tmp/protoc && tar czf /tmp/protoc-${PROTOC_VER}-linux-x86_64.tar.gz *


FROM golang:1.9.4

ENV PROTOC_VER 3.5.1
COPY --from=protoc /tmp/protoc-${PROTOC_VER}-linux-x86_64.tar.gz /tmp/
RUN cd /usr && tar xzf /tmp/protoc-${PROTOC_VER}-linux-x86_64.tar.gz

RUN go get github.com/golang/protobuf/protoc-gen-go
RUN go get -u github.com/golang/dep/cmd/dep
