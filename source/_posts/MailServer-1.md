---
title: MailServer-1
toc: 1
date: 2017-02-27 13:10:53
tags:
- 工作日常
categories:
- postfix
- dovecot
- mysql
permalink:
---
**原因**：2017年2月27日 星期一 随笔记录。
**说明**：记录配置安装过程，迭代轮次为1。

---

<!-- more -->

## 简介
第一轮迭代采用阿里云debian 8系统作为服务器，域名为miniyao.net。使用postfix、dovecot、mysql配置安装邮箱服务器
<div align=center>
![mail_stt](http://okj8snz5g.bkt.clouddn.com/blog/mail_server.jpg)
</div>


---

## 服务端

### 安装packages
- 使用ssh远程连接服务器
- 安装所需packages如下:

```
apt-get install postfix postfix-mysql dovecot-core dovecot-imapd dovecot-pop3d dovecot-lmtpd dovecot-mysql mysql-server
```
- 安装过程中需要对postfix configuration进行配置，这里选择`Internet Site`选项，同时System mial name填写`mail.miniyao.net`
- mysql安装过程需输入两遍密码，记住密码后序需要使用
- 如下图所示
![mysql](http://okj8snz5g.bkt.clouddn.com/blog/mysql.png)
![postfix_internetsite](http://okj8snz5g.bkt.clouddn.com/blog/postfix_internetsite.png)
![postfix_systemmailname](http://okj8snz5g.bkt.clouddn.com/blog/postfix_systemmailname.png)

---
### Mysql配置
- 创建数据库

```
mysqladmin -p create mailserver
```
- 输入方才设置的数据库密码
- 登入数据库

```
mysql -p mailserver
```
- 创建user，其中替换`mailuserpss`为自己的密码。

```
GRANT SELECT ON mailserver.* TO 'mailuser'@'127.0.0.1' IDENTIFIED BY 'mailuserpass';
```
- 刷新MySQL权限申请变更：

```
FLUSH PRIVILEGES;
```
- 为收发邮件的域名创建数据表：

```
CREATE TABLE `virtual_domains` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```
- 为邮箱账户及密码创建数据表：

```
CREATE TABLE `virtual_users` (
  `id` int(11) NOT NULL auto_increment,
  `domain_id` int(11) NOT NULL,
  `password` varchar(106) NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```
- 为电子邮件别名创建数据表:

```
CREATE TABLE `virtual_aliases` (
  `id` int(11) NOT NULL auto_increment,
  `domain_id` int(11) NOT NULL,
  `source` varchar(100) NOT NULL,
  `destination` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

---
### 添加数据
- 插入数据到域名表virtual_domains内，替换hostname与example.com为自己的主机名及域名

```
INSERT INTO `mailserver`.`virtual_domains`
  (`id` ,`name`)
VALUES
  ('1', 'example.com'),
  ('2', 'hostname.example.com'),
  ('3', 'hostname'),
  ('4', 'localhost.example.com');
```
- 插入数据到用户表virtual_users内，替换example.com及password为对应信息

```
INSERT INTO `mailserver`.`virtual_users`
  (`id`, `domain_id`, `password` , `email`)
VALUES
  ('1', '1', ENCRYPT('password', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))), 'email1@example.com'),
  ('2', '1', ENCRYPT('password', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))), 'email2@example.com');

```
- 为设置用户别名插入数据到virtual_aliases，替换example.com为自己的域名

```
INSERT INTO `mailserver`.`virtual_aliases`
  (`id`, `domain_id`, `source`, `destination`)
VALUES
  ('1', '1', 'alias@example.com', 'email1@example.com');
```
---

### 数据库测试
- 测试表virtual_domains

```
SELECT * FROM mailserver.virtual_domains;
```
- 输出应为：

```
+----+-----------------------+
| id | name                  |
+----+-----------------------+
|  1 | example.com           |
|  2 | hostname.example.com  |
|  3 | hostname              |
|  4 | localhost.example.com |
+----+-----------------------+
4 rows in set (0.00 sec)
```
- 测试表virtual_users

```
SELECT * FROM mailserver.virtual_users;
```
- 输出应为：

```
+----+-----------+-------------------------------------+--------------------+
| id | domain_id | password                            | email              |
+----+-----------+-------------------------------------+--------------------+
|  1 |         1 | $6$574ef443973a5529c20616ab7c6828f7 | email1@example.com |
|  2 |         1 | $6$030fa94bcfc6554023a9aad90a8c9ca1 | email2@example.com |
+----+-----------+-------------------------------------+--------------------+
2 rows in set (0.01 sec)
```
- 测试表virtual_aliases

```
SELECT * FROM mailserver.virtual_aliases;
```
- 输出应为：

```
+----+-----------+-------------------+--------------------+
| id | domain_id | source            | destination        |
+----+-----------+-------------------+--------------------+
|  1 |         1 | alias@example.com | email1@example.com |
+----+-----------+-------------------+--------------------+
1 row in set (0.00 sec)
```
---

### 配置postfix
- 备份postfix配置文件：

```
cp /etc/postfix/main.cf /etc/postfix/main.cf.orig
```
- `/etc/postfix/main.cf`文件，修改hostname及替换example.com，修改smtpd_tls_cert_file及smtpd_tls_key_file后的存放证书位置，对应位置为你的ssl证书。

<pre>
# See /usr/share/postfix/main.cf.dist for a commented, more complete version

# Debian specific:  Specifying a file name will cause the first
# line of that file to be used as the name.  The Debian default
# is /etc/mailname.
#myorigin = /etc/mailname

smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h

readme_directory = no

# TLS parameters
#smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
#smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
#smtpd_use_tls=yes
#smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
#smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache

smtpd_tls_cert_file=/etc/dovecot/example.com.pem
smtpd_tls_key_file=/etc/dovecot/private/example.com.key
smtpd_use_tls=yes
smtpd_tls_auth_only = yes

#Enabling SMTP for authenticated users, and handing off authentication to Dovecot
smtpd_sasl_type = dovecot
smtpd_sasl_path = private/auth
smtpd_sasl_auth_enable = yes

smtpd_recipient_restrictions =
        permit_sasl_authenticated,
        permit_mynetworks,
        reject_unauth_destination

# See /usr/share/doc/postfix/TLS_README.gz in the postfix-doc package for
# information on enabling SSL in the smtp client.

myhostname = hostname.example.com
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
myorigin = /etc/mailname
#mydestination = example.com, hostname.example.com, localhost.example.com, localhost
mydestination = localhost
relayhost =
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all

#Handing off local delivery to Dovecot's LMTP, and telling it where to store mail
virtual_transport = lmtp:unix:private/dovecot-lmtp

#Virtual domains, users, and aliases
virtual_mailbox_domains = mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf
virtual_mailbox_maps = mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf
virtual_alias_maps = mysql:/etc/postfix/mysql-virtual-alias-maps.cf,
        mysql:/etc/postfix/mysql-virtual-email2email.cf
</pre>

- 创建文件`/etc/postfix/mysql-virtual-mailbox-domains.cf`，并替换其中密码，密码在上文中设置

```
user = mailuser
password = mailuserpass
hosts = 127.0.0.1
dbname = mailserver
query = SELECT 1 FROM virtual_domains WHERE name='%s'
```
- 同上，`/etc/postfix/mysql-virtual-mailbox-maps.cf`

```
user = mailuser
password = mailuserpass
hosts = 127.0.0.1
dbname = mailserver
query = SELECT 1 FROM virtual_users WHERE email='%s'
```

- 同上，`/etc/postfix/mysql-virtual-alias-maps.cf`

```
user = mailuser
password = mailuserpass
hosts = 127.0.0.1
dbname = mailserver
query = SELECT destination FROM virtual_aliases WHERE source='%s'
```

- 同上，`/etc/postfix/mysql-virtual-email2email.cf`

```
user = mailuser
password = mailuserpass
hosts = 127.0.0.1
dbname = mailserver
query = SELECT email FROM virtual_users WHERE email='%s'
```
- 重启postfix:`service postfix restart`
- 测试：返回1即为正确，注意替换example.com

```
postmap -q example.com mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf
```
- 测试，返回1即为正确

```
postmap -q email1@example.com mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf
```
- 打开`/etc/postfix/master.cf`，修改为以下：

```
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
- 修改文件权限并重启：

```
chmod -R o-rwx /etc/postfix
service postfix restart
```
---

### 配置dovecot
- 备份dovecot配置文件：

```
cp /etc/dovecot/dovecot.conf /etc/dovecot/dovecot.conf.orig
cp /etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf.orig
cp /etc/dovecot/conf.d/10-auth.conf /etc/dovecot/conf.d/10-auth.conf.orig
cp /etc/dovecot/dovecot-sql.conf.ext /etc/dovecot/dovecot-sql.conf.ext.orig
cp /etc/dovecot/conf.d/10-master.conf /etc/dovecot/conf.d/10-master.conf.orig
cp /etc/dovecot/conf.d/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf.orig
```
- 修改`/etc/dovecot/dovecot.conf`文件如下并保存。

<pre>
## Dovecot configuration file

# If you're in a hurry, see http://wiki2.dovecot.org/QuickConfiguration

# "doveconf -n" command gives a clean output of the changed settings. Use it
# instead of copy&pasting files when posting to the Dovecot mailing list.

# '#' character and everything after it is treated as comments. Extra spaces
# and tabs are ignored. If you want to use either of these explicitly, put the
# value inside quotes, eg.: key = "# char and trailing whitespace  "

# Default values are shown for each setting, it's not required to uncomment
# those. These are exceptions to this though: No sections (e.g. namespace {})
# or plugin settings are added by default, they're listed only as examples.
# Paths are also just examples with the real defaults being based on configure
# options. The paths listed here are for configure --prefix=/usr
# --sysconfdir=/etc --localstatedir=/var

# Enable installed protocols
!include_try /usr/share/dovecot/protocols.d/*.protocol
protocols = imap pop3 lmtp

# A comma separated list of IPs or hosts where to listen in for connections. 
# "*" listens in all IPv4 interfaces, "::" listens in all IPv6 interfaces.
# If you want to specify non-default ports or anything more complex,
# edit conf.d/master.conf.
#listen = *, ::

# Base directory where to store runtime data.
#base_dir = /var/run/dovecot/

# Name of this instance. Used to prefix all Dovecot processes in ps output.
#instance_name = dovecot

# Greeting message for clients.
#login_greeting = Dovecot ready.

# Space separated list of trusted network ranges. Connections from these
# IPs are allowed to override their IP addresses and ports (for logging and
# for authentication checks). disable_plaintext_auth is also ignored for
# these networks. Typically you'd specify the IMAP proxy servers here.
#login_trusted_networks =

# Sepace separated list of login access check sockets (e.g. tcpwrap)
#login_access_sockets = 

# Show more verbose process titles (in ps). Currently shows user name and
# IP address. Useful for seeing who are actually using the IMAP processes
# (eg. shared mailboxes or if same uid is used for multiple accounts).
#verbose_proctitle = no

# Should all processes be killed when Dovecot master process shuts down.
# Setting this to "no" means that Dovecot can be upgraded without
# forcing existing client connections to close (although that could also be
# a problem if the upgrade is e.g. because of a security fix).
#shutdown_clients = yes

# If non-zero, run mail commands via this many connections to doveadm server,
# instead of running them directly in the same process.
#doveadm_worker_count = 0
# UNIX socket or host:port used for connecting to doveadm server
#doveadm_socket_path = doveadm-server

# Space separated list of environment variables that are preserved on Dovecot
# startup and passed down to all of its child processes. You can also give
# key=value pairs to always set specific settings.
#import_environment = TZ

##
## Dictionary server settings
##

# Dictionary can be used to store key=value lists. This is used by several
# plugins. The dictionary can be accessed either directly or though a
# dictionary server. The following dict block maps dictionary names to URIs
# when the server is used. These can then be referenced using URIs in format
# "proxy::<name>".

dict {
  #quota = mysql:/etc/dovecot/dovecot-dict-sql.conf.ext
  #expire = sqlite:/etc/dovecot/dovecot-dict-sql.conf.ext
}

# Most of the actual configuration gets included below. The filenames are
# first sorted by their ASCII value and parsed in that order. The 00-prefixes
# in filenames are intended to make it easier to understand the ordering.
!include conf.d/*.conf

# A config file can also tried to be included without giving an error if
# it's not found:
!include_try local.conf
</pre>

- 打开`/etc/dovecot/conf.d/10-mail.conf`文件，修改如下项目：

```
mail_location = maildir:/var/mail/vhosts/%d/%n
...
mail_privileged_group = mail
```
- 查看`/var/mail`权限：`ls -ld /var/mail`，应为：

```
drwxrwsr-x 2 root mail 4096 Mar  6 15:08 /var/mail
```

- 创建文件夹，注意替换域名

```
mkdir -p /var/mail/vhosts/example.com
```
- 添加group user。并修改权限

```
groupadd -g 5000 vmail
useradd -g vmail -u 5000 vmail -d /var/mail
chown -R vmail:vmail /var/mail
```
- 修改`/etc/dovecot/conf.d/10-auth.conf`中的内容，修改的部分如下：

```
disable_plaintext_auth = yes
auth_mechanisms = plain login
#!include auth-system.conf.ext
!include auth-sql.conf.ext
#!include auth-ldap.conf.ext
#!include auth-passwdfile.conf.ext
#!include auth-checkpassword.conf.ext
#!include auth-vpopmail.conf.ext
#!include auth-static.conf.ext
```
- 修改`/etc/dovecot/conf.d/auth-sql.conf.ext`中的内容，修改的部分如下：

```
passdb {
  driver = sql
  args = /etc/dovecot/dovecot-sql.conf.ext
}
userdb {
  driver = static
  args = uid=vmail gid=vmail home=/var/mail/vhosts/%d/%n
   }
```
- 修改`etc/dovecot/dovecot-sql.conf.ext`中的内容，修改的部分如下：

```
driver = mysql
connect = host=127.0.0.1 dbname=mailserver user=mailuser password=mailuserpass
default_pass_scheme = SHA512-CRYPT
password_query = SELECT email as user, password FROM virtual_users WHERE email='%u';
```
- 修改用户及权限：

```
chown -R vmail:dovecot /etc/dovecot
chmod -R o-rwx /etc/dovecot
```
- 修改`/etc/dovecot/conf.d/10-master.conf`中的内容，修改的部分如下：

```
  service imap-login {
inet_listener imap {
  port = 0
}
  inet_listener imaps {
port = 993
ssl = yes
}
    ...
  service pop3-login {
      inet_listener pop3 {
      port = 0
          }
inet_listener pop3s {
  port = 995
  ssl = yes
}
  ...
  }
  service lmtp {
  unix_listener /var/spool/postfix/private/dovecot-lmtp {
    mode = 0600
    user = postfix
    group = postfix
  }
    # Create inet listener only if you can't use the above UNIX socket
    #inet_listener lmtp {
      # Avoid making LMTP visible for the entire internet
      #address =
      #port =
    #}
  }
  service auth {
  # auth_socket_path points to this userdb socket by default. It's typically
  # used by dovecot-lda, doveadm, possibly imap process, etc. Its default
  # permissions make it readable only by root, but you may need to relax these
  # permissions. Users that have access to this socket are able to get a list
  # of all usernames and get results of everyone's userdb lookups.
  unix_listener /var/spool/postfix/private/auth {
    mode = 0666
    user = postfix
    group = postfix
  }
  unix_listener auth-userdb {
    mode = 0600
    user = vmail
    #group =
  }
  # Postfix smtp-auth
  #unix_listener /var/spool/postfix/private/auth {
  #  mode = 0666
  #}
  # Auth process is run as this user.
  user = dovecot
}
service auth-worker {
  # Auth worker process is run as root by default, so that it can access
  # /etc/shadow. If this isn't necessary, the user should be changed to
  # $default_internal_user.
  user = vmail
}
```

- 生成ssl证书：（注意修改域名）
```
openssl req -new -x509 -days 3650 -nodes -out /etc/dovecot/example.pem -keyout /etc/dovecot/private/example.pem
```
- 修改`/etc/dovecot/conf.d/10-ssl.conf`文件中的域名地址为：

```
ssl = required
ssl_cert = </etc/dovecot/example.pem
ssl_key = </etc/dovecot/private/example.pem
```
- 重启dovecot：`service dovecot restart`

---
### 域名解析设置
- 解析域名为邮箱服务器，经过学习资料及摸索，暂时我的邮箱服务器域名解析如下：
![maildns](http://okj8snz5g.bkt.clouddn.com/blog/dnsmail.png)

---
### 测试
- 本地测试，首先查看postfix与dovecot状态

```
service postfix status
service dovecot status
```
- 如果和我上述配置过程及系统相同，不会报错。如果报错请查看`/var/log/mail.log`具体信息
- 收送邮件测试如下(带有注释行为输入，无注释为命令行正确输出)：

```
telnet mail.example.com 25 //ssh进入服务器，命令行进入telnet 使用端口号25
Trying mail.example.com...
Connected to localhost.
Escape character is '^]'.
220 mail.demoslice.com ESMTP Postfix (Ubuntu)
HELO mail.example.com  //与服务器握手
250 mail.demoslice.com
MAIL FROM: \\<email1@example.com\\> //发件人，数据库插入这一用户。本地发送无需密码验证
250 2.1.0 Ok
RCPT TO: \\<demo@demomo.com\\> //收件人，可改为自己的邮箱已作验证。
250 2.1.5 Ok
DATA //邮件内容已DATA指令开始
354 End data with <CR><LF>.<CR><LF>
Subject: test message //标题，测试信息，回车
This is the body of the message! //输入正文，回车
. //输入.结束正文
250 2.0.0 Ok: queued as 9620FF0087
quit //退出telnet与邮箱服务器连接
```
- 至此，可在demo@demomo.com的邮箱客户端查看到email1@example.com发来的邮件，即可验证，为了安全问题请关闭25端口，使用加密端口。
- 收取邮箱可通过向email1@example.com发送邮件，并查看`/var/log/mail.log`验证是否接收邮件。
- 使用网易闪电邮进行测试：
- IMAP SSL 993 imap.miniyao.net & SMTP SSL 587 smtp.miniyao.net 登录成功。
- POP SSl 995 pop.miniyao.net & SMTP SSL 587 smtp.miniyao.net 登录成功。

---
## 客户端

- 选择[RainLoop](https://www.rainloop.net)作为邮箱客户端，需要配置PHP及Apache环境，测试环境为Linode VPS，操作系统为Debian 8，具体操作如下：

---

### Apache2
- 首先升级系统：

```
sudo apt-get update && sudo apt-get upgrade
```
- 安装apache2

```
apt-get install apache2
```
- 编辑`/etc/apache2/apache2.conf`文件，对应代码修改为如下：

```
KeepAlive Off
```
- 编辑`/etc/apache2/mods-available/mpm_prefork.conf`，对应代码修改如下：

```
<IfModule mpm_prefork_module>
        StartServers            4
        MinSpareServers         20
        MaxSpareServers         40
        MaxRequestWorkers       200
        MaxConnectionsPerChild  4500
</IfModule>
```
- 关闭event模块，打开prefork模块：

```
sudo a2dismod mpm_event
sudo a2enmod mpm_prefork
```
- 重启apache2:

```
systemctl restart apache2
```
- 由于测试机器为云主机CLI命令行模式，只能通过访问其IP地址，查看到`apache it works`等信息，证明安装成功！

---

### PHP
- Debian 8/Linux 安装PHP5：

```
apt-get install php5-common libapache2-mod-php5 php5-cli php5-curl
```
- 如有数据库需要可安装`php-mysql`
- 安装完成后关闭apache2并重启apache2，APT 将自动安装 Apache 2 的 PHP 5 模块以及所有依赖的库并激活之。应重启动 Apache 以使更改生效：

```
# /etc/init.d/apache2 stop
# /etc/init.d/apache2 start
```
- 在/var/www/html文件下vi info.pip。插入代码

```
<?php
phpinfo();
?>
```
- 在浏览器端输入ip/info.php，查看到php版本信息等即可证明apache2加载php5成功。如下图：
![APACHEPHP](http://okj8snz5g.bkt.clouddn.com/blog/apachephp.png)

--- 

### RainLoop
- 上文中安装的`php5-curl`将用于本部分下载RainLoop：
- 在线安装：

```
mkdir /var/www/rainloop
wget -qO- https://repository.rainloop.net/installer.php | php
curl -s https://repository.rainloop.net/installer.php | php //wget 与 curl 选其一即可
```
- 也可离线安装，其中rainloop-latest.zip为离线下载文件：

```
mkdir /var/www/rainloop
unzip rainloop-latest.zip -d /var/www/rainloop
```
- 修改权限：

```
cd /var/www/rainloop
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;
chown -R www-data:www-data .
```
---

### 配置客户端
- 首先对apache2进行配置，配置文件为`/etc/apache2/apache2.conf`，修改部分后有注释：

```
<Directory />
        Options FollowSymLinks
        AllowOverride None
        Require all granted //由denied修改为granted
</Directory>
<Directory /usr/share>
        AllowOverride None
        Require all granted
</Directory>
<Directory /var/www/rainloop> //将默认文件夹修改为rainloop所在文件夹
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>
#<Directory /srv/>
#       Options Indexes FollowSymLinks
#       AllowOverride None
#       Require all granted
#</Directory>
```
- 如果不修改granted项，会出现403禁止的错误，而如果不修改默认文件夹，亦可将rainloop拷贝到原本的默认文件夹下，apache2会自动解析该文件夹下的文件。
- 重启apache2，并在浏览器端输入`ip/index.php`，这一文件为rainloop文件夹下php项目的入口文件，成功展示出内容。
- 浏览器端输入`ip/?admin`，进入管理面板，修改语言为简体中文并将我们上文中imap,smtp及域名信息填入rainloop域名管理，点击测试成功后保存，从登录界面`(admin;12345)`登录邮箱进行收发邮件测试，通过测试。下面是图片展示：
![mail1](http://okj8snz5g.bkt.clouddn.com/blog/xymail1.png)
![mail2](http://okj8snz5g.bkt.clouddn.com/blog/xymail2.png)
![mailtitle](http://okj8snz5g.bkt.clouddn.com/blog/xymailtitle.png)
![maillangure](http://okj8snz5g.bkt.clouddn.com/blog/xymaillangure.png)

---
### 通讯协议
- 这里记录常用通讯协议，主要针对https进行部署实战记录，主要参考[慕课网资料](http://www.imooc.com/article/3582)。
- CP HTTP UDP:都是通信协议，也就是通信时所遵守的规则，只有双方按照这个规则“说话”，对方才能理解或为之服务。
- TCP HTTP UDP三者的关系:
TCP/IP是个协议组，可分为四个层次：网络接口层、网络层、传输层和应用层。
在网络层有IP协议、ICMP协议、ARP协议、RARP协议和BOOTP协议。
在传输层中有TCP协议与UDP协议。
在应用层有FTP、HTTP、TELNET、SMTP、DNS等协议。
因此，HTTP本身就是一个协议，是从Web服务器传输超文本到本地浏览器的传送协议。
- Http协议：
HTTP全称是HyperText Transfer Protocol，即：超文本传输协议，从1990年开始就在WWW上广泛应用，是现今在WWW上应用最多的协议， Http是应用层协议，当你上网浏览网页的时候，浏览器和Web服务器之间就会通过HTTP在Internet上进行数据的发送和接收。Http是一个基于请求/响应模式的、无状态的协议。即我们通常所说的Request/Response。其中采用Http方式发送，信息被截取、篡改等不安全因素很多，故采用Https，使用SSL加密的HTTP。
- 一般配置可采用自签名证书、购买证书或使用第三方免费证书，这里使用第三方证书[certbot](https://certbot.eff.org)，免费并安全。
- 首先ssh进入我们的apache2机器，vi打开`/etc/apt/sources.list`，在最后添加一行代码，并更新`apt-get`：

```
deb http://ftp.debian.org/debian jessie-backports main
apt-get update //添加第三方源并更新包管理器
```
- 安装certbot：

```
sudo apt-get install python-certbot-apache -t jessie-backports
```
- 开始设置：

```
certbot --apache
```
- 会弹出窗口，填写你的域名，选择http自动跳转为https。成功后打开网站即可验证是否成功。.



