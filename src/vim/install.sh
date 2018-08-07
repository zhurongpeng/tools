#!/bin/sh

yum install vim

path=$(cd `dirname $0`; pwd)

if [ ! -d "/usr/local/src/lib/" ]
then
    mkdir /usr/local/src/lib
fi

curl -L https://raw.githubusercontent.com/kepbod/ivim/master/setup.sh > /usr/local/src/lib/setup.sh

sh /usr/local/src/lib/setup.sh -i

cat $path/vimrc >> ~/.vimrc

