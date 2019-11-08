#!/bin/bash

while :
do
	read -p "请输入一个奇数：" Num
	p=$[Num%2]
	if [ $p -ne 0 ]; then
		echo -e "\033[32m开始打印\033[0m" 
		break
	else
		echo -e "\033[31m重新输入\033[0m"
	fi
done

x=-1
y=$[Num/2+1]
z=$[Num/2+1]

echo_kong (){
	for i in `seq $y`
	do
		echo -n "  "
		sleep 0.2
	done
}

echo_xing (){
	for f in `seq $x`
	do
		echo -n "* "
		sleep 0.2
	done
}

echo "---------------------------"
for n in `seq $Num`
do
	if [ $n -le $z ]; then
		let x+=2; let y-=1
	else
		let x-=2; let y+=1
	fi
	echo_kong
	echo_xing
	echo
done
