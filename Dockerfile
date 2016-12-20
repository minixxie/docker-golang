FROM golang:1.7

RUN git clone --branch pkg-debian git://github.com/kovetskiy/manul /tmp/manul && cd /tmp/manul && ./build.sh && dpkg -i *.deb && rm -rf /tmp/manul

