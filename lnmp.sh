#!/bin/sh

path=$(cd `dirname $0`; pwd)

# 定义安装用户
if [ $1 ]; then
    user=$1
else
    user=www
    echo '默认用户名www'
fi

# 定义安装用户组
if [ $2 ]; then
    group=$1
else
    group=www
    echo '默认用户组www'
fi


sh $path/user/bin/user.sh $user $group

sh $path/user/bin/user.sh mysql mysql

sh $path/mysql/bin/mysql.sh mysql mysql

sh $path/mysql/bin/nginx.sh $user $group

sh $path/mysql/bin/php.sh $user $group

