#!/bin/bash

yum -y remove git

yum install perl-ExtUtils-MakeMaker

wget https://www.kernel.org/pub/software/scm/git/git-2.15.0.tar.xz

tar Jxf git-2.15.0.tar.xz

cd git-2.15.0/

./configure --prefix=/usr/local/git

make && make install

ln -s /usr/local/git/bin/git /usr/bin/git

git --version
