#!/bin/bash

cd /usr/local/src/lib

if [ -f "/usr/local/src/lib/composer.phar" ];then
    rm -rf /usr/local/src/lib/composer.phar
fi

curl -sS https://getcomposer.org/installer > composer.phar

if [ -f "/usr/local/bin/composer" ];then
    rm -rf /usr/local/bin/composer
fi

ln -s /usr/local/src/lib/composer.phar /usr/local/bin/composer

