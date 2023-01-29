#!/bin/bash

docker rm -f jmeet-base

docker rm $(docker ps -a -q)

docker rmi $(docker images -f "dangling=true" -q)