#!/bin/bash

#--------------------------
# 进制转换脚本练习
# 十六进制转换IP地址
#--------------------------


printf "\n" && read -p "请输入十六进制数字(0xFFFFFFFF): " hexip && printf "\n"

hextoip() {
	hex=$1 
	printf "[ %s ] 转换得到的IP地址是: " $hexip
	printf "\033[32m%d%s\033[0m" 0x${hex:0:2} "." 2> /dev/null
	printf "\033[32m%d%s\033[0m" 0x${hex:2:2} "." 2> /dev/null
	printf "\033[32m%d%s\033[0m" 0x${hex:4:2} "." 2> /dev/null
	printf "\033[32m%d\033[0m\n\n" 0x${hex:6:2} 2> /dev/null

}

hextoip ${hexip#*x}
