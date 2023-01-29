#!/bin/bash

VERSION="v1.0.0"
IMAGE_NAME="jmeet-base"

docker build -t doudou/${IMAGE_NAME}:${VERSION} .