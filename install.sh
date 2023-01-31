#!/bin/bash

# 创建安装参数存储文件，用于下次快速安装
INSTALL_PROFILE=/etc/jmeet_install_profile
if [ ! -f "${INSTALL_PROFILE}" ]; 
then
    touch "$INSTALL_PROFILE"
fi

source $INSTALL_PROFILE

# 重复安装jmeet时，使用之前设置过的参数
function setEnv(){
    key=$1
    value=$2
    # echo "Set ENV: ${key}=${value}"
    if [ -z "`grep ^"export ${key}" $INSTALL_PROFILE`" ]
    then
        echo  "export $key=$value" >> $INSTALL_PROFILE
    else
        if [[ $value =~ '@' ]];then
            sed -i "s/^\export ${key}.*/\export $key=$value/" $INSTALL_PROFILE
        else
            sed -i "s@^\export ${key}.*@\export $key=$value@" $INSTALL_PROFILE
        fi
    fi
}

# 选取第一个非环回，非docker网卡地址作为本机地址的公共变量
INNER_IP=""
for real_ip in `ip address |grep 'inet ' | awk '{print $2}' |awk -F '/'  '{print $1}'`;
do
	if [[ $real_ip != "127.0"* && $real_ip != "172.17"* && $real_ip != "" ]]
	then
		INNER_IP=${real_ip}
		break
	fi
done

jmeet_tip="
===================================================================================================
===================================================================================================
#                                                                                                 #
#                                                                                                 #
#                               欢迎使用jmeet网络视频会议                                         #
#                                                                                                 #
#                                                                                                 #
===================================================================================================
===================================================================================================
"
echo -e "${YELLOW}${jmeet_tip}${POS}${BLACK}"

if [ $DOMAIN ];
then
	read -e -p "请输入您的域名: " -i "${DOMAIN}" DOMAIN
else
	read -e -p "请输入您的域名: " -i "docker.jmeet.com" DOMAIN
fi

if [ $PUBLIC_IP ];
then
	read -e -p "请输入公网IP地址: " -i "${PUBLIC_IP}" PUBLIC_IP
else
	read -e -p "请输入公网IP地址: " -i "${INNER_IP}" PUBLIC_IP
fi

if [ $SSH_PORT ];
then
	read -e -p "请输入容器SSH服务端口: " -i "${SSH_PORT}" SSH_PORT
else
	read -e -p "请输入容器SSH服务端口: " -i "8822" SSH_PORT
fi

if [ $SSH_PASSWD ];
then
	read -e -p "请输入容器SSH服务密码: " -i "${SSH_PASSWD}" SSH_PASSWD
else
	read -e -p "请输入容器SSH服务密码: " -i "root" SSH_PASSWD
fi

docker run -itd --name jmeet \
    --net=host \
    --restart=unless-stopped \
    -e INNER_IP=$INNER_IP \
    -e DOMAIN=$DOMAIN \
    -e SSH_PORT=$SSH_PORT \
    -e SSH_PASSWD=$SSH_PASSWD \
    doudou/jmeet:v1.0.0

# docker exec -it jmeet /bin/bash