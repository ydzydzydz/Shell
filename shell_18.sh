#!/bin/bash

#------------------------------
# 统计 Apache 日志中客户端 IP
#------------------------------

log="/var/log/httpd/access_log"

while :
do
	tput civis
	clear
	awk '{ip[$1]++}END{for (i in ip){print ip[i],"\t\t",i}}' $log | sort -nr | awk 'BEGIN{print "Sort","\t","TIME","\t\t","IP\n""-----------------------------------------"}{print NR,"\t",$0}' | head -n 12
	sleep 1
done
