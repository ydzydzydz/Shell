#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
jenkins_domain=192.168.1.67:8008

versionFile=/var/www/deploy/live_ver
app_dir=/var/www/html/nsd1909
newVersion=`curl -s -L  http://$jenkins_domain/deploy/live_ver`
[ -f "$versionFile" ] && backVersion=`cat ${versionFile}.bak`

ERRO=`echo -e "\033[31;1m[ ERRO ]\033[0m"`
INFO=`echo -e "\033[32;1m[ INFO ]\033[0m"`
WARN=`echo -e "\033[33;1m[ WARN ]\033[0m"`

check_up (){
	[ -f $versionFile ] && oldVersion=`cat $versionFile`
	if [ $newVersion != "$oldVersion" ]; then
		[ $# -eq 0 ] && echo -e "${oldVersion} --> \033[32m${newVersion}\033[0m"
		return 1
	else
		return 0
	fi
}

get_tar (){
	wget http://${jenkins_domain}/deploy/pkgs/myweb-${newVersion}.tar.gz -O /var/www/download/myweb-${newVersion}.tar.gz &> /dev/null
	if [ $? -eq 0 ]; then	
		echo -e "$INFO 下载成功" 
	else
		echo -e "$ERRO 下载失败" 1>&2
		exit 1
	fi	
}

check_md5 (){
	md5=`curl -s -L  http://${jenkins_domain}/deploy/pkgs/myweb-${newVersion}.tar.gz.md5`
	tarmd5=`md5sum /var/www/download/myweb-${newVersion}.tar.gz | awk '{print $1}'`
	if [ $tarmd5 == $md5 ] ;then
		echo -e "$INFO 校验成功"
	else
		echo -e "$ERRO 校验失败" 1>&2
		exit 1
	fi
}

deploy_web (){
	tar -xf /var/www/download/myweb-${newVersion}.tar.gz -C /var/www/deploy/ &> /dev/null
	if [ $? -eq 0 ] ;then
		echo -e "$INFO 解压成功"
	else
		echo -e "$ERRO 解压失败" 1>&2
		exit 1
	fi

	if [ -L $app_dir ]; then
		rm -rf $app_dir
	fi
	
	ln -s /var/www/deploy/myweb-${newVersion} $app_dir
	if [ $? -eq 0 ] ;then
		echo -e "$INFO 部署成功"
	else
		echo -e "$ERRO 部署失败" 1>&2
		exit 1
	fi

	[ -f $versionFile ] && cat $versionFile > ${versionFile}.bak
	echo $newVersion > $versionFile
}

rewoke_web (){
	if [ ! -e ${versionFile}.bak ] ;then
		echo -e "$ERRO 回滚" 1>&2
		exit 1	
	fi
	backVersion=`cat ${versionFile}.bak`
	rm -rf $app_dir
	ln -s /var/www/deploy/myweb-${backVersion} $app_dir
	echo -e "$INFO 回滚成功" 
	\cp ${versionFile} ${versionFile}.bak
	echo "${backVersion}" > ${versionFile}
}

show_menu (){
	while :
	do
		clear
		echo -e "1: 更新\t" $(check_up) 
		echo -e "2: 回滚\t" ${backVersion}
		echo -e "3: 退出\t"
		echo "-------------------------------------"
       		read -p "请选择： " choice
        	if [[ $choice =~ ^[1-3]$ ]]; then
                	break
        	fi
	done
}

run_choice (){
	if [[ $choice == 1 ]]; then
		clear
		if check_up 0; then
			echo -e "$WARN 无需更新" && exit 1
		fi
		get_tar
		check_md5
		deploy_web
	elif [[ $choice == 2 ]]; then
		clear
		rewoke_web
	else
		exit 0
	fi
}

show_menu
run_choice
