#!/bin/bash

#----------------------------------------------
# 使用 wsl 开启 windows 上帝模式
# sudo mv shell_30.sh /usr/local/bin/godmode
# sudo chmod +x /usr/local/bin/godmode
# godmode start
#----------------------------------------------

WINDOWS_USERNAME=${WINDOWS_USERNAME:-zz}

case $1 in
	"start")
		mkdir "/mnt/c/Users/${WINDOWS_USERNAME}/Desktop/上帝模式.{ED7BA470-8E54-465E-825C-99712043E01C}"
		;;
	"stop")
		rm -rf "/mnt/c/Users/${WINDOWS_USERNAME}/Desktop/上帝模式.{ED7BA470-8E54-465E-825C-99712043E01C}"
		;;
	*)
		echo $0 '[ start|stop ]'
		exit 1
		;;
esac
