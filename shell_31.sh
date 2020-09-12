#!/bin/bash

#------------------------------
# expect 脚本练习
# expect + ssh + sudo
#------------------------------

set -e

ip="192.168.1.100"
username="zz"
password="123456"
rmfile="/root/test"

/usr/bin/expect << EOF
	set time 3
	spawn ssh ${username}@${ip}
	expect {
		"*yes/no" { send "yes\r"; exp_continue }
		"*password:" { send "${password}\r" }
	}
	expect "*$"
	send "sudo su root\r"
	expect "password"
	send "${password}\r"
	expect "*#"
	send "rm -rf ${rmfile}\r"
	expect "*#"
	send "exit\r"
	expect "*$"
	send "exit\r"
	expect eof
EOF
