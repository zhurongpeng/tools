#!/bin/bash

sudo yum install -y curl policycoreutils-python openssh-server
sudo systemctl enable sshd
sudo systemctl start sshd
sudo firewall-cmd --permanent --add-service=http
sudo systemctl reload firewalld

sudo yum install postfix
sudo systemctl enable postfix
sudo systemctl start postfix

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash

sudo EXTERNAL_URL="http://git.zhurp.xyz" yum install -y gitlab-ee

echo "user = User.where(id: 1).first"
echo "user.password = \"123456\""
echo "user.password_confirmation=\"123456\""
echo "user.save!"

gitlab-rails console production




# cd /usr/local/src
#
# wget https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-8.8.5-ce.1.el7.x86_64.rpm
#
# rpm -ivh gitlab-ce-8.8.5-ce.1.el7.x86_64.rpm

# echo external_url 'http://git.zhurp.xyz' >> /etc/gitlab/gitlab.rb
# sed -i '42s/daemonize no/daemonize yes/' /usr/local/redis/redis.conf
# gitlab-ctl reconfigure


2.编辑/etc/gitlab/gitlab.rb:

# 编辑对外的域名（gitlab.papamk.com请添加A记录指向本服务器的公网IP）：
# external_url 'http://gitlab.papamk.com/'
#
# # 禁用`gitlab`内置的`nginx`:
# nginx['enable'] = false
# # 修改成与nginx运行时的用户一致
# web_server['external_users'] = ['www']
# 修改监听方式和监听地址(如果nginx与gitlab都在宿主机上，不用改也行；如果nginx在
# docker中，则需要修改)
#
# gitlab_workhorse['listen_network'] = "tcp"
# # 下面的172.18.147.173为本机IP，根据实际情况修改，不能为localhost或者127.0.0.1
# ，否则docker访问不到
# gitlab_workhorse['listen_addr'] = "172.18.147.173:8181" 
# 最后执行下面命令让配置生效：
#
# $gitlab-ctl reconfigure
# 3.配置nginx
# 增加gitlab.conf的配置（所有需要注意的地方都加了中文注释）：

#upstream gitlab-workhorse {
#   server 172.18.147.173:8181; #根据实际情况修改
#}
#
## Normal HTTP host
#server {
#   listen 80;
#   listen [::]:80 default_server;
#   server_name gitlab.papamk.com; ## 修改成自己的域名；
#   server_tokens off; ## Don't show the nginx version number, a
#   security best practice
#   root /opt/gitlab/embedded/service/gitlab-rails/public;
#
#   ## See app/controllers/application_controller.rb for headers set
#
#   ## Individual nginx logs for this GitLab vhost
#   access_log  /home/wwwlogs/gitlab_access.log; # 根据实际情况
#   修改
#   error_log   /home/wwwlogs/gitlab_error.log; # 根据实际情况
#   修改
#
#   location / {
#   client_max_body_size 0;
#   gzip off;
#
#   ##
#   https://github.com/gitlabhq/gitlabhq/issues/694
#   ## Some requests take more than 30
#   seconds.
#   proxy_read_timeout      300;
#   proxy_connect_timeout   300;
#   proxy_redirect          off;
#
#   proxy_http_version 1.1;
#
#   proxy_set_header
#   Host
#   $http_host;
#   proxy_set_header
#   X-Real-IP
#   $remote_addr;
#   proxy_set_header
#   X-Forwarded-For
#   $proxy_add_x_forwarded_for;
#   proxy_set_header
#   X-Forwarded-Proto
#   $scheme;
#
#   proxy_pass
#   http://gitlab-workhorse;
#    }
#}
