#!/bin/bash

usage (){
	printf "\n"
	printf "Usage: ${0##*/} [OPTION] [NUMBER]\n\n"
	printf "%-4s %-18s %s\n" " " "-a, --all"	"显示所有登录失败的IP，次数"
	printf "%-4s %-18s %s\n" " " "-b, --block"	"禁止登录失败的IP (默认禁止所有)"
	printf "%-4s %-18s %s\n" " " "-c, --clear"	"清空所有lastb记录"
	printf "%-4s %-18s %s\n" " " "-l, --limit"	"显示所有登录失败次数大于指定值的IP"
	printf "%-4s %-18s %s\n" " " " "		"默认显示登录失败次数大于100的IP"
	printf "%-4s %-18s %s\n" " " "-h, --help"	"显示脚本帮助信息"
	printf "\n"
}

awk_lastb (){
	LIMIT=$1
	OUTPUT=$(mktemp output.XXXXXX)
	lastb | awk '{print $3}' | \
	egrep "([0-9]{1,3}.){3}[0-9]{1,3}" | \
	awk -v awkLimit="$LIMIT" '{ip[$1]++} END {
		for (i in ip){
			if (ip[i] >= awkLimit) {
				print i, ip[i]
			}
		} 
	}' | \
	column -t | sort -nrk 2 > $OUTPUT
	if [[ "$(cat $OUTPUT | wc -l)" -eq 0 ]]; then
		rm -rf $OUTPUT
		err_msg "没有匹配到记录"
	else
		cat $OUTPUT
		rm -rf $OUTPUT
	fi
}

block_ip (){
	DATE=$(date "+%F")
	TIME=$(date "+%T")
		
	[ ! -d /var/log/hostsdeny ] && mkdir -p /var/log/hostsdeny
	[ ! -f /var/log/hostsdeny/lastb.log.$DATE ] && touch /var/log/hostsdeny/lastb.log.$DATE

	echo "# $DATE $TIME" 	>> /var/log/hostsdeny/lastb.log.$DATE
	bash $0 -a 		>> /var/log/hostsdeny/lastb.log.$DATE
	echo 			>> /var/log/hostsdeny/lastb.log.$DATE

	LIMIT=$1
	FILE=/etc/hosts.deny
	IP_LIST=$(egrep -v "^#|^$" /var/log/hostsdeny/lastb.log.$DATE | awk -v awkLimit="$LIMIT" '{if ($2 >= awkLimit) {print $1}}' | uniq)
	
	for ip in $IP_LIST
	do
		egrep -q "^sshd:${ip}:deny" $FILE || echo "sshd:${ip}:deny" >> $FILE
	done
}

err_msg (){
	echo -e "\033[31m$@\033[0m" 1>&2
	exit 1
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
		LIMIT=0
		awk_lastb $LIMIT
		;;
	("-b"|"--block")
		if [ -n "$2" ];then
			LIMIT=$2
			if [[ ! $LIMIT -ge 0 ]]; then
				err_msg "请输入正确数字"
			fi
		else 
			LIMIT=0
		fi 
		block_ip $LIMIT
		;;
	("-c"|"--clear")
		echo > /var/log/btmp
		;;
	("-l"|"--limit")
		if [ -n "$2" ];then
			LIMIT=$2
			if [[ ! $LIMIT -ge 0 ]]; then
				err_msg "请输入正确数字"
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
