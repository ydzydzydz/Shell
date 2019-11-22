#!/bin/bash

#-------------------------------
# LVS 调度服务器健康检查脚本
#-------------------------------

VIP=192.168.4.15:80
RIP1=192.168.4.100
RIP2=192.168.4.200

while :
do
	for IP in $RIP1 $RIP2
	do
		curl -s http://$IP &> /dev/null
		if [ $? -eq 0 ]; then
			ipvsadm -Ln | grep -q $IP || ipvsadm -a -t $VIP -r $IP
		else
			ipvsadm -Ln | grep -q $IP && ipvsadm -d -t $VIP -r $IP
		fi
	done
	sleep 1
done
