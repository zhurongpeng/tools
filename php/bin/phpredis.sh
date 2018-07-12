#!/bin/sh

# 定义安装版本号
if [ $1 ]; then
    version=$1
else
    version="4.1.0"
fi

name="redis"
dirname="$name-$version"
tarfile="$name-${version}.tgz"

cd /usr/local/src/lib

if [ ! -f "/usr/local/src/lib/$tarfile" ];then
    wget http://pecl.php.net/get/$tarfile
fi

if [ -d "/usr/local/src/lib/${dirname}" ];then
    rm -rf /usr/local/src/lib/${dirname}
fi

tar -zxvf /usr/local/src/lib/$tarfile

#安装php redis扩展
cd /usr/local/src/lib/$dirname

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

# echo extension_dir = "/usr/local/php/lib/php/extensions/no-debug-non-zts-20151012" >> /usr/local/php/etc/php.ini
#
# echo extension=redis.so >> /usr/local/php/etc/php.ini

