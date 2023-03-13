#!/bin/bash

COMMAND=$1
SOFT=$2

if [[ $COMMAND == "uninstall" ]]; then

    if [[ $SOFT == "jmeet" ]]; then
        docker rm -f jmeet

        # 卸载jmeet后备份配置文件
        # bak=/usr/local/jmeet/conf
        # if [ -d "$bak" ]; then
        #     rm -rf /var/DouDOU-start/bak/jmeet/
        #     mv /usr/local/jmeet/conf/ /var/DouDOU-start/bak/jmeet/
        # fi
    fi

    if [[ $SOFT == "videobridge" ]]; then
        docker rm -f videobridge

        # 卸载网桥后备份配置文件
        # bak=/usr/local/videobridge/conf
        # if [ -d "$bak" ]; then
        #     rm -rf /var/DouDOU-start/bak/jmeet/
        #     mv /usr/local/videobridge/conf/ /var/DouDOU-start/bak/jmeet/
        # fi
    fi

fi

docker rm $(docker ps -a -q)
docker rmi $(docker images -f "dangling=true" -q)

rm jmeet-docker-*.gz
rm jmeet-docker-*.zip

# docker rm -f jmeet

# docker rm $(docker ps -a -q)

# docker rmi $(docker images -f "dangling=true" -q)