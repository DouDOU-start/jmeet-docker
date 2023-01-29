#!/bin/bash

VERSION="v1.0.0"
IMAGE_NAME="jmeet-base"

# 加速构建镜像 --ulimit nofile=1024000:1024000
docker build -t doudou/${IMAGE_NAME}:${VERSION} --ulimit nofile=1024000:1024000 .