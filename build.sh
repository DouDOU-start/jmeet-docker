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

    # 编译完整工程
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
            echo "start to compile videobridge.."
            echo ""
            cd resources && bash build_deb_package.sh
        popd
    fi

    # 仅编译meet工程
    if [[ $BUILD_TARGET ==  "meet" ]]; then
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
    fi

    # 仅编译jicofo工程
    if [[ $BUILD_TARGET ==  "jicofo" ]]; then
        pushd $DIR_OF_JICOFO > /dev/null
            echo ""
            echo "start to compile jicofo.."
            echo ""
            cd resources && bash build_deb_package.sh
        popd
    fi

    # 仅编译videobridge工程
    if [[ $BUILD_TARGET ==  "videobridge" ]]; then
        pushd $DIR_OF_VIDEOBRIDGE > /dev/null
            echo ""
            echo "start to compile videobridge.."
            echo ""
            cd resources && bash build_deb_package.sh
        popd
    fi

    # -f 如果已存在deb包，则强制覆盖
    mv -f ../*.deb build/
    rm -rf ../*.changes
    rm -rf ../*.buildinfo

    # 开始构建镜像
    docker build -t doudou/${IMAGE_NAME}:${VERSION} .

fi

if [[ ${COMMAND} == "tag" ]]; then
    echo ""
    echo "start to save docker image.."
    echo ""
    docker save doudou/jmeet:$VERSION | gzip > jmeet-docker-$VERSION.tar.gz
    # docker save -o jmeet-docker-$VERSION.tar doudou/jmeet:$VERSION

    echo ""
    echo "start to tag zip package.."
    echo ""
    zip jmeet-docker-$VERSION-$BUILD_TIME.zip -r install.sh uninstall.sh jmeet-docker-$VERSION.tar.gz
fi
