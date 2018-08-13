#!/bin/sh

if [ ! -d /data ];then
    mkdir /data
fi

cd /data/composer

composer create-project composer/satis --stability=dev --keep-vcs

mv ./satis composer

php bin/satis build satis.json public/
