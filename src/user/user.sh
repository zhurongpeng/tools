#!/bin/sh

if [ $1 ]; then
    user=$1
else
    user="www"
fi

if [ $2 ]; then
    group=$2
else
    group="www"
fi

egrep "^$group" /etc/group

if [ $? -ne 0 ]
then
    sudo -s groupadd $group
fi

egrep "^$user" /etc/passwd

if [ $? -ne 0 ]
then
    sudo -s useradd -M -g $group $user
fi

