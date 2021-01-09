#!/bin/bash

#-------------------------
# Shell 多线程脚本
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
	for num in $(seq -w "${all_num}"); do
		read -u3		# 从FD3中去掉一个回车符，控制线程数量
		{
			echo "${num}"	# 执行命令
			sleep 2		# 模拟执行命令的时间
			echo >&3	# 补回FD3的回车符
		} &
	done
	wait				# 等待所有线程结束再退出脚本
	exec 3>&-			# 关闭FD3
}

#-----------------------------------------------------

start_time=$(date "+%Y-%m-%d %H:%M:%S")

config_thread 5
run_command 1000

end_time=$(date "+%Y-%m-%d %H:%M:%S")

echo -e "开始时间: $start_time"
echo -e "结束时间: $end_time"
