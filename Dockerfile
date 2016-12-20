FROM golang:1.7

RUN apt-get update && apt-get install -q -y protobuf-compiler
RUN apt-get clean
RUN go get github.com/golang/protobuf/protoc-gen-go

RUN git clone --branch pkg-debian git://github.com/kovetskiy/manul /tmp/manul && cd /tmp/manul && ./build.sh && dpkg -i *.deb && rm -rf /tmp/manul

