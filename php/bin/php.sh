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
    version="7.2.5"
fi

# 安装依赖
yum install wget autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5-devel openssl openssl-devel openldap openldap-devel nss_ldap gcc gcc-c++ bison git libxslt-devel libXpm-devel libjpeg-turbo libjpeg-turbo-devel libvpx libvpx-devel -y

php="php-"${version}

cd /usr/local/src

if [ ! -d "/usr/local/src/lib" ];then
    mkdir lib
fi

cd /usr/local/src/lib

if [ ! -f "/usr/local/src/lib/${php}.tar.gz" ];then
    wget http://cn2.php.net/distributions/${php}.tar.gz
fi

#判断php进程是否开启,开启则kill进程
count=`pidof "/usr/local/${php}/sbin/php-fpm" | wc -l`

if [ $count != 0 ];then
    pid=`pidof "/usr/local/${php}/sbin/php-fpm"`
    kill $pid
fi

#进入安装目录,php已经安装则删除

cd /usr/local

if [ -d /usr/local/${php} ]
then
    rm -rf /usr/local/${php}
fi

#进入目录,php安装包不存在则解压
if [ ! -d /usr/local/src/lib/${php} ]
then
    cd /usr/local/src/lib

    tar zxf /usr/local/src/lib/$php.tar.gz
fi

#进入tar包所在目录
cd /usr/local/src/lib/$php

/usr/local/src/lib/$php/configure \
    --prefix=/usr/local/${php} \
    --with-config-file-path=/usr/local/${php}/etc \
    --with-config-file-scan-dir=/usr/local/${php}/etc/conf.d \
    --with-openssl \
    --with-zlib=/usr \
    --enable-mbstring=all \
    --with-fpm-user=${user} \
    --with-fpm-group=${group} \
    --enable-fpm \
    --enable-zip \
    --enable-mysqlnd \
    --enable-opcache \
    --with-mysql \
    --with-mysqli \
    --with-pdo-mysql=mysqlnd \
    --with-curl \
    --with-mysql-sock=/usr/local/mysql/tmp/mysql.sock \
    --disable-fileinfo \
    --with-openssl \
    --with-pcre-regex \
    --with-pdo-mysql \
    --with-xmlrpc \
    --with-freetype-dir \
    --with-gd \
    --with-jpeg-dir=/usr/local/jpeg \
    --with-png-dir \
    --enable-short-tags \
    --enable-sockets \
    --enable-soap \
    --enable-mbstring \
    --enable-static \
    --enable-gd-native-ttf \
    --with-xsl \
    --enable-ftp \
    --enable-bcmath \
    --with-libxml-dir

make && make install

cp  /usr/local/src/lib/${php}/php.ini-development /usr/local/${php}/etc/php.ini
cd /usr/local/${php}/etc
cp php-fpm.conf.default php-fpm.conf
cp php-fpm.d/www.conf.default  php-fpm.d/${user}.conf

ln -s /usr/local/${php} /usr/local/php

/usr/local/src/php/bin/phpredis.sh
# /etc/init.d/php-fpm start
