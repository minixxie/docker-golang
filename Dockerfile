FROM golang:1.7

RUN apt-get update && apt-get install -q -y unzip
RUN cd /tmp/ && wget https://github.com/google/protobuf/releases/download/v3.1.0/protoc-3.1.0-linux-x86_64.zip && cd /usr && unzip -o /tmp/protoc-3.1.0-linux-x86_64.zip
RUN apt-get -q -y remove unzip && apt-get clean

RUN go get github.com/golang/protobuf/protoc-gen-go
RUN go get -u github.com/kardianos/govendor && go get github.com/tools/godep && go get github.com/kovetskiy/manul
