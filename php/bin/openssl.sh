#!/bin/sh

# 定义安装版本号
if [ $1 ]; then
    version=$1
else
    version="7.2.5"
fi

name="php"
dirname="$name-$version"

cd /usr/local/src/lib/$dirname/ext/openssl

cp config0.m4 config.m4

/usr/local/php/bin/phpize

./configure --with-openssl --with-php-config=/usr/local/php/bin/php-config

make && make install

echo extension=openssl.so >> /usr/local/php/etc/php.ini



