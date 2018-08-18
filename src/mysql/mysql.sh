#!/bin/bash

groupadd mysql

useradd -g mysql mysql

yum -y install gcc gcc-c++ make autoconf libtool-ltdl-devel gd-develi freetype-devel libxml2-devel libjpeg-devel libpng-devel openssl-devel curl-devel bison patch unzip libmcrypt-devel libmhash-devel ncurses-devel sudo bzip2 flex libaio-devel cmake

count=`pidof "/usr/local/mysql/bin/mysql" | wc -l`

if [ $count != 0 ];then
    pid=`pidof "/usr/local/mysql/bin/mysql"`
    kill $pid
fi

cd /usr/local

if [ -d /usr/local/mysql ]
then
    rm -rf /usr/local/mysql
fi

dir="mysql-5.7.16"

cd /usr/local/src

# wget http://pkgs.fedoraproject.org/repo/pkgs/mysql/mysql-boost-5.7.16.tar.gz/f7724b816919878760b5c7c9956e6508/mysql-boost-5.7.16.tar.gz

tar zxf ./mysql-boost-5.7.16.tar.gz

cd /usr/local/src/$dir

cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/usr/local/mysql/data -DMYSQL_UNIX_ADDR=/usr/local/mysql/tmp/mysql.sock -DMYSQL_USER=mysql -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DENABLED_LOCAL_INFILE=ON -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/usr/local/src/mysql-5.7.16/boost/boost_1_59_0

make && make install

cp /usr/local/mysql/support-files/mysql.server /etc/mysqld
cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf

# mkdir -p /data/mysql
# /usr/local/mysql/bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/data/mysql

/usr/local/mysql/bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql

echo skip-grant-tables >> /etc/my.cnf

count=`pidof "/usr/local/mysql/bin/mysqld" | wc -l`

if [ $count != 0 ];then
    pid=`pidof "/usr/local/mysql/bin/mysqld"`

    kill $pid
fi

/usr/local/mysql/support-files/mysql.server start

/usr/local/mysql/support-files/mysql.server status

cp /usr/local/mysql/bin/mysql /usr/local/bin/mysql

