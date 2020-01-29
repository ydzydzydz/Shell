#!/bin/bash

#-------------------------------
# 计算平均分(去掉最高分,最低分)
#-------------------------------

if [ $# -eq 0 ]; then
	echo 请输入成绩单
elif [ ! -f $1 ]; then
	echo 成绩单不存在
else
	sum=`sort $1 | awk '{line[NR]=$0} END {for(i=2; i<=NR-1; i++){sum+=line[i]}; print sum}'`
	num=`cat $1 | awk 'END {print NR-2}'`
	ave=`echo "scale=2;$sum/$num" | bc`
	echo 平均分为 $ave
fi
