#!/bin/sh

sudo yum install vim

export LC_ALL = C

path=$(cd `dirname $0`; pwd)

if [ ! -d "/usr/local/src/lib/" ]
then
    mkdir /usr/local/src/lib
    chmod 777 /usr/local/src/lib
fi

curl -L https://raw.githubusercontent.com/kepbod/ivim/master/setup.sh > /usr/local/src/lib/setup.sh

sh /usr/local/src/lib/setup.sh -i

cat $path/vimrc >> ~/.vimrc

rm -rf ~/.vim/bundle/vim-gutentags/plugin/gutentags.vim

sed -i "s/packadd! matchit/\" packadd! matchit/g" ~/.vimrc

