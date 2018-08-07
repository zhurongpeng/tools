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

yum -y install gcc gcc-c++ make autoconf libtool-ltdl-devel gd-develi freetype-devel libxml2-devel libjpeg-devel libpng-devel openssl-devel curl-devel bison patch unzip libmcrypt-devel libmhash-devel ncurses-devel sudo bzip2 flex libaio-devel cmake

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

if [ ! -f /usr/local/src/lib/$tarfile ]
then
    wget https://downloads.mariadb.org/interstitial/mariadb-10.3.8/source/$tarfile
    # wget http://pkgs.fedoraproject.org/repo/pkgs/mysql/mysql-boost-5.7.16.tar.gz/f7724b816919878760b5c7c9956e6508/mysql-boost-5.7.16.tar.gz
fi

tar zxf /usr/local/src/lib/$tarfile

cd /usr/local/src/lib/$dirname

cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
    -DMYSQL_DATADIR=/usr/local/mysql/data \
    -DMYSQL_UNIX_ADDR=/usr/local/mysql/tmp/mysql.sock \
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

cp /usr/local/mysql/support-files/mysql.server /etc/rc.d/init.d/mysqld
chmod +x /etc/rc.d/init.d/mysqld
chkconfig --add mysqld 
cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf

# mkdir -p /data/mysql
# /usr/local/mysql/bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/data/mysql

/usr/local/mysql/bin/mysqld --initialize --user=$user --basedir=/usr/local/mysql

echo skip-grant-tables >> /etc/my.cnf

/usr/local/mysql/support-files/mysql.server start

/usr/local/mysql/support-files/mysql.server status

cp /usr/local/mysql/bin/mysql /usr/local/bin/mysql

