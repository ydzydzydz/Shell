#!/bin/bash

#------------------------------
# 检测网站是否正常运行
#------------------------------

INFO=`echo -e "\033[32m[ 正常 ]\033[0m"`
ERRO=`echo -e "\033[31m[ 挂了 ]\033[0m"`
WARN=`echo -e "\033[33m[ 提示 ]\033[0m"`

if [ $# -eq 0 ]; then
	echo "$WARN 请输入参数" 1>&2 && exit 1
else
	for i in $*
	do
		curl -s $i -o /dev/null
		[ $? -eq 0 ] && echo "$INFO $i" || echo "$ERRO $i" 1>&2
	done
fi
