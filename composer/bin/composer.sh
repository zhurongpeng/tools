#!/bin/bash

yum -y mbstring zip zlib

cd /usr/local/src/lib

curl -sS https://getcomposer.org/installer > composer.phar

ln -s composer.phar /usr/local/bin/composer

