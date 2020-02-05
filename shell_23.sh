#!/bin/bash

#--------------------------
# 一键部署 Zabbix 监控服务
#--------------------------


#-----------------------拷贝yum源--------------------------
if [ ! -f /etc/yum.repos.d/nginx.repo ]; then
echo "
[nginx_repo]
name=loaclrepo
baseurl="ftp://192.168.1.250/localrepo/"
enable=1
gpgcheck=0
" > /etc/yum.repos.d/nginx.repo
yum clean all && yum repolist
fi

#-----------------------部署lnmp--------------------------
yum -y install gcc pcre-devel  openssl-devel nginx php php-mysql php-fpm mariadb mariadb-devel mariadb-server 
sed -i "s/#pid        logs\/nginx.pid;/pid       \/var\/run\/nginx.pid;/" /usr/local/nginx/conf/nginx.conf
sed -i "45s/index  index.html index.htm;/index  index.php  index.html index.htm;/" /usr/local/nginx/conf/nginx.conf
sed -i "65,71s/#//" /usr/local/nginx/conf/nginx.conf
sed -i  "/SCRIPT_FILENAME/d" /usr/local/nginx/conf/nginx.conf
sed -i "s/fastcgi_params/fastcgi.conf/" /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx -t || exit
systemctl restart  mariadb  php-fpm nginx
systemctl enable  mariadb  php-fpm nginx

#-----------------------部署zabbix--------------------------
yum -y install net-snmp-devel curl-devel libevent-devel  
tar -xvf /root/zabbix-3.4.4.tar.gz && cd /root/zabbix-3.4.4 && ./configure  --enable-server --enable-proxy --enable-agent --with-mysql=/usr/bin/mysql_config --with-net-snmp --with-libcurl && make && make install
mysql -e "show databases" | grep zabbix 
if [ $? -ne 0 ];then
mysql -e "create database zabbix character set utf8;"
mysql -e "grant all on zabbix.* to zabbix@'localhost' identified by 'zabbix';"
cd /root/zabbix-3.4.4/database/mysql/
mysql -uzabbix -pzabbix zabbix < schema.sql && mysql -uzabbix -pzabbix zabbix < images.sql && mysql -uzabbix -pzabbix zabbix < data.sql
fi
cd /root/zabbix-3.4.4/frontends/php/ 
\cp -r * /usr/local/nginx/html/
chmod -R 777 /usr/local/nginx/html/*
sed -i "85s/# //" /usr/local/etc/zabbix_server.conf
sed -i "119s/# DBPassword=/DBPassword=zabbix/" /usr/local/etc/zabbix_server.conf

#-----------------------php扩展--------------------------
yum -y install  php-gd php-xml php-bcmath php-mbstring php-ldap
sed -i "s/;date.timezone =/date.timezone = Asia\/Shanghai/" /etc/php.ini
sed -i "/max_execution_time = 30$/s/max_execution_time = 30/max_execution_time = 300/" /etc/php.ini
sed -i "s/post_max_size = 8M/post_max_size = 32M/" /etc/php.ini
sed -i "s/max_input_time = 60/max_input_time = 300/" /etc/php.ini
systemctl restart php-fpm
id zabbix || useradd -s /sbin/nologin zabbix
ss -antulp | grep zabbix_server || zabbix_server

#----------------------zabbix_agentd-------------------------------

sed -i "/Server\=127\.0\.0\.1$/s/Server=127.0.0.1/Server=127.0.0.1,192.168.1.231/" /usr/local/etc/zabbix_agentd.conf
sed -i "/ServerActive\=127\.0\.0\.1$/s/ServerActive=127.0.0.1/ServerActive=127.0.0.1,192.168.1.231/" /usr/local/etc/zabbix_agentd.conf
sed -i "s/# UnsafeUserParameters=0/UnsafeUserParameters=1/" /usr/local/etc/zabbix_agentd.conf
ss -antulp | grep zabbix_agentd || zabbix_agentd
