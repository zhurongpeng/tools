#!/bin/bash

cd /usr/local/src/lib

curl -sS https://getcomposer.org/installer > composer.phar

ln -s /usr/local/src/lib/composer.phar /usr/local/bin/composer

