#!/bin/bash

#-------------------------
# 查看服务器状态
#-------------------------


while :
do
	clear

	# CPU 负载
	cpu=`uptime | awk '{print $8 $9 $10}'`
	echo -e "CPU 负载\t $cpu"

	# eth0 网卡流量
	up=`ifconfig eth0 | awk '/RX p/{print $5}'`
	down=`ifconfig eth0 | awk '/TX p/{print $5}'`
	echo -e "出站流量\t $up"
	echo -e "入站流量\t $down"

	# 磁盘剩余空间
	disk=`df -h | awk '/\/$/{print $4}'`
	echo -e "剩余空间\t $disk"

	# 内存剩余
	mem=`free -h | awk '/Mem/{print $4}'`
	echo -e "内存剩余\t $mem"

	# 计算机账户总数
	usertotal=`cat /etc/passwd | wc -l`
	echo -e "用户总数\t $usertotal"

	# 登录用户数量
	user=`who | wc -l`
	echo -e "登录用户\t $user"

	# 开启进程总数
	process=`ps aux | wc -l`
	echo -e "进程总数\t $process"

	# 安装软件包总数
	rpmtotal=`rpm -qa | wc -l`
	echo -e "安装软件\t $rpmtotal"

	sleep 1
done
