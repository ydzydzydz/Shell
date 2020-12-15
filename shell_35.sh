#!/bin/bash

#-------------------------------
# dialog 脚本练习
#-------------------------------

if [ ! -x "$(command -v dialog)" ]; then
	exit 1
fi

# 创建临时文件
results=$(mktemp -t results.XXXXXX)
choices=$(mktemp -t choices.XXXXXX)

function diskspace(){
	df -h > $results
	dialog --title "[Disk Info]" --textbox $results 15 70
}

function whoseon(){
	who > $results
	dialog --title "[User Info]" --textbox $results 12 60
}

function memusage(){
	cat /proc/meminfo > $results
	dialog --title "[Mem Info]" --textbox $results 20 60
}

function interface(){
	ifconfig > $results
	dialog --title "[Interface Info]" --textbox $results 20 80
}

tput civis	# 隐藏光标
while [ 1 ]
do
	# 高度、宽度、一次显示选项个数
	dialog --title "[Dialog Test Shell]" --menu "Sys Admin Menu" 12 40 10 \
		1 "Display disk space"		\
		2 "Display users"		\
		3 "Display memory usage"	\
		4 "Display interface info"	\
		5 "Exit"	2> $choices
	
	# 取消按钮
	if [ $? -eq 1 ]; then
		dialog --title "[Please anwser]" --yesno "\n\nIs this thing on?" 8 30 && break || continue
	fi
	
	# 获取选择
	selection=$(cat $choices)
	case $selection in 
		1)
			diskspace;;
		2)
			whoseon;;
		3)
			memusage;;
		4)
			interface;;
		5)
			dialog --title "[Please anwser]" --yesno "\n\nIs this thing on?" 8 30 && break || continue;;
		*)
			dialog --msgbox "Sorry, invaild selection" 10 30
	esac
done
clear
tput cnorm	# 恢复光标

# 删除临时文件
rm -f $results $choices &> /dev/null
