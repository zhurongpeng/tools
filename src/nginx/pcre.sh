#!/bin/sh

# 定义安装版本号
if [ $1 ]; then
    version=$1
else
    version="8.38"
fi

name="pcre"
dirname="$name-$version"
tarfile="${dirname}.tar.gz"

cd /usr/local/src/lib

if [ ! -f "/usr/local/src/lib/$tarfile" ]
then
    wget https://ftp.pcre.org/pub/pcre/$tarfile
fi

tar zxf /usr/local/src/lib/$tarfile

cd /usr/local/src/lib/$dirname

./configure

make && make install

if [ ! -d "/usr/local/src/lib/$name/" ];then
    echo '目录不存在';
else
    echo '目录存在';
    rm -rf /usr/local/src/lib/$name
fi

ln -s /usr/local/src/lib/$dirname /usr/local/src/lib/$name

