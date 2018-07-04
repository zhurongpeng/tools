#!/bin/sh

yum install zsh

sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"ys\"/g' ~/.zshrc




