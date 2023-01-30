#!/bin/bash

COMMAND=$1
BUILD_TARGET=$2

BASE_VERSION=v1.0.0
VERSION=v1.0.0
IMAGE_NAME="jmeet"
BUILD_TIME=`date -d today +"%Y%m%d-%H%M%S"`

DIR_OF_MEET=../jmeet
DIR_OF_LIB=../lib-jmeet
DIR_OF_JICOFO=../jicofo
DIR_OF_VIDEOBRIDGE=../jitsi-videobridge

if [[ ${COMMAND} == "build" ]]; then
    if [[ $BUILD_TARGET ==  "all" ]]; then
    
        rm -rf build
        mkdir build

        pushd $DIR_OF_LIB > /dev/null
            echo ""
            echo "start to compile lib-jmeet.."
            echo ""
            rm -rf dist
            npm install
            npm run build:webpack && npm run build:tsc
        popd

        pushd $DIR_OF_MEET > /dev/null
            echo ""
            echo "start to compile jmeet.."
            echo ""
            npm install
            npm install lib-jitsi-meet --force && make deploy-lib-jitsi-meet
            rm -rf libs
            make
            dpkg-buildpackage -A -rfakeroot -us -uc -tc
        popd

        pushd $DIR_OF_JICOFO > /dev/null
            echo ""
            echo "start to compile jicofo.."
            echo ""
            cd resources && bash build_deb_package.sh
        popd

        pushd $DIR_OF_VIDEOBRIDGE > /dev/null
            echo ""
            echo "start to compile jicofo.."
            echo ""
            cd resources && bash build_deb_package.sh
        popd
    fi

    mv ../*.deb build/
    rm -rf ../*.changes
    rm -rf ../*.buildinfo

    docker build -t doudou/${IMAGE_NAME}:${VERSION} .

fi

