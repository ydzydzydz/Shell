#!/bin/bash

#------------------------------
# 统计 Apache 日志中客户端 IP
#------------------------------

log="/var/log/httpd/access_log"

check_log (){
	while :
	do
		tput civis
		trap "tput cnorm && exit" 2
		clear
		awk '{ip[$1]++}END{for (i in ip){print ip[i],"\t\t",i}}' $log | sort -nr | awk 'BEGIN{print "Sort","\t","TIME","\t\t","IP\n""-----------------------------------------"}{print NR,"\t",$0}' | head -n 12
		sleep 1
	done
}

if [ ! -e $log ]; then
	echo -e "\033[31m日志文件不存在\033[0m"
else
	check_log
fi
