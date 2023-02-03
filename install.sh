#!/bin/bash

INSTALL_FROM=$1

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

echo "Author: \"DouDOU\""
echo "Github: \"https://github.com/DouDOU-start\""
echo "Email: \"1021217094@qq.com\""
echo ""

if [[ -n $(docker ps -q -f "name=^jmeet$") ]];then
	echo "错误：jmeet网络视频会议服务已存在，请卸载后再尝试重新安装！"
    echo ""
    exit -1
fi

if [[ $INSTALL_FROM == "gz" ]];
then
    echo "正在导入jmeet镜像..."
    docker load -i jmeet-docker-v1.0.0.tar.gz
    echo "导入jmeet镜像成功！"
    echo ""
fi

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

if [ $SIP_ACCOUNT ];
then
	read -e -p "请输入SIP服务账号: " -i "${SIP_ACCOUNT}" SIP_ACCOUNT
else
	read -e -p "请输入SIP服务账号: " -i "9999@${INNER_IP}" SIP_ACCOUNT
fi

if [ $SIP_PASSWORD ];
then
	read -e -p "请输入SIP账号密码: " -i "${SIP_PASSWORD}" SIP_PASSWORD
else
	read -e -p "请输入SIP账号密码: " -i "root" SIP_PASSWORD
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

setEnv DOMAIN $DOMAIN
setEnv PUBLIC_IP $PUBLIC_IP
setEnv SIP_ACCOUNT $SIP_ACCOUNT
setEnv SIP_PASSWORD $SIP_PASSWORD
setEnv SSH_PORT $SSH_PORT
setEnv SSH_PASSWD $SSH_PASSWD

echo ""

docker run -itd --name jmeet \
    --net=host \
    --restart=unless-stopped \
    -e INNER_IP=$INNER_IP \
    -e DOMAIN=$DOMAIN \
    -e SSH_PORT=$SSH_PORT \
    -e SIP_ACCOUNT=$SIP_ACCOUNT \
    -e SIP_PASSWORD=$SIP_PASSWORD \
    -e SSH_PASSWD=$SSH_PASSWD \
    doudou/jmeet:v1.0.0

echo ""
echo -e "███ 容器正在启动...\c"
while [[ ! `docker exec jmeet bash service nginx status` =~ "nginx is running" ]]; 
do
    echo -e "....\c"
    sleep 3
done

echo ""
echo "jmeet网络视频会议服务安装成功！"
echo "访问地址：https://$PUBLIC_IP"

# docker exec -it jmeet /bin/bash