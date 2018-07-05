#!/bin/bash

yum -y mbstring zip zlib

cd /usr/local/src/lib

curl -sS https://getcomposer.org/installer | php

cp composer.phar /usr/local/bin/composer

