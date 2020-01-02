#!/bin/bash

#------------------------------------------------------
# 克隆虚拟机
# 镜像模板: /var/lib/libvirt/images/.node_base.qcow2
# 配置模板: /var/lib/libvirt/images/.node_base.xml
#------------------------------------------------------

img_dir=/var/lib/libvirt/images
config_dir=/etc/libvirt/qemu

INFO=`echo -e "\033[32m[信息]\033[0m"`
WARN=`echo -e "\033[33m[警告]\033[0m"`
ERRO=`echo -e "\033[31m[错误]\033[0m"`

#-----------------------检查当前用户---------------------------
function check_user (){
	if [ $UID -ne 0 ];then
		echo "$WARN 请以管理员身份执行脚本" 1>&2 && exit 1
	fi
}

#-----------------------检查镜像配置---------------------------
function check_temp (){
	if [ ! -f $img_dir/.node_base.qcow2 ]; then
		echo "$ERRO 镜像模板不存在" 1>&2 && exit 1
	fi
	if [ ! -f $img_dir/.node_base.xml ]; then
		echo "$ERRO 配置模板不存在" 1>&2 && exit 1
	fi
}

#-----------------------创建虚拟机---------------------------
function clone_kvm (){
	qemu-img create -f qcow2 -b $img_dir/.node_base.qcow2 $img_dir/$i.img 20G &> /dev/null
	cp $img_dir/.node_base.xml $config_dir/$i.xml
	sed -i "2s/node_base/$i/" $config_dir/$i.xml
	sed -i "26s/node_base.img/$i.img/" $config_dir/$i.xml
	virsh define $config_dir/$i.xml > /dev/null
	[ $? -eq 0 ] && echo "$INFO 虚拟机${i}创建成功" || echo "$ERRO 虚拟机${i}创建失败"
}

#----------------------------------------------------------------------
if [ -z $1 ];then
	echo "$ERRO 请输入主机名" 1>&2 && exit 1
else
	check_user
	for i in $*
	do      
		if [ -f $img_dir/$i.img ];then
			echo "$WARN 虚拟机${i}已存在" 1>&2
		elif [ -f $config_dir/$i.xml ];then
			echo "$WARN 虚拟机${i}已存在" 1>&2
		else
			check_temp
			clone_kvm
		fi
	done
fi
exit 0
