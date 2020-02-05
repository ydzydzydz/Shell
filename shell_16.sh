#!/bin/bash

#------------------------------
# 检测网站是否正常运行
# bash shell_16.sh url.list
#------------------------------

INFO=`echo -e "\033[32m[ 正常 ]\033[0m"`
ERRO=`echo -e "\033[31m[ 异常 ]\033[0m"`
WARN=`echo -e "\033[33m[ 警告 ]\033[0m"`
TIME=`date "+%Y-%m-%d %H:%M:%S"`

if [ $# -eq 0 ]; then
	echo "$WARN 请输入文件" 1>&2 && exit 1
elif [ ! -f $1 ]; then
	echo "$WARN 文件不存在" 1>&2 && exit 1
else
	for i in `cat $1`
	do
		curl -s $i -o /dev/null
		[ $? -eq 0 ] && echo "$INFO $i $TIME" || echo "$ERRO $i $TIME" 1>&2
	done
fi

