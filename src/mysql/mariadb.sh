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
    group=$2
else
    echo '请添加用户组'
    exit
fi

yum -y install gcc gcc-c++ make autoconf libtool-ltdl-devel gd-develi freetype-devel libxml2-devel libjpeg-devel libpng-devel curl-devel patch unzip libmcrypt-devel libmhash-devel sudo bzip2 flex cmake libaio libaio-devel bison bison-devel zlib-devel openssl openssl-devel ncurses ncurses-devel libcurl-devel libarchive-devel boost boost-devel lsof wget perl kernel-headers kernel-devel pcre-devel

count=`pidof "/usr/local/mysql/bin/mysql" | wc -l`

if [ $count != 0 ];then
    pid=`pidof "/usr/local/mysql/bin/mysql"`
    kill $pid
fi

count=`pidof "/usr/local/mysql/bin/mysqld" | wc -l`

if [ $count != 0 ];then
    pid=`pidof "/usr/local/mysql/bin/mysqld"`

    kill $pid
fi

# 定义安装版本号
if [ $3 ]; then
    version=$1
else
    version="10.3.8"
fi

name="mariadb"
dirname="$name-$version"
tarfile="$name-${version}.tar.gz"

cd /usr/local

if [ -d /usr/local/mysql ]
then
    rm -rf /usr/local/mysql
fi

if [ ! -d "/usr/local/src/lib/" ]
then
    mkdir /usr/local/src/lib
fi

cd /usr/local/src/lib

if [ -f /usr/local/src/lib/$tarfile ]
then
    rm -rf /usr/local/src/lib/$tarfile
    # wget http://pkgs.fedoraproject.org/repo/pkgs/mysql/mysql-boost-5.7.16.tar.gz/f7724b816919878760b5c7c9956e6508/mysql-boost-5.7.16.tar.gz
fi

wget https://downloads.mariadb.org/interstitial/$dirname/source/$tarfile

if [ -d /usr/local/src/lib/$dirname ]
then
    rm -rf /usr/local/src/lib/$dirname
fi

tar zxf /usr/local/src/lib/$tarfile

cd /usr/local/src/lib/$dirname

cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
    -DMYSQL_DATADIR=/usr/local/mysql/data \
    -DMYSQL_UNIX_ADDR=/var/lib/mysql/mysql.sock \
    -DMYSQL_TCP_PORT=3306 \
    -DMYSQL_USER=$user \
    -DDEFAULT_CHARSET=utf8 \
    -DDEFAULT_COLLATION=utf8_general_ci \
    -DWITH_EXTRA_CHARSETS=all \
    -DENABLED_LOCAL_INFILE=ON \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_FEDERATED_STORAGE_ENGINE=1 \
    -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
    -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
    -DDOWNLOAD_BOOST=1

make && make install

cp /usr/local/mysql/support-files/wsrep.cnf /etc/my.cnf

/usr/local/mysql/scripts/mysql_install_db --defaults-file=/etc/my.cnf --user=mysql --datadir=/usr/local/mysql/data --basedir=/usr/local/mysql/ --wsrep_cluster_address=/usr/local/mysql/

cp /usr/local/mysql/support-files/mysql.server /etc/rc.d/init.d/mysqld

chmod +x /etc/rc.d/init.d/mysqld

chkconfig --add mysqld

/usr/local/mysql/support-files/mysql.server start

/usr/local/mysql/support-files/mysql.server status

cp /usr/local/mysql/bin/mysql /usr/local/bin/mysql

/usr/local/mysql/bin/mysql_secure_installation
