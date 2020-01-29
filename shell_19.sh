#!/bin/bash

#-------------------------
# 判断用户是否是管理员
#-------------------------

INFO=`echo -e "\033[32m[ INFO ]\033[0m"`
ERRO=`echo -e "\033[31m[ ERRO ]\033[0m"`
WARN=`echo -e "\033[33m[ WARN ]\033[0m"`

if [ $# -eq 0 ]; then
	echo " $WARN Please enter a user name"
else
	for i in $*
	do
		id -u $i &> /dev/null
		if [ $? -ne 0 ]; then
			echo "$ERRO $i no such user"
		else
			uid=`id -u $i`
			if [ $uid -eq 0 ]; then
				echo "$INFO $i is admin"
			else
				echo "$WARN $i is not admin"
			fi
		fi
	done
fi
