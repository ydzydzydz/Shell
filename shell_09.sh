#!/bin/bash

Dir="/var/www/html/"
IP="192.168.1.1"
PassWord=123456

# ssh 免密认证
ssh-keygen -t rsa -n '' -f ~/.ssh/id_rsa
yum -y install expect &> /dev/null
expect << EOF
spawn ssh-copy-id $IP
expect "(yes/no)?" {send "yes\r"}
expect "password:" {send "$PassWord\r"}
expect "#" {send "exit\r"}
EOF

# rsync 镜像同步
while inotifywait -rqq -e modify,move,create,delete,attrib $Dir
do
	"rsync -az --delete $Dir root@$IP:$Dir" 
	sleep 1
done
