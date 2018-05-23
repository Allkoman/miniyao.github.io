---
title: Java实战
toc: 1
top: 999
date: 2017-05-15 04:30:27
tags:
categories:
permalink:
---
**原因**：设计实现电商网站
**说明**：DIY项目

<!-- more -->

## 环境部署

### JDK安装配置

```
rpm -qa | grep jdk //清理自带jdk
sudo chmod 777 jdk-7u80-linux-x64.rpm
sudo rpm -ivh jdk-7u80-linux-x64.rpm
sudo vim /etc/profile //插入以下的配置

export JAVA_HOME=/usr/java/jdk1.7.0_80 
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/

java -version
```

### Tomcat配置安装
```
tar -zxvf apache-tomcat-7.0.85.tar.gz
export CATALINA_HOME=/developer/apache-tomcat-7.0.85 

cd /developer/apache-tomcat-7.0.85/bin/
./startup.sh //验证tomcat
```

#### 配置UTF-8字符集

```
sudo vim ${CATALINA_HOME}/conf/server.xml
```

- 在8080断后末尾加入URIEncoding="UTF-8"

### Maven配置安装

```
tar -zxvf apache-maven-3.5.3-bin.tar.gz
export MAVEN_HOME=/developer/apache-maven-3.0.5
```


```
export JAVA_HOME=/usr/java/jdk1.7.0_80 
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar 
export MAVEN_HOME=/developer/apache-maven-3.0.5 
export NODE_HOME=/usr/local/node-v4.4.7-linux-x64 
export RUBY_HOME=/usr/local/ruby 
export CATALINA_HOME=/developer/apache-tomcat-7.0.73 
export PATH=$PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin
export LC_ALL=en_US.UTF-8

export JAVA_HOME=/usr/java/jdk1.7.0_80 
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar 
export PATH=$JAVA_HOME/bin:$PATH
export MAVEN_HOME=/developer/apache-maven-3.0.5 
export CATALINA_HOME=/developer/apache-tomcat-7.0.73 
```

### vsftpd

```
yum -y install vsftpd
cd / && mkdir ftpfile
useradd ftpuser -d /ftpfile -s /sbin/nologin
chown -R ftpuser.ftpuser /ftpfile
passwd ftpuser
cd /etc/vsftpd && vim chroot_list //添加ftpuser到此文件中
sudo vim /etc/selinux/config //修改为disabled

```


```
# Example config file /etc/vsftpd/vsftpd.conf
#
# The default compiled in settings are fairly paranoid. This sample file
# loosens things up a bit, to make the ftp daemon more usable.
# Please see vsftpd.conf.5 for all compiled in defaults.
#
# READ THIS: This example file is NOT an exhaustive list of vsftpd options.
# Please read the vsftpd.conf.5 manual page to get a full idea of vsftpd's
# capabilities.
#
# Allow anonymous FTP? (Beware - allowed by default if you comment this out).

local_root=/ftpfile 
#chroot_local_user=YES 
anon_root=/ftpfile
use_localtime=YES


#匿名
#anonymous_enable=YES
anonymous_enable=NO
#
# Uncomment this to allow local users to log in.
local_enable=YES
#
# Uncomment this to enable any form of FTP write command.
write_enable=YES
#
# Default umask for local users is 077. You may wish to change this to 022,
# if your users expect that (022 is used by most other ftpd's)
local_umask=022
#
# Uncomment this to allow the anonymous FTP user to upload files. This only
# has an effect if the above global write enable is activated. Also, you will
# obviously need to create a directory writable by the FTP user.
#anon_upload_enable=YES
#
# Uncomment this if you want the anonymous FTP user to be able to create
# new directories.
#anon_mkdir_write_enable=YES
#
# Activate directory messages - messages given to remote users when they
# go into a certain directory.
dirmessage_enable=YES
#
# The target log file can be vsftpd_log_file or xferlog_file.
# This depends on setting xferlog_std_format parameter
xferlog_enable=YES
#
# Make sure PORT transfer connections originate from port 20 (ftp-data).
connect_from_port_20=YES
#
# If you want, you can arrange for uploaded anonymous files to be owned by
# a different user. Note! Using "root" for uploaded files is not
# recommended!
#chown_uploads=YES
#chown_username=whoever
#
# The name of log file when xferlog_enable=YES and xferlog_std_format=YES
# WARNING - changing this filename affects /etc/logrotate.d/vsftpd.log
#xferlog_file=/var/log/xferlog
#
# Switches between logging into vsftpd_log_file and xferlog_file files.
# NO writes to vsftpd_log_file, YES to xferlog_file
xferlog_std_format=YES
#
# You may change the default value for timing out an idle session.
#idle_session_timeout=600
#
# You may change the default value for timing out a data connection.
#data_connection_timeout=120
#
# It is recommended that you define on your system a unique user which the
# ftp server can use as a totally isolated and unprivileged user.
#nopriv_user=ftpsecure
#
# Enable this and the server will recognise asynchronous ABOR requests. Not
# recommended for security (the code is non-trivial). Not enabling it,
# however, may confuse older FTP clients.
#async_abor_enable=YES
#
# By default the server will pretend to allow ASCII mode but in fact ignore
# the request. Turn on the below options to have the server actually do ASCII
# mangling on files when in ASCII mode.
# Beware that on some FTP servers, ASCII support allows a denial of service
# attack (DoS) via the command "SIZE /big/file" in ASCII mode. vsftpd
# predicted this attack and has always been safe, reporting the size of the
# raw file.
# ASCII mangling is a horrible feature of the protocol.
#ascii_upload_enable=YES
#ascii_download_enable=YES
#
# You may fully customise the login banner string:
ftpd_banner=Welcome to mmall FTP Server
#
# You may specify a file of disallowed anonymous e-mail addresses. Apparently
# useful for combatting certain DoS attacks.
#deny_email_enable=YES
# (default follows)
#banned_email_file=/etc/vsftpd/banned_emails
#
# You may specify an explicit list of local users to chroot() to their home
# directory. If chroot_local_user is YES, then this list becomes a list of
# users to NOT chroot().

chroot_local_user=NO

chroot_list_enable=YES
# (default follows)
chroot_list_file=/etc/vsftpd/chroot_list
#
# You may activate the "-R" option to the builtin ls. This is disabled by
# default to avoid remote users being able to cause excessive I/O on large
# sites. However, some broken FTP clients such as "ncftp" and "mirror" assume
# the presence of the "-R" option, so there is a strong case for enabling it.
#ls_recurse_enable=YES
#
# When "listen" directive is enabled, vsftpd runs in standalone mode and
# listens on IPv4 sockets. This directive cannot be used in conjunction
# with the listen_ipv6 directive.
listen=YES
#
# This directive enables listening on IPv6 sockets. To listen on IPv4 and IPv6
# sockets, you must run two copies of vsftpd with two configuration files.
# Make sure, that one of the listen options is commented !!
#listen_ipv6=YES

pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES

#pasv_enable=YES
pasv_min_port=61001
pasv_max_port=62000
```

### Iptables

```
sudo yum install iptables -y
sudo vim /etc/sysconf/iptables
```

```
# Generated by iptables-save v1.4.7 on Fri Jan  6 16:53:09 2017
#*filter
#:INPUT ACCEPT [174:12442]
#:FORWARD ACCEPT [0:0]
#:OUTPUT ACCEPT [96:10704]
#-A INPUT -p tcp -m tcp --dport 3306 -j ACCEPT 
#-A INPUT -p tcp -m state --state NEW -m tcp --dport 21 -j ACCEPT
#-A INPUT -p tcp -m tcp --dport 8080 -j ACCEPT


#COMMIT
# Completed on Fri Jan  6 16:53:09 2017


#------------------------------------

# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT 
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT

#ssh port 
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT

#vsftpd
-A INPUT -p TCP --dport 61001:62000 -j ACCEPT
-A OUTPUT -p TCP --sport 61001:62000 -j ACCEPT

-A INPUT -p TCP --dport 20 -j ACCEPT
-A OUTPUT -p TCP --sport 20 -j ACCEPT
-A INPUT -p TCP --dport 21 -j ACCEPT
-A OUTPUT -p TCP --sport 21 -j ACCEPT


#mysql port
-A INPUT -p tcp -m tcp --dport 3306 -j ACCEPT

#tomcat remote debug port
-A INPUT -p tcp -m tcp --dport 5005 -j ACCEPT

-A INPUT -p tcp -m tcp --dport 8080 -j ACCEPT

#nginx
-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT

-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
```

```
sudo service iptables restart
sudo service iptables save
sudo service vsftpd restart
```

### nginx

#### nginx简介

- 一款轻量级web服务器，也是一款反向代理服务器
- CentOS安装步骤如下

```
yum install gcc pcre-devel zlib zlib-devel openssl openssl-devel -y
wget http://nginx.org/download/nginx-1.10.2.tar.gz
tar -zxvf nginx-1.10.2.tar.gz
cd nginx-1.10.2 && ./configure
make && make install
```

- 安装成功日志

```
nginx path prefix: "/usr/local/nginx"
nginx binary file: "/usr/local/nginx/sbin/nginx"
nginx modules path: "/usr/local/nginx/modules"
nginx configuration prefix: "/usr/local/nginx/conf"
nginx configuration file: "/usr/local/nginx/conf/nginx.conf"
nginx pid file: "/usr/local/nginx/logs/nginx.pid"
nginx error log file: "/usr/local/nginx/logs/error.log"
nginx http access log file: "/usr/local/nginx/logs/access.log"
nginx http client request body temporary files: "client_body_temp"
nginx http proxy temporary files: "proxy_temp"
nginx http fastcgi temporary files: "fastcgi_temp"
nginx http uwsgi temporary files: "uwsgi_temp"
nginx http scgi temporary files: "scgi_temp
```

- 常用命令

```
/usr/local/nginx/sbin/nginx -t //测试
/usr/local/nginx/sbin/nginx //启动
/usr/local/nginx/sbin/nginx -s quit //退出
/usr/local/nginx/sbin/nginx -s reload //重启
```

#### 配置nginx

```
sudo vim /usr/local/nginx/conf/nginx.config //增加include vhost/*.conf
cd /usr/local/nginx/conf && mkdir vhost

```

```
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        listen       80;
        server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        location / {
            root   html;
            index  index.html index.htm;
        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    
    }
    
    ##########################vhost#####################################
    include vhost/*.conf;

    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}

}
```

### mysql 

```
yum install mysql-server -y
vim /etc/my.cnf
default-character-set=utf8
character-set-server=utf8
chkconf mysqld on
chkconf --list mysqld

/usr/bin/mysqladmin -u root password 'new-password'
/usr/bin/mysqladmin -u root -h miniyao password 'new-password'

```

```
select host,user,password from mysql.user;
set password for root@localhost=password('123');
set password for root@miniyao=password('123');
set password for root@127.0.0.1=password('123');
delete from mysql.user where user='';
flush privileges;
```

```
insert into mysql.user(Host,User,Password) values ("localhost","miniyao",password("123"))
```

```
CREATE DATABASE `mmall`
DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
```

- 本地or所有权限

```
grant all privileges on *.* to miniyao@localhost identified by '123' with grant option;
grant all privileges on *.* to miniyao@'%' identified by '123' with grant option;
```

- 刷新权限

```
flush privileges;
```

- Centos Shell

```
service mysqld restart/start/stop
```


