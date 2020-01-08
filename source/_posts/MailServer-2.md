
---
title: MailServer-2
toc: 1
date: 2017-03-06 09:43:47
tags:
- 工作日常
categories:
- postfix
- dovecot
- mariadb
permalink:
---
**原因**：2017年3月10日 星期五 随笔记录。
**说明**：记录配置安装过程，迭代轮次为2。

-------------------

<!-- more -->
    
## 简介
第二轮迭代采用阿里云`centos7.2` 64位系统，与`debian`系统有很多不同之处，使用postfix、dovecot、MariaDB配置安装邮箱服务器。其中MariaDB数据库管理系统是MySQL的一个分支，主要由开源社区在维护，采用GPL授权许可 MariaDB的目的是完全兼容MySQL，包括API和命令行，使之能轻松成为MySQL的代替品。本文参考[教程](https://www.linode.com/docs/email/postfix/email-with-postfix-dovecot-and-mariadb-on-centos-7)，此教程内坑略多，且行且珍惜。

---
## 服务端
### 安装packages
- 首先升级packages：

```
yum update
```
- CentOS自带的postfix不支持MariaDB，故而需要在`／etc/yum.repos.d/CentOS-Base.repo`内文件内添加如下：

```
[base]
name=CentOS-$releasever - Base
exclude=postfix

#released updates
[updates]
name=CentOS-$releasever - Updates
exclude=postfix
```
- 安装需要的packages

```
yum --enablerepo=centosplus install postfix
yum install dovecot mariadb-server dovecot-mysql
```

---
### MariaDB的设置
- 设置MariaDB开机启动，并开启其服务：

```
systemctl enable mariadb.service
systemctl start mariadb.service
```
- 设置MariaDB

```
mysql_secure_installation
```
- 运行上述命令后，更改密码，默认原密码位空直接回车输入两遍新密码即可，另有一些选项选择如下：`remove anonymous user accounts`, `disable root logins outside of localhost`, `remove test databases`, `reload privilege tables`。
- 进入MaraiDB命令行：

```
mysql -u root -p
```
- 创建数据库`mail`并使用：

```
CREATE DATABASE mail;
USE mail;
```
- 创建admin表单，替换`mail_admin_password`为你的密码：

```
GRANT SELECT, INSERT, UPDATE, DELETE ON mail.* TO 'mail_admin'@'localhost' IDENTIFIED BY 'mail_admin_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON mail.* TO 'mail_admin'@'localhost.localdomain' IDENTIFIED BY 'mail_admin_password';
FLUSH PRIVILEGES;
```
- 创建domains表单：

```
CREATE TABLE domains (domain varchar(50) NOT NULL, PRIMARY KEY (domain) );
```
- 创建forwarding表单：

```
CREATE TABLE forwardings (source varchar(80) NOT NULL, destination TEXT NOT NULL, PRIMARY KEY (source) );
```
- 创建users表单：

```
CREATE TABLE `users` (
  `mailuser_id` int(11) NOT NULL auto_increment,
  `password` varchar(106) NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`mailuser_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```
- 创建transports表单：

```
CREATE TABLE transport ( domain varchar(128) NOT NULL default '', transport varchar(128) NOT NULL default '', UNIQUE KEY domain (domain) );
quit
```
- 添加测试用户信息并退出，替换`example.com`，`sales@example.com`，`password`为你的测试用户信息：

```
USE mail;
INSERT INTO domains (domain) VALUES ('example.com');
INSERT INTO users (mailuser_id, email, password) VALUES (1,'sales@example.com', ENCRYPT('password', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))));
quit
```

- 将MariaDB绑定到`localhost`，编辑文件`/etc/my.cnf`，添加：

```
bind-address=127.0.0.1
```
- 重启数据库服务：

```
systemctl restart  mariadb.service
```

---
### 生成证书
- 生成ssl证书：
```
openssl req -new -x509 -days 3650 -nodes -out /etc/dovecot/dovecot.pem -keyout /etc/dovecot/private/dovecot.pem
```

---
### 配置postfix
- 创建域名配置文件`/etc/postfix/mysql-virtual_domains.cf`并添加内容如下，替换`mail_admin_password`为你设置的MariaDB的密码：

```
user = mail_admin
password = mail_admin_password
dbname = mail
query = SELECT domain AS virtual FROM domains WHERE domain='%s'
hosts = 127.0.0.1
```
- 创建forwarding文件`/etc/postfix/mysql-virtual_forwardings.cf`并添加内容如下，替换`mail_admin_password`为你设置的MariaDB的密码：

```
user = mail_admin
password = mail_admin_password
dbname = mail
query = SELECT destination FROM forwardings WHERE source='%s'
hosts = 127.0.0.1
```
- 创建邮箱配置文件`/etc/postfix/mysql-virtual_mailboxes.cf`并添加内容如下，替换`mail_admin_password`为你设置的MariaDB的密码：

```
user = mail_admin
password = mail_admin_password
dbname = mail
query = SELECT CONCAT(SUBSTRING_INDEX(email,'@',-1),'/',SUBSTRING_INDEX(email,'@',1),'/') FROM users WHERE email='%s'
hosts = 127.0.0.1
```
- 创建电子邮件映射文件`/etc/postfix/mysql-virtual_email2email.cf`并添加内容如下，替换`mail_admin_password`为你设置的MariaDB的密码：

```
user = mail_admin
password = mail_admin_password
dbname = mail
query = SELECT email FROM users WHERE email='%s'
hosts = 127.0.0.1
```
- 修改文件及用户权限：

```
chmod o= /etc/postfix/mysql-virtual_*.cf
chgrp postfix /etc/postfix/mysql-virtual_*.cf
```
- 添加用户组：

```
groupadd -g 5000 vmail
useradd -g vmail -u 5000 vmail -d /home/vmail -m
```
- 以下为输入命令行之命令，也可手动添加其中参数到`/etc/postfix/main.cf`文件中，替换`example.com`为你的域名,`smtpd_tls_cert_file,smtpd_tls_key_file`为你的证书所在目录，填写添加证书时设置的目录，否则会报错导致邮箱无法使用SSL登录：

```
postconf -e 'myhostname = server.example.com'
postconf -e 'mydestination = localhost, localhost.localdomain'
postconf -e 'mynetworks = 127.0.0.0/8'
postconf -e 'inet_interfaces = all'
postconf -e 'message_size_limit = 30720000'
postconf -e 'virtual_alias_domains ='
postconf -e 'virtual_alias_maps = proxy:mysql:/etc/postfix/mysql-virtual_forwardings.cf, mysql:/etc/postfix/mysql-virtual_email2email.cf'
postconf -e 'virtual_mailbox_domains = proxy:mysql:/etc/postfix/mysql-virtual_domains.cf'
postconf -e 'virtual_mailbox_maps = proxy:mysql:/etc/postfix/mysql-virtual_mailboxes.cf'
postconf -e 'virtual_mailbox_base = /home/vmail'
postconf -e 'virtual_uid_maps = static:5000'
postconf -e 'virtual_gid_maps = static:5000'
postconf -e 'smtpd_sasl_type = dovecot'
postconf -e 'smtpd_sasl_path = private/auth'
postconf -e 'smtpd_sasl_auth_enable = yes'
postconf -e 'broken_sasl_auth_clients = yes'
postconf -e 'smtpd_sasl_authenticated_header = yes'
postconf -e 'smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination'
postconf -e 'smtpd_use_tls = yes'
postconf -e 'smtpd_tls_cert_file = /etc/pki/dovecot/certs/dovecot.pem'
postconf -e 'smtpd_tls_key_file = /etc/pki/dovecot/private/dovecot.pem'
postconf -e 'proxy_read_maps = $local_recipient_maps $mydestination $virtual_alias_maps $virtual_alias_domains $virtual_mailbox_maps $virtual_mailbox_domains $relay_recipient_maps $relay_domains $canonical_maps $sender_canonical_maps $recipient_canonical_maps $relocated_maps $transport_maps $mynetworks $virtual_mailbox_maps'
postconf -e 'virtual_transport = dovecot'
postconf -e 'dovecot_destination_recipient_limit = 1'
```
- 编辑`/etc/postfix/master.cf`文件，添加：

```
dovecot   unix  -       n       n       -       -       pipe
    flags=DRhu user=vmail:vmail argv=/usr/libexec/dovecot/deliver -f ${sender} -d ${recipient}
```
- 编辑`/etc/postfix/master.cf`文件，修改为如下：

```
#
# Postfix master process configuration file.  For details on the format
# of the file, see the master(5) manual page (command: "man 5 master").
#
# Do not forget to execute "postfix reload" after editing this file.
#
# ==========================================================================
# service type  private unpriv  chroot  wakeup  maxproc command + args
#               (yes)   (yes)   (yes)   (never) (100)
# ==========================================================================
smtp      inet  n       -       -       -       -       smtpd
#smtp      inet  n       -       -       -       1       postscreen
#smtpd     pass  -       -       -       -       -       smtpd
#dnsblog   unix  -       -       -       -       0       dnsblog
#tlsproxy  unix  -       -       -       -       0       tlsproxy
submission inet n       -       -       -       -       smtpd
  -o syslog_name=postfix/submission
  -o smtpd_tls_security_level=encrypt
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_client_restrictions=permit_sasl_authenticated,reject
  -o milter_macro_daemon_name=ORIGINATING
smtps     inet  n       -       -       -       -       smtpd
  -o syslog_name=postfix/smtps
  -o smtpd_tls_wrappermode=yes
  -o smtpd_sasl_auth_enable=yes
  -o smtpd_client_restrictions=permit_sasl_authenticated,reject
  -o milter_macro_daemon_name=ORIGINATING
```
- 设置postfix开机自启动，并开启postfix服务：

```
systemctl enable postfix.service
systemctl start  postfix.service
```

---
### 配置dovecot
- 移动dovecot文件为备份文件：

```
mv /etc/dovecot/dovecot.conf /etc/dovecot/dovecot.conf-backup
```
- 创建新的dovecot.conf文件并添加如下内容，其中`ssl_cert`，`ssl_key`与上文中证书位置对应：
```
protocols = imap pop3
log_timestamp = "%Y-%m-%d %H:%M:%S "
mail_location = maildir:/home/vmail/%d/%n/Maildir
ssl_cert = </etc/pki/dovecot/certs/dovecot.pem
ssl_key = </etc/pki/dovecot/private/dovecot.pem
namespace {
    type = private
    separator = .
    prefix = INBOX.
    inbox = yes
}
service auth {
    unix_listener auth-master {
        mode = 0600
        user = vmail
    }
    unix_listener /var/spool/postfix/private/auth {
        mode = 0666
        user = postfix
        group = postfix
    }
user = root
}
service auth-worker {
    user = root
}
protocol lda {
    log_path = /home/vmail/dovecot-deliver.log
    auth_socket_path = /var/run/dovecot/auth-master
    postmaster_address = postmaster@example.com
}
protocol pop3 {
    pop3_uidl_format = %08Xu%08Xv
}
passdb {
    driver = sql
    args = /etc/dovecot/dovecot-sql.conf.ext
}
userdb {
    driver = static
    args = uid=5000 gid=5000 home=/home/vmail/%d/%n allow_all_users=yes
}
```
- 创建`/etc/dovecot/dovecot-sql.conf.ext`文件，内容如下，修改`mail_admin_password`为你设置的MariaDB的密码：

```
driver = mysql
connect = host=127.0.0.1 dbname=mail user=mail_admin password=mail_admin_password
default_pass_scheme = CRYPT
password_query = SELECT email as user, password FROM users WHERE email='%u';
```
- 修改文件及用户权限：

```
chgrp dovecot /etc/dovecot/dovecot-sql.conf.ext
chmod o= /etc/dovecot/dovecot-sql.conf.ext
```
- 设置dovecot开机自启动，并开启dovecot服务：

```
systemctl enable dovecot.service
systemctl start  dovecot.service
```
- 安装telnet测试POP3工作正常：

```
yum install telnet
telnet localhost pop3
```
- 命令行返回如下内容说明POP3工作正常：

```
Trying 127.0.0.1...
Connected to localhost.localdomain.
Escape character is '^]'.
+OK Dovecot ready.
```
- 测试postfix：

```
telnet localhost 25
ehlo localhost
```
- 命令行返回如下内容说明postfix的`TLS`及`SMTP-AUTH`工作正常：

```
250-hostname.example.com
250-PIPELINING
250-SIZE 30720000
250-VRFY
250-ETRN
250-STARTTLS
250-AUTH PLAIN
250-AUTH=PLAIN
250-ENHANCEDSTATUSCODES
250-8BITMIME
250 DSN
```

---
### 本地测试 
- 测试邮箱，安装mutt：

```
yum install mutt
```
- 设置测试用户，并使用`telnet localhost 25`一封邮件，并使用其他邮箱服务器给测试账户发送一封邮件，进入`/home/vmail/example.com/testAccount/Maildir/`，输入命令`find`，随后输入`mutt -f .`，会出现如下内容：
![mailbox](http://image.yaopig.com/blog/mailbox.png)

---
### Centos部署Apache
- centos相对于debian内部集成apache，只需安装`httpd`修改参数即可使用apache：

```
yum install httpd
```
- 启动httpd:

```
service start httpd
```
- 编辑`/etc/httpd/conf/httpd.conf`。可修改默认root路径为`/var/www/rainloop`，这里是为了后续邮箱客户端做准备。

---

### Centos安装PHP7
- 经过一天的调试、发现php5部分功能特征不能满足需求，故而改为使用php7，首先删除本地php5：

```
yum remove php* php-common
```
- 添加rpm源：

```
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm  
```
- 安装php7以及需要的模块：

```
yum install php70w php70w-pdo php70w-mysql php70w-xml
```
- 在apache2的directoy目录下，`vi info.php`，写入`<?php   phpinfo();  ?>`，在浏览器输入ip/info.php，查看到php信息即可证明安装成功。

## rainloop部署
- 下载[rainloop](http://www.rainloop.net)的压缩文件，解压到`apache`的解析目录，一般为/var/www/html。可在`/etc/apache2/conf/httpd.conf`文件中进行查看，具体为`Directory`项目后的路径。其余安装方法参见[MailServer-1](http://minichao.me/2017/02/27/MailServer-1/)。
- 将rainloop解压到apache解析目录即可解析，在浏览器中打开即可DIY
- 插件的配置与修改：为实现修改密码等功能，在`/var/www/rainloop/data/_data_/_default_/plugin`下添加开源or自定义插件，进入管理界面即可开启关闭插件，自定义插件参数等。