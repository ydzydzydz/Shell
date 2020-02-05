#!/bin/bash

#------------------------------
# 实时显示网速
#------------------------------

tput civis                     # 隐藏光标
trap "tput cnorm && exit" 2    # 回复光标后退出脚本

rx_pre=`ifconfig $1 | awk '/RX packets/{print $3}'`
tx_pre=`ifconfig $1 | awk '/TX packets/{print $3}'`
sleep 1

while :
do
	clear
	rx_next=`ifconfig $1 | awk '/RX packets/{print $3}'`
	tx_next=`ifconfig $1 | awk '/TX packets/{print $3}'`
	rx_speed=$[rx_next-rx_pre]	
	tx_speed=$[tx_next-tx_pre]

	if [ $rx_speed -lt 1024 ]; then
		echo -e "下载速度\t ${rx_speed}B/s"
	elif [ $rx_speed -lt 1048576 ]; then
		rx_speed=`echo "scale=2; ${rx_speed}/1024" | bc`
		echo -e "下载速度\t ${rx_speed}K/s"
	elif [ $rx_speed -lt 1073741824 ]; then
		rx_speed=`echo "scale=2; ${rx_speed}/1048576" | bc`
		echo -e "下载速度\t ${rx_speed}M/s"
	fi

	if [ $tx_speed -lt 1024 ]; then
		echo -e "上传速度\t ${tx_speed}B/s"
	elif [ $tx_speed -lt 1048576 ]; then
		tx_speed=`echo "scale=2; ${tx_speed}/1024" | bc`
		echo -e "上传速度\t ${rx_speed}K/s"
	elif [ $tx_speed -lt 1073741824 ]; then
		tx_speed=`echo "scale=2; ${tx_speed}/1048576" | bc`
		echo -e "上传速度\t ${rx_speed}M/s"
	fi
	rx_pre=$rx_next	
	tx_pre=$tx_next	
	sleep 1
done


