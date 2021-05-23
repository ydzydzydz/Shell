#!/bin/bash

#-------------------------
# 判断github脚本更新
#-------------------------

sh_ver=v0.0.1
sh_name=shell_39.sh

gh_user=ydzydzydz
gh_repo=Shell
gh_branch=master

erro=$(echo -e "\033[31m[ERRO]\033[0m $(date "+%Y-%m-%d %H:%M:%S") -")
info=$(echo -e "\033[32m[INFO]\033[0m $(date "+%Y-%m-%d %H:%M:%S") -")
warn=$(echo -e "\033[33m[WARN]\033[0m $(date "+%Y-%m-%d %H:%M:%S") -")

check_update () {
	sh_new_ver=$(wget -qO- https://raw.githubusercontent.com/${gh_user}/${gh_repo}/${gh_branch}/${sh_name} | grep "sh_ver" | head -n 1 | awk -F= '{print $2}')
	if [[ -z "$sh_new_ver" ]]; then 
		echo -e "$erro $sh_name: 获取更新失败"
	elif [[ "$sh_ver" == "$sh_new_ver" ]]; then
		echo -e "$info $sh_name: 无可用更新(\033[32m${sh_new_ver}\033[0m)"
	else
		echo -e "$info $sh_name: 有可用更新(\033[32m${sh_new_ver}\033[0m)"
		echo -e "$warn 获取更新: wget https://raw.githubusercontent.com/${gh_user}/${gh_repo}/${gh_branch}/${sh_name}"
		echo -e "$warn 执行权限: chmod +x $sh_name"
		exit 1
	fi
}

check_update

echo -e "$info 执行剩余部分"

exit 0