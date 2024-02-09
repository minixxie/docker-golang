#!/bin/bash

set -e

scriptPath=$(cd $(dirname "$0") && pwd)

image=minixxie/golang
tag=1.21.0
platforms=linux/amd64,linux/arm64/v8

nerdctl build . \
	-f Dockerfile --platform $platforms \
	--tag minixxie/golang:$tag \
	--namespace=k8s.io
nerdctl login
nerdctl push --platform $platforms minixxie/golang:$tag --namespace=k8s.io
