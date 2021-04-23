#!/bin/bash

usage (){
	printf "\n"
	printf "Usage: ${0##*/} [OPTION]\n\n"
	printf "%-4s %-18s %s\n" " " "-a, --all"	"显示所有登录失败的IP，次数"
	printf "%-4s %-18s %s\n" " " "-l, --limit"	"显示所有登录失败次数大于指定值的IP"
	printf "%-4s %-18s %s\n" " " " "		"默认显示登录失败次数大于100的IP"
	printf "%-4s %-18s %s\n" " " "-h, --help"	"显示脚本帮助信息"
	printf "\n"
}

awk_lastb () {
	LIMIT=$1
	lastb | awk '{print $3}' | \
	egrep "([0-9]{1,3}.){3}[0-9]{1,3}" | \
	awk -v awkLimit="$LIMIT" '{ip[$1]++}END{for (i in ip){if (ip[i] > awkLimit) {print i, ip[i]}}}' | \
	column -t | sort -nrk 2
}

err_msg () {
	echo -e "\033[31m$@\033[0m" 1>&2
}

#############################################################################################

if [ "$UID" -ne 0 ]; then
	err_msg "请使用 root 账户运行此脚本"
fi

case $1 in 
	("-h"|"--help")
		usage
		;;
	("-a"|"--all")
		awk_lastb 0
		;;
	("-l"|"--limit")
		if [ -n "$2" ];then
			LIMIT=$2
			if [[ ! $LIMIT -gt 0 ]]; then
				err_msg "请输入正确数字"
				exit 1
			fi
		else 
			LIMIT=100
		fi 
		awk_lastb $LIMIT
		;;
	(*)
		bash $0 -h
		;;
esac

exit 0
