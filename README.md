# jmeet-docker

## jmeet-docker服务说明

**本段描述的是jmeet-docker服务编译以及安装过程的一些注意事项**

- jmeet-docker服务必须在docker环境下运行，docker安装教程请参照官网

  [docker]: https://www.docker.com/

- 使用jmeet-docker服务需要防火墙开通`443 tcp`端口和`10000 udp`端口

- release包是基于X86架构编译，暂时未适配ARM架构机器

## 通过release包直接安装jmeet服务

通过release包直接安装jmeet服务仅支持linux系统，这里推荐使用的是Ubuntu系统

1. **下载最新版release包：** https://github.com/DouDOU-start/jmeet-docker/releases

2. **安装jmeet服务过程如下：**

   ```shell
   # 解压jmeet-docker.zip包到/opt/jmeet-docker-v1.0.0
   unzip -o -d /opt/jmeet-docker-v1.0.0 jmeet-docker-v1.0.0-20230201-163529.zip
   
   # 切换工作目录
   cd /opt/jmeet-docker-v1.0.0/
   
   # 赋予安装和卸载服务脚本可执行权限
   chmod u+x install.sh uninstall.sh
   
   # 导入jmeet镜像安装服务
   ./install.sh gz
   # 输入您的域名（可使用默认域名）: docker.jmeet.com
   # 输入公网IP地址（如无公网IP地址可直接填本机IP）：127.0.0.1
   # 输入容器SSH服务端口（不和本机SSH端口冲突即可）：8822
   # 输入容器SSH服务密码（默认为root）: root
   
   jmeet网络视频会议服务安装成功！
   访问地址：https://127.0.0.1
   ```
