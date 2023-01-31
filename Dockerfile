FROM doudou/jmeet-base:v1.0.0

LABEL author="DouDOU" email="1021217094@qq.com" descripton="jmeet"

COPY /rootfs/ /

COPY /build/*.deb /build/

# 创建配置文件目录
RUN mkdir config

RUN chmod +x /run.sh

CMD /run.sh