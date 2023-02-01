#!/bin/bash

if [[ -z $(docker ps -q -f "name=^jmeet$") ]];then
	echo "未安装jmeet网络视频会议服务！"
    exit -1
fi

echo "正在卸载jmeet网络视频会议服务..."

docker rm -f jmeet

echo "卸载jmeet网络视频会议服务完成！"
