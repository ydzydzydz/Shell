#!/bin/bash

#------------------------------
# printf 脚本练习
# 格式化输出表格
#------------------------------

devices=`ifconfig | awk -F": flags" '/flags/ {print $1}'`

devices_max_length=`ifconfig | awk -F":" '/flags/ {if(length($1)>max_length)max_length=length($1)} END{if(max_length>7){print max_length}else{print "7"}}'`
netmask_max_length=`ifconfig | awk '/netmask / {if (length($4)>max_length) max_length=length($4)} END{if(max_length>7){print max_length}else{print "7"}}'`
ipv4_max_length=`ifconfig | awk '/inet / {if (length($2)>max_length) max_length=length($2)} END{if(max_length>4){print max_length}else{print "4"}}'`
ipv6_max_length=`ifconfig | awk '/inet6/ {if (length($2)>max_length) max_length=length($2)} END{if(max_length>4){print max_length}else{print "4"}}'`

length0="-"
length1=""; for i in `seq $devices_max_length`; do length1=${length1}${length0}; done
length2=""; for i in `seq $ipv4_max_length`; do length2=${length2}${length0}; done
length3=""; for i in `seq $netmask_max_length`; do length3=${length3}${length0}; done
length4=""; for i in `seq $ipv6_max_length`; do length4=${length4}${length0}; done

printf_usage(){
	printf "\n"
	printf "Usage: $1 [OPTION] [INTERFACE]\n\n"
	printf "%-4s %-18s %s\n" " " "-4, --ipv4"      "only display ipv4 like a table"
	printf "%-4s %-18s %s\n" " " "-6, --ipv6"      "only display ipv6 like a table"
	printf "%-4s %-18s %s\n" " " "-a, --all"       "display all devices ip info like a table"
	printf "%-4s %-18s %s\n" " " "-i, --interface" "only display the specified interface ip ($1 -i eth0 lo ...)"
	printf "%-4s %-18s %s\n" " " "-l, --list"      "display all devices"
	printf "%-4s %-18s %s\n" " " "-h, --help"      "display this help and exit"
	printf "%-4s %-18s %s\n" " " "-g"              "display all devices ip like a table"
	printf "%-4s %-18s %s\n" " " "-G"              "vertical display all devices ip like a table"
	printf "\n"
	printf "%-8s %s\n" "Desc:"   "display all devices ip like a table"
	printf "%-8s %s\n" "Author:" "ZHUANGZHUANG <mail@zhuangzhuang.ml>"
	printf "%-8s %s\n" "Date:"   "2020-10-07"
	printf "\n"
}

printf_devices_ip(){
	for i in $devices; do
		ipv4=`ifconfig $i | awk '/inet / {print $2}'`
		ipv6=`ifconfig $i | awk '/inet6/ {print $2}'`
		netmask=`ifconfig $i | awk '/netmask / {print $4}'`
		if [[ `ifconfig $i | awk '/inet6/ {i++} END{print i}'` -gt 1   ]]; then
			for x in $ipv6; do
				printf "%s %-${devices_max_length}s %s %-${ipv4_max_length}s %s %-${netmask_max_length}s %s %-${ipv6_max_length}s %s\n" "|" "$i" "|" "$ipv4" "|" "$netmask" "|" "$x" "|"
			done
		else
			printf "%s %-${devices_max_length}s %s %-${ipv4_max_length}s %s %-${netmask_max_length}s %s %-${ipv6_max_length}s %s\n" "|" "$i" "|" "$ipv4" "|" "$netmask" "|" "$ipv6" "|"
		fi
	done
}

printf_table(){
	printf "\n"
	printf "%s %-${devices_max_length}s %s %-${ipv4_max_length}s %s %-${netmask_max_length}s %s %-${ipv6_max_length}s %s\n" "+" "${length1}" "+" "${length2}" "+" "${length3}" "+" "${length4}" "+"
	printf "%s %-${devices_max_length}s %s %-${ipv4_max_length}s %s %-${netmask_max_length}s %s %-${ipv6_max_length}s %s\n" "|" "DEVICES" "|" "IPV4" "|" "NETMASK" "|" "IPV6" "|"
	printf "%s %-${devices_max_length}s %s %-${ipv4_max_length}s %s %-${netmask_max_length}s %s %-${ipv6_max_length}s %s\n" "+" "${length1}" "+" "${length2}" "+" "${length3}" "+" "${length4}" "+"
	printf_devices_ip
	printf "%s %-${devices_max_length}s %s %-${ipv4_max_length}s %s %-${netmask_max_length}s %s %-${ipv6_max_length}s %s\n" "+" "${length1}" "+" "${length2}" "+" "${length3}" "+" "${length4}" "+"
	printf "\n"


}

printf_table_2(){
	max_length=$netmask_max_length
	if [[ $max_length -lt $ipv4_max_length ]]; then
		max_length=$ipv4_max_length
	fi
	if [[ $max_length -lt $ipv6_max_length ]]; then
		max_length=$ipv6_max_length
	fi

	length5=""; for i in `seq $max_length`; do length5=${length5}${length0}; done

	for i in $devices; do
		ipv4=`ifconfig $i | awk '/inet / {print $2}'`
		ipv6=`ifconfig $i | awk '/inet6/ {print $2}'`
		netmask=`ifconfig $i | awk '/netmask / {print $4}'`
		printf "\n"
		printf "%s %-7s %s %-${max_length}s %s %s\n" "+" "-------" "+" "$length5" "+"
		printf "%s %-7s %s %-${max_length}s %s %s\n" "|" "DEVICES" "|" "$i" "|"
		printf "%s %-7s %s %-${max_length}s %s %s\n" "|" "IPV4" "|" "$ipv4" "|"
		printf "%s %-7s %s %-${max_length}s %s %s\n" "|" "NETMASK" "|" "$netmask" "|"
		if [[ `ifconfig $i | awk '/inet6/ {i++} END{print i}'` -gt 1   ]]; then
			for x in $ipv6; do
				printf "%s %-7s %s %-${max_length}s %s %s\n" "|" "IPV6" "|" "$x" "|"
			done
		else
			printf "%s %-7s %s %-${max_length}s %s %s\n" "|" "IPV6" "|" "$ipv6" "|"
		fi
		printf "%s %-7s %s %-${max_length}s %s %s\n" "+" "-------" "+" "$length5" "+"
		printf "\n"
	done
}

printf_ipv4(){
	printf "%s %-${devices_max_length}s %s %-${ipv4_max_length}s %s\n" "+" "$length1" "+" "$length2" "+"
	printf "%s %-${devices_max_length}s %s %-${ipv4_max_length}s %s\n" "|" "DEVICES" "|" "IPV4" "|"
	printf "%s %-${devices_max_length}s %s %-${ipv4_max_length}s %s\n" "+" "$length1" "+" "$length2" "+"
	for i in $devices; do
		ipv4=`ifconfig $i | awk '/inet / {print $2}'`
		printf "%s %-${devices_max_length}s %s %-${ipv4_max_length}s %s\n" "|" "$i" "|" "$ipv4" "|"
	done
	printf "%s %-${devices_max_length}s %s %-${ipv4_max_length}s %s\n" "+" "$length1" "+" "$length2" "+"
}

printf_ipv6(){
	printf "%s %-${devices_max_length}s %s %-${ipv6_max_length}s %s\n" "+" "$length1" "+" "$length4" "+"
	printf "%s %-${devices_max_length}s %s %-${ipv6_max_length}s %s\n" "|" "DEVICES" "|" "IPV6" "|"
	printf "%s %-${devices_max_length}s %s %-${ipv6_max_length}s %s\n" "+" "$length1" "+" "$length4" "+"
	for i in $devices; do
		ipv6=`ifconfig $i | awk '/inet6/ {print $2}'`
		if [[ `ifconfig $i | awk '/inet6/ {i++} END{print i}'` -gt 1  ]]; then
			for x in $ipv6; do
				printf "%s %-${devices_max_length}s %s %-${ipv6_max_length}s %s\n" "|" "$i" "|" "$x" "|"
			done
		else
			printf "%s %-${devices_max_length}s %s %-${ipv6_max_length}s %s\n" "|" "$i" "|" "$ipv6" "|"
		fi
	done
	printf "%s %-${devices_max_length}s %s %-${ipv6_max_length}s %s\n" "+" "$length1" "+" "$length4" "+"
}

printf_devices(){
	printf "%s %-${devices_max_length}s %s\n" "+" "$length1" "+"
	printf "%s %-${devices_max_length}s %s\n" "|" "DEVICES" "|"
	printf "%s %-${devices_max_length}s %s\n" "+" "$length1" "+"
	for i in $devices; do
		printf "%s %-${devices_max_length}s %s\n" "|" "$i" "|"
	done
	printf "%s %-${devices_max_length}s %s\n" "+" "$length1" "+"
}

printf_interface(){
	printf "%s %-${devices_max_length}s %s %-${ipv4_max_length}s %s %-${netmask_max_length}s %s %-${ipv6_max_length}s %s\n" "+" "${length1}" "+" "${length2}" "+" "${length3}" "+" "${length4}" "+"
	printf "%s %-${devices_max_length}s %s %-${ipv4_max_length}s %s %-${netmask_max_length}s %s %-${ipv6_max_length}s %s\n" "|" "DEVICES" "|" "IPV4" "|" "NETMASK" "|" "IPV6" "|"
	printf "%s %-${devices_max_length}s %s %-${ipv4_max_length}s %s %-${netmask_max_length}s %s %-${ipv6_max_length}s %s\n" "+" "${length1}" "+" "${length2}" "+" "${length3}" "+" "${length4}" "+"
	while [ $# != 1 ];do
		shift
		`ifconfig $1 &> /dev/null` || continue
		ipv4=`ifconfig $1 | awk '/inet / {print $2}'`
		ipv6=`ifconfig $1 | awk '/inet6/ {print $2}'`
		netmask=`ifconfig $1 | awk '/netmask / {print $4}'`
		if [[ `ifconfig $1 | awk '/inet6/ {i++} END{print i}'` -gt 1 ]]; then
			for x in $ipv6; do
				printf "%s %-${devices_max_length}s %s %-${ipv4_max_length}s %s %-${netmask_max_length}s %s %-${ipv6_max_length}s %s\n" "|" "$1" "|" "$ipv4" "|" "$netmask" "|" "$x" "|"
			done
		else
			printf "%s %-${devices_max_length}s %s %-${ipv4_max_length}s %s %-${netmask_max_length}s %s %-${ipv6_max_length}s %s\n" "|" "$1" "|" "$ipv4" "|" "$netmask" "|" "$ipv6" "|"
		fi
	done
	printf "%s %-${devices_max_length}s %s %-${ipv4_max_length}s %s %-${netmask_max_length}s %s %-${ipv6_max_length}s %s\n" "+" "${length1}" "+" "${length2}" "+" "${length3}" "+" "${length4}" "+"
}

case $1 in 
	("-4"|"--ipv4")
		printf_ipv4
		;;
	("-6"|"--ipv6")
		printf_ipv6
		;;
	("-l"|"--list")
		printf_devices
		;;
	("-i"|"--interface")
		printf_interface $@
		;;
	("-h"|"--help")
		printf_usage ${0##*/}
		;;
	("-g"|"-a"|"--all")
		printf_table
		;;
	("-G")
		printf_table_2	
		;;
	(*)
		printf_table
esac


