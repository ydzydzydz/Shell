#!/bin/bash

#------------------------------
# Nginx 服务管理脚本
#------------------------------

nginx_status (){
	netstat -antulp | grep 80
}

nginx_start (){
	/usr/local/nginx/sbin/nginx
}

nginx_stop (){
	/usr/local/nginx/sbin/nginx -s stop
}

nginx_reload (){
	/usr/local/nginx/sbin/nginx -s reload
}


case $1 in
	start|k)
		nginx_start && echo "Nginx 启动成功";;
	stop|g)
		nginx_stop && echo "Nginx 关闭成功";;
	reload|r)
		nginx_reload && echo "Nginx 配置重载";;
	status|c)
		nginx_status && echo "Nginx 已经启动" || echo "Nginx 未启动";;
	*)
		echo "请输入正确参数[ start|stop|status|reload ]"
esac
