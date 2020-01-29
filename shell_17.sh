#!/bin/bash

#--------------------------------------
# 查看web服务器连接数、并发数、进程数
#--------------------------------------

while :
do
	clear && tput civis
	echo -e "-------------------------------"
	echo -e "连接数: \t\t `netstat -nat | grep ":80" | grep EST | wc -l`"
	echo -e "并发数: \t\t `netstat -nat | grep ":80" | wc -l`"
	echo -e "进程数: \t\t `ps -ef | grep http | wc -l`"
#	echo -e "进程数: \t\t `ps -ef | grep nginx | wc -l`"
	echo -e "-------------------------------"
	sleep 1
done

