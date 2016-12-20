FROM golang:1.7

RUN apt-get update && apt-get install -q -y unzip
RUN cd /tmp/ && wget https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip && cd /usr && unzip -o /tmp/protoc-3.0.0-linux-x86_64.zip
RUN apt-get -q -y remove unzip
RUN apt-get clean
RUN go get github.com/golang/protobuf/protoc-gen-go

RUN git clone --branch pkg-debian git://github.com/kovetskiy/manul /tmp/manul && cd /tmp/manul && ./build.sh && dpkg -i *.deb && rm -rf /tmp/manul

