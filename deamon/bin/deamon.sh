#!/bin/sh

echo "#################"

if [ ! $1 ]; then
    echo "请输入要执行的命令 例如:/usr/local/php"
    exit
fi

if [ ! $2 ]; then
    echo "请输入命令携带的参数"
    exit
fi

if [ ! $3 ]; then
    echo "请输入命令执行次数"
    exit
fi

path=$(cd `dirname $0`; pwd)

if [ ! -f "/usr/local/src/lib/deamon" ]
then
    gcc -g $path/deamon.c -o /usr/local/src/lib/deamon
fi

for ((i=1; i<=$3; i++))
do
    /usr/local/src/lib/deamon "$1 $2"
done
