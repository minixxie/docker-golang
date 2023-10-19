#!/bin/bash

### https://docs.docker.com/build/building/multi-platform/
# Pre-requisite:
# brew install colima
# colima start \
#        --arch aarch64 \
#        --runtime docker \
#        --cpu 4 \
#        --memory 8
# colima ssh
# docker buildx ls
# docker buildx create --name mybuilder --driver-opt 'image=moby/buildkit:v0.12.1-rootless' --bootstrap --use

docker buildx build --push --platform linux/amd64,linux/arm64/v8 --tag minixxie/golang:1.21.0 .
