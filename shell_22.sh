#!/bin/bash

#------------------------------
# 实时显示网速
#------------------------------

check_eth (){
	if [ $# -eq 0 ]; then
		echo -e "输入正确网卡名\n`ifconfig | awk -F: '/flags=/{print $1}'`" && exit 1
	fi
	ifconfig $1 &> /dev/null
	if [ $? -ne 0 ]; then
		echo -e "输入正确网卡名\n`ifconfig | awk -F: '/flags=/{print $1}'`" && exit 1
	fi
}

set_pre (){
	if [ -z "$rx_pre" ]; then
		rx_pre=`ifconfig $1 | awk '/RX packets/{print $3}'`
		tx_pre=`ifconfig $1 | awk '/TX packets/{print $3}'`
	else
		rx_pre=$rx_next
		tx_pre=$tx_next
	fi
}

set_speed (){
	rx_next=`ifconfig $1 | awk '/RX packets/{print $3}'`
	tx_next=`ifconfig $1 | awk '/TX packets/{print $3}'`
	rx_speed=$[rx_next-rx_pre]	
	tx_speed=$[tx_next-tx_pre]
}

echo_rx (){
	if [ $rx_speed -lt 1024 ]; then
		echo -e "| 下载速度 $down \t| ${rx_speed}B/s"; tput cup 3 31; echo "|"
	elif [ $rx_speed -lt 1048576 ]; then
		rx_speed=`echo "scale=2; ${rx_speed}/1024" | bc`
		echo -e "| 下载速度 $down \t| ${rx_speed}K/s"; tput cup 3 31; echo "|"
	elif [ $rx_speed -lt 1073741824 ]; then
		rx_speed=`echo "scale=2; ${rx_speed}/1048576" | bc`
		echo -e "| 下载速度 $down \t| ${rx_speed}M/s"; tput cup 3 31; echo "|"
	fi
}

echo_tx (){
	if [ $tx_speed -lt 1024 ]; then
		echo -e "| 上传速度 $up \t| ${tx_speed}B/s"; tput cup 4 31; echo "|"
	elif [ $tx_speed -lt 1048576 ]; then
		tx_speed=`echo "scale=2; ${tx_speed}/1024" | bc`
		echo -e "| 上传速度 $up \t| ${rx_speed}K/s"; tput cup 4 31; echo "|"
	elif [ $tx_speed -lt 1073741824 ]; then
		tx_speed=`echo "scale=2; ${tx_speed}/1048576" | bc`
		echo -e "| 上传速度 $up \t| ${rx_speed}M/s"; tput cup 4 31; echo "|"
	fi
}

up_down (){
	time=`date +%S`
	if [ `expr $time % 2` -eq 0 ]; then
		up=`echo -e "\033[31m↑\033[0m"`
		down=""
	else
		up=""
		down=`echo -e "\033[32m↓\033[0m"`
	fi
}

speed_table (){
	echo -e "+---------------+--------------+"
	echo -e "| 监控网卡 \033[32m↓\033[0m\033[31m↑\033[0m\t| $1"; tput cup 1 31; echo "|"
	echo -e "+---------------+--------------+"
	echo_rx
	echo_tx
	echo -e "+---------------+--------------+"
}

tput civis                     # 隐藏光标
trap "tput cnorm && exit" 2    # 回复光标后退出脚本

check_eth $1
while :
do
	set_pre $1
	sleep 1
	clear
	up_down
	set_speed $1
	speed_table $1
done

