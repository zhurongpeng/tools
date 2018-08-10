#!/bin/sh

cd /data/tools

composer create-project composer/satis --stability=dev --keep-vcs

mv ./satis composer

php bin/satis build satis.json public/
