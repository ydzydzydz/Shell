#!/bin/bash

#------------------------------
# 打印进度条
#------------------------------

for i in `seq 500`
do
	sleep 0.01
	[ $[$i%10] -eq 0 ] && echo -ne "\b=" && continue
	[ $[$i%5] -eq 0 ] && echo -ne ">"
done

echo

