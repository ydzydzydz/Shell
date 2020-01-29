#!/bin/bash

#-----------------------
# 9*9 乘法表
#-----------------------

for i in `seq 9`
do
	for j in `seq $i`
	do
		num=$[i*j]
		if [ $num -lt 10 ]; then
			num="$num "
		fi
		echo -n "$i*$j=$num "
	done
	echo
done
