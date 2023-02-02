FROM node:lts-slim

LABEL author="DouDOU" email="1021217094@qq.com" descripton="jmeet-base"

# 替换阿里云源(默认,当编译过程下载更新安装比较慢时,可尝试更新其它站点)
# RUN sed -i "s@http://deb.debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list
# 替换清华站点
#RUN sed -i "s@http://deb.debian.org@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
# 替换163站点
RUN sed -i "s@http://deb.debian.org@http://mirrors.163.com@g" /etc/apt/sources.list

RUN apt-get update && \
	apt-get install -y telnet net-tools vim inetutils-ping openssh-server \
    nginx curl prosody lua-sec lua-basexx lua-luaossl lua-cjson lua-inspect \
    coturn dnsutils \
    openjdk-11-jdk ruby-hocon jq \
    procps uuid-runtime libssl1.1 \
    default-jre-headless openssl && \
    apt-get clean && \
    rm -Rf /var/lib/apt/lists/*

# 设置时区
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone