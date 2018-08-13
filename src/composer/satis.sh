#!/bin/sh

if [ ! -d /tool ];then
    mkdir /tool
fi

cd /tool

if [ -d /tool/satis ];then
    rm -rf /tool/satis
fi

if [ -d /tool/composer/ ];then
    rm -rf /tool/satis
fi

composer create-project composer/satis --stability=dev --keep-vcs

mv ./satis composer

php bin/satis build satis.json public/
