#!/bin/bash

#-----------------------------------
# 修改ssh端口号
#-----------------------------------

Error=`echo -e "\033[31m[错误]\033[0m"`
Info=`echo -e "\033[32m[信息]\033[0m"`
Warn=`echo -e "\033[33m[警告]\033[0m"`

# 判断当前用户
[ $UID -ne 0 ] && echo "${Error} 请以管理员身份执行脚本:[su - root]" && exit

# 获取端口
while :
do
	echo -n "${Warn} 请输入正确的端口号:[0-65535] " && read NewPort
	[ -z $NewPort ] && echo "${Error} 请输入一个端口" && continue
	[ $NewPort -lt 0 ] && echo "${Error} 请输入正确端口" && continue
	[ $NewPort -gt 65535 ] && echo "${Error} 请输入正确端口" && continue
	ss -antulp | grep -q :${NewPort}\  && echo "${Error} 端口正在使用,请更换" && continue
	ss -antulp | grep -q :${NewPort}\  || echo "${Info} 端口设定成功: [$NewPort]" && break
done

# 修改ssh配置文件
sed  -ri "s/#?Port\ [0-9]{1,5}/Port $NewPort/" /etc/ssh/sshd_config
grep -q Port\ $NewPort /etc/ssh/sshd_config
[ $? -eq 0 ] && echo "${Info} ssh配置修改成功" || echo "${Error} ssh配置修改失败"

# 修改SELinux策略
/usr/sbin/sestatus -v | grep -q enabled
if [ $? -eq 0 ];then
	which semanage &> /devnull || yum -y install policycoreutils-python &> /dev/null
	semanage port -a -t ssh_port_t -p tcp $NewPort &> /dev/null && echo "${Info} SELinux策略修改成功" || echo "${Error} SELinux策略修改失败"
else
	echo "${Warn} 未开启SELinux"
fi

# 防火墙放行端口
which firewall-cmd &> /dev/null
if [ $? -eq 0 ];then
	firewall-cmd --state &> /dev/null
	if [ $? -eq 0 ];then
		firewall-cmd --zone=public --add-port=$NewPort/tcp --permanent &> /dev/null && echo "${Info} firewall放行端口成功" || echo "${Error} firewall放行端口失败"
		firewall-cmd --reload &> /dev/null && echo "${Info} firewall配置重载成功" || echo "${Error} firewall重载配置失败"
	else
		echo "${Warn} 未开启firewall"
	fi
else
	echo "${Warn} 未安装firewall-cmd"
fi

# 后悔药
echo -e "${Info} 即将重启ssh服务"
echo -ne "${Warn} "
Wait=5
for i in {1..5}
do
	echo -ne "${Wait}..."
	sleep 1
	let Wait--
done
echo ""

# 重启ssh服务
systemctl restart sshd && echo "${Info} ssh服务重启成功" || echo "${Error} ssh服务重启失败"
echo "${Info} ssh -p $NewPort user@hostname"
