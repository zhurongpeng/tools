#!/bin/sh

yum install zsh

sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"ys\"/g' ~/.zshrc

echo "s/plugins=(\n  git\n)/plugins=(autojump composer docker gradle git git-flow git-prompt git-remote-branch git-flow-completion go golang kubectl man npm pass repo rsync sudo systemd yum)/g" >> ~/.zshrc

