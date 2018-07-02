#!/bin/sh

#http://www.phpunit.cn/getting-started.html
wget https://phar.phpunit.de/phpunit.phar
 
chmod +x phpunit.phar
 
sudo mv phpunit.phar /usr/local/bin/phpunit
 
phpunit --version
 
#单测TestCase定义需改
#由
#class DemoTC extends PHPUnit_Framework_TestCase
#改为
#
##class DemoTC extends PHPUnit\Framework\TestCase
