#!/bin/bash

cd /usr/local/src

wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-8.8.5-ce.1.el7.x86_64.rpm

rpm -ivh gitlab-ce-8.8.5-ce.1.el7.x86_64.rpm

# echo external_url 'http://git.zhurp.xyz' >> /etc/gitlab/gitlab.rb
# sed -i '42s/daemonize no/daemonize yes/' /usr/local/redis/redis.conf
# gitlab-ctl reconfigure


