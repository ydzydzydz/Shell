#!/bin/bash

#-------------------------
# 检查输入 IP 的合法性
#-------------------------

check_ip(){
	clear
	PS5=$(echo -e "\033[1;33m请输入IP地址: \033[0m")
	while :
	do
		read -p "${PS5}" IP
		echo $IP | grep -Eq "^([0-9]{1,3}\.){3}[0-9]{1,3}$"
		if [ $? -eq 0 ]; then
			FIELD1=$(echo $IP | cut -d. -f 1)
			FIELD2=$(echo $IP | cut -d. -f 2)
			FIELD3=$(echo $IP | cut -d. -f 3)
			FIELD4=$(echo $IP | cut -d. -f 4)
			if [ $FIELD1 -le 255 -a $FIELD2 -le 255 -a $FIELD3 -le 255 -a $FIELD4 -le 255 ]; then
				echo -e "\033[1;32m输入的IP地址合法\033[0m"
				break
			else
				echo -e "\033[1;31m输入的IP地址不合法,请重新输入\033[0m"
			fi
		else
			echo -e "\033[1;31m输入的IP地址不合法,请重新输入\033[0m"
		fi
	done
}

check_ip

exit 0
