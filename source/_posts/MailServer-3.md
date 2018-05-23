---
title: MailServer-3
toc: 1
date: 2017-03-20 16:19:37
tags:
- 工作日常
categories:
- dovecot
- quota
permalink:
---
**原因**：2017年3月20日 星期一 随笔记录。
**说明**：记录配置安装过程，迭代轮次为3。

-------------------

<!-- more -->

## 简介
- 在完成第二轮迭代后，已经实现了：MTA、MDA端邮件收发dovecot、postfix、MariaDB的配置，MUA端php项目的环境Apache-PHP-MariaDB搭建、MUA客户端部署、域名解析、http协议加密转换https及证书配置。如下图：
![mailwebUI](http://okj8snz5g.bkt.clouddn.com/blog/main_mailserver.gif)
- 本文主要的目的是结合现有的结构及资源，尽可能减小改动的情况下完成quota功能，quota是dovecot提供的一个限额功能，能够设置邮箱用户的使用磁盘量，并以百分比的形式传输给前端用以展示。

## 配置
### 资料搜寻
- 最初的阶段是理解MDA、MTA、MUA，通俗易懂来说，MDA是收邮件，MTA是发邮件，而MUA就是用户用于登录的形形色色的客户端了。此处应有配图：
<div align=center>
![mail_stt](http://okj8snz5g.bkt.clouddn.com/blog/mail_server.jpg)
</div>
- 而quota功能，因为属于收邮件的管理部分，限额理应对MDA进行配置理解，即配置dovecot，首先实现命令行可以实现查看quota功能是否实现，第二步实现命令行返回quota指定的参数值，最后一步就是将这个参数返还给php前端进行显示。
- google之，关键词为dovecot quota，第一观看梯队为官网文档、官网样例，第二观看梯队为Stack Overflow的用户错误。
- [官网传送门](https://wiki2.dovecot.org/Quota)。

### 配置
- 经过摸索与尝试，配置如下：
- 首先配置dovecot，`vi /etc/dovecot/dovecot.conf`添加如下代码：

```
mail_plugins = quota
plugin {
        quota = maildir:User quota
        quota_rule = *:storage=3M:messages=20
        quota_warning = storage=95%% quota-warning 95 %u
        quota_warning2 = storage=80%% quota-warning 80 %u
}
```
- 上文参数为启用quota插件并设置为maildir方式，并设定了测试用的参数。

```
service dovecot restart
systemctl status dovecot 
```
- 重启并查看是否报错。

```
doveadm -D quota get -u testuser
```
- 当输入上文命令后，会输出debug模式的结果，如果没有报错并输出了testuser用户的限额信息即为正确。
- 这一步就完成了命令行查看并返回结果，下一步就是与前端的交互了，要达到与前端的交互，查看了php的文档，其默认支持imap_quota插件，也就是说，在quota的基础上开启imap_quota，并在php项目内调用方法即可。
- 首先我尝试在mail_plugin = quota imap_quota，重启dovecot后发现实现了php-quota功能，但是细心测试了收发功能，发现邮箱服务器只可以发不可以收邮件了，说明imap_quota在这里影响了dovecot，在命令行输入`doveadm`，输出为无法找到imap_quota插件，这里我就很困惑，因为完全是按照官方文档配置，为什么这么多坑，所以去浏览了别的插件文档，终于找到了原因，原来默认的插件是可以直接在dovecot.conf主文件引用的，但是对于imap_quota这种依赖于上层的插件就需要在quota引用后再引用。
- 故而在dovecot.conf尾添加了：`!include conf2.d/*.conf`
- 在dovecot.conf所载文件夹建立了conf2.d文件夹，将默认conf.d文件夹内的20-imap.conf,90-quota.conf文件复制到conf2.d文件夹下，这样，配置文件结构就完成了，在20-imap.conf内添加：

```
protocol imap{
    mail_plugins = $mail_plugins imap_quota
}
```
- 在90-quota.conf文件内添加：

```
plugin {
    quota_grace = 10%%
    # 10% is the default
    quota_status_success = DUNNO
    quota_status_nouser = DUNNO
    quota_status_overquota = "552 5.2.2 Mailbox is full"
}
```
- 这时删除掉dovecot.conf内的imap_quota项，将其转移到了20-imap.conf内，重启dovecot，收发及quota功能都正常，实现了预期目标，最后，贴上我的配置文件：
- `/etc/dovecot/dovecot.conf`:

```
protocols = imap pop3
log_timestamp = "%Y-%m-%d %H:%M:%S "
mail_location = maildir:/home/vmail/xygenomics.net/%n/Maildir
#plugin at /usr/lib64/dovecot/
mail_plugins = quota
#imap_quota
plugin {
    quota = maildir:User quota
    quota_rule = *:storage=3M:messages=20
    quota_warning = storage=95%% quota-warning 95 %u
    quota_warning2 = storage=80%% quota-warning 80 %u
}
ssl_cert = </etc/dovecot/dovecot.pem
ssl_key = </etc/dovecot/private/dovecot.pem
service imap-login {
  inet_listener imap {
    port = 0
  }
  inet_listener imaps {
    port = 993
  }
}
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
    postmaster_address = postmaster@xygenomics.net
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
!include conf2.d/*.conf
```
- 命令行输入`doveconf -n`。查看输出即为dovecot.conf加上conf2.d内的两个配置文件的合集。

## RainLoop Plugin
- 首先登陆RainLoop WebUI管理员界面 mail.xygenomics.net/?admin :admin/test2017 
- 如下图，在插件包中查看已经安装、可按照的插件，如图mysql-password-change是webui没有提供的插件，用于更改密码，需要到官方github下载。 

 ![](http://okj8snz5g.bkt.clouddn.com/blog/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202017-06-02%2017.56.29.png)
- 对于webui没有的插件，比如修改密码插件`mysql-password-change`，上github下载后直接移动到下文目录即可（插件也是php，自动解析）。
- 关于RainLoop的插件：https://github.com/RainLoop/rainloop-webmail/tree/master/plugins。
- 关于`mysql-password-change`的配置：

![](http://okj8snz5g.bkt.clouddn.com/blog/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202017-06-02%2017.58.32.png)
- 点击插件，点击要更改的插件，如图，和后端mysql接口对应，填写数据即可。注意，插件是php自动解析的，只需要在这里填写参数即可使用。
