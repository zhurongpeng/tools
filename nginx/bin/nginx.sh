#!/bin/bash

# 定义安装用户
if [ $1 ]; then
    user=$1
else
    echo '请添加用户名'
    exit
fi

# 定义安装用户组
if [ $2 ]; then
    user=$1
else
    echo '请添加用户组'
    exit
fi

# 定义安装版本号
if [ $3 ]; then
    version=$1
else
    version="1.12.2"
fi

name="nginx"
dirname="nginx-$version"
tarfile="nginx-${version}.tar.gz"

yum -y install gcc gcc-c++ make

if [ ! -d "/usr/local/src/lib/" ]
then
    mkdir /usr/local/src/lib
fi

path=$(cd `dirname $0`; pwd)

sh $path/bin/openssl.sh
echo 'test'
exit
sh $path/bin/zlib.sh
sh $path/bin/pcre.sh

#开始安装
count=`pidof "/usr/local/$dirname/sbin/nginx" | wc -l`

if [ $count != 0 ];then
    pid=`pidof "/usr/local/$dirname/sbin/nginx"`
    kill -9 $pid
fi

cd /usr/local

if [ -d "/usr/local/$dirname/" ]
then
    rm -rf /usr/local/$dirname
fi

cd /usr/local/src/lib

if [ -d "/usr/local/src/lib/$dirname/" ]
then
    rm -rf /usr/local/src/lib/$dirname
fi

if [ ! -f /usr/local/src/lib/$tarfile ]
then
    wget http://nginx.org/download/$tarfile
fi

tar zxf /usr/local/src/lib/$tarfile

cd /usr/local/src/lib/$dirname

./configure --prefix=/usr/local/$dirname \
    --pid-path=/usr/local/$dirname/logs/nginx.pid \
    --error-log-path=/usr/local/$dirname/logs/error.log \
    --http-log-path=/usr/local/$dirname/logs/access.log \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-stream_ssl_module \
    --with-stream \
    --with-threads \
    --user=$user --group=$group \
    --with-pcre=/usr/local/src/lib/pcre \
    --with-zlib=/usr/local/src/lib/zlib \
    --with-openssl=/usr/local/src/lib/openssl

make && make install

if [ ! -d "/usr/local/$name/" ];then
    echo '目录不存在';
else
    echo '目录存在';
    rm -rf /usr/local/$name
fi

ln -s /usr/local/$dirname /usr/local/$name

/usr/local/$name/sbin/nginx

# nginx安装路径
# ./configure --prefix=/usr/local/nginx-1.10.1 \
# nginx可执行文件安装路径
#     --sbin-path=/usr/local/nginx-1.10.1/sbin/nginx \
# nginx.conf路径
#     --conf-path=/usr/local/nginx-1.10.1/conf/nginx.conf \
# 在nginx.conf中没有指定pid指令的情况下，默认的nginx.pid的路径
#     --pid-path=/usr/local/nginx-1.10.1/logs/nginx.pid \
# nginx.lock文件的路径
#     --lock-path=/usr/local/nginx-1.10.1/logs/nginx.lock 
# 在nginx.conf中没有指定error_log指令的情况下，默认的错误日志的路径
#     --error-log-path=/usr/local/nginx-1.10.1/logs/error.log \
# 在nginx.conf中没有指定access_log指令的情况下，默认的访问日志的路径
#     --http-log-path=/usr/local/nginx-1.10.1/logs/access.log \
# 在nginx.conf中没有指定user指令的情况下，默认的nginx使用的用户
#     --user=zhurongpeng \
# 在nginx.conf中没有指定group指令的情况下，默认的nginx使用的组
#     --group=nginx \
# 指定编译的目录
#     --builddir=/usr/local
# 开启https模块
#     --with-http_ssl_module \
# 开启http2.0模块
#     --with-http_v2_module \
# 启用 IMAP4/POP3/SMTP 代理模块
#     --with-mail \
# 启用 ngx_mail_ssl_module模块
#     --with-mail_ssl_module \
#     --with-stream_ssl_module \
#     --with-stream \
#     --with-threads \
# 指定PCRE库的源代码的路径。
#     --with-pcre=/usr/local/src/pcre-8.38 \
# 指定zlib库的源代码的路径。
#     --with-zlib=/usr/local/src/zlib-1.2.8 \
# 指定openssl库的源代码的路径。
#     --with-openssl=/usr/local/src/openssl-1.0.2h
