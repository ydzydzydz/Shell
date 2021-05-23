#!/bin/bash

#--------------------------------
# select 脚本练习
#--------------------------------

function diskspace(){
	df -h
}

function whoseon (){
	who
}

function memusage(){
	cat /proc/meminfo
}

function echo_menu (){
	echo -e "\033[$1m$2\033[0m"
}

STTY_SIZE=$(stty size | awk '{print $2}')
PS3_1=$(for i in $(seq $STTY_SIZE); do echo -n "-"; done)
PS3_2=$(echo -e "\n\033[32mEnter option: \033[0m")
PS3=${PS3_1}${PS3_2}

select selection in \
	"$(echo_menu 36 'Display disk sapce')" 		\
	"$(echo_menu 36 'Display loged on users')" 	\
	"$(echo_menu 36 'Display memory usage')" 	\
	"$(echo_menu 31 'Exit program')" 
do
	clear
	# 从标准输入里读取的行，都会保存在变量REPLY里。
	case $REPLY in
		"1")
			diskspace;;
		"2")
			whoseon;;
		"3")
			memusage;;
		"4")
			break;;
		*)
			echo "Sorry, wrong selection"
	esac
done

exit 0
