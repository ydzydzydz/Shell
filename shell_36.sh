#!/bin/bash

#-------------------------
# Shell 多线程脚本
# 执行脚本后，运行如下命令，查看最大线程数
# watch -t -n 1 'if [ -f ip_list   ]; then 
# 	ps aux | head -n 1; 
# 	for ip in $(cat ip_list); do ps aux | grep $ip | grep -v grep ; done | sort | uniq; 
# 	for i in $(seq $(stty size | awk '"'"'{print $2}'"'"')); do echo -n "-"; done; 
# 	echo "线程数为: $(for ip in $(cat ip_list); do ps aux | grep $ip | grep -v grep ; done | sort | uniq | wc -l)"
# fi'
#-------------------------

config_thread(){
	mkfifo temp_fifofile		# 创建命名管道
	exec 3<>temp_fifofile		# 将FD3指向管道类型
	rm -f temp_fifofile		# 可以删除

	thread_num=$1
	for i in $(seq "${thread_num}"); do
		echo
	done >&3			# 在FD3放置$thread_num个回车
}

run_command(){
	all_num=$1
	for i in $(seq "$all_num"); do
		echo 192.168.1.$i >> ip_list
	done

	for ip in $(cat ip_list); do
		read -u3 		# 从FD3中去掉一个回车符，控制线程数量
		{
			ping -c 20 -W 1 "$ip" &> /dev/null 
			if [ $? -eq 0 ];then
				echo -e "[\033[32msuccess\033[0m] $ip" 
			else
				echo -e "[\033[31mfailure\033[0m] $ip" 1>&2
			fi
			echo >&3	# 补回FD3的回车符
		} &
	done
	wait				# 等待所有线程结束
	exec 3>&-			# 关闭FD3

	rm -rf ip_list
}

print_runtime(){
	echo
	echo "+----------+-------------------+"
	echo "|开始时间: |$start_time|"
	echo "|结束时间: |$end_time|"
	echo "+----------+-------------------+"
}

#-----------------------------------------------------

start_time=$(date "+%Y-%m-%d %H:%M:%S")
trap "rm -rf ip_list; exit" 2		# Ctrl + c 时，删除ip_list
config_thread 5
run_command 20
end_time=$(date "+%Y-%m-%d %H:%M:%S")

print_runtime
