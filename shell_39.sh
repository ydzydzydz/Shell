#!/bin/bash

#-------------------------
# 判断github脚本更新
#-------------------------

#--------- change log start --------
# 1. 增加 change_log
# 2. test change_log
#--------- change log end ----------

sh_ver=v0.0.6
sh_name=${0##*/}

gh_user=ydzydzydz
gh_repo=Shell
gh_branch=master

erro (){
	echo -e "\033[31m[ERRO]\033[0m $(date "+%Y-%m-%d %H:%M:%S") - ${sh_name}:"
}

info (){
	echo -e "\033[32m[INFO]\033[0m $(date "+%Y-%m-%d %H:%M:%S") - ${sh_name}:"
}

warn (){
	echo -e "\033[33m[INFO]\033[0m $(date "+%Y-%m-%d %H:%M:%S") - ${sh_name}:"
}

print_change_log () {
	change_log_start_line=$(wget -qO- https://raw.githubusercontent.com/${gh_user}/${gh_repo}/${gh_branch}/${sh_name} | grep -n "change log start" | awk -F: '{print $1}' | head -n 1)
	change_log_end_line=$(wget -qO- https://raw.githubusercontent.com/${gh_user}/${gh_repo}/${gh_branch}/${sh_name} | grep -n "change log end" | awk -F: '{print $1}' | head -n 1)
	wget -qO- https://raw.githubusercontent.com/${gh_user}/${gh_repo}/${gh_branch}/${sh_name} | sed -n "${change_log_start_line},${change_log_end_line}s/#//p" | while read change_log
	do
		echo -e "$(info) $change_log"
	done
}

check_update () {
	sh_new_ver=$(wget -qO- https://raw.githubusercontent.com/${gh_user}/${gh_repo}/${gh_branch}/${sh_name} | grep "sh_ver" | head -n 1 | awk -F= '{print $2}')
	if [[ -z "$sh_new_ver" ]]; then 
		echo -e "$(erro) 获取更新失败"
	elif [[ "$sh_ver" == "$sh_new_ver" ]]; then
		echo -e "$(info) 当前版本 \033[36m${sh_ver}\033[0m, 无可用更新"
	else
		echo -e "$(info) 当前版本 \033[36m${sh_ver}\033[0m, 有可用更新 \033[32m${sh_new_ver}\033[0m"
		print_change_log
		echo -e "$(warn) 获取更新: wget https://raw.githubusercontent.com/${gh_user}/${gh_repo}/${gh_branch}/${sh_name}"
		echo -e "$(warn) 执行权限: chmod +x $sh_name"
		echo -e "$(warn) 执行脚本: ./$sh_name"
		exit 1
	fi
}

check_update

echo -e "$(info) 执行剩余部分"

exit 0
