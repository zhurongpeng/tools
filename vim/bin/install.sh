#!/bin/sh

yum install vim

curl -L https://raw.githubusercontent.com/kepbod/ivim/master/setup.sh > ~/setup.sh

sh ~/setup.sh -i

path=$(cd `dirname $0`; pwd)

cat $path/vimrc >> ~/.vimrc

