#!/bin/sh

yum install vim

path=$(cd `dirname $0`; pwd)

curl -L https://raw.githubusercontent.com/kepbod/ivim/master/setup.sh > $path/setup.sh

sh $path/setup.sh


