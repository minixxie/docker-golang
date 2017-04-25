FROM golang:1.8-alpine

RUN apk update && apk add --no-cache git
RUN apk --update add --virtual build-dependencies unzip openssl
RUN cd /tmp/ && wget https://github.com/google/protobuf/releases/download/v3.2.0/protoc-3.2.0-linux-x86_64.zip && cd /usr && unzip -o /tmp/protoc-3.2.0-linux-x86_64.zip && rm -f /tmp/protoc-3.2.0-linux-x86_64.zip
RUN apk del build-dependencies

RUN go get github.com/golang/protobuf/protoc-gen-go
RUN go get -u github.com/kardianos/govendor
