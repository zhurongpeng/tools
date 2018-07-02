#!/bin/sh

#安装php redis扩展
cd /usr/local/src/phpredis-develop

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make && make install

echo extension_dir = "/usr/local/php/lib/php/extensions/no-debug-non-zts-20151012" >> /usr/local/php/etc/php.ini

echo extension=redis.so >> /usr/local/php/etc/php.ini

