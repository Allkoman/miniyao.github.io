---
title: openldap配置记录
date: 2017-02-04 15:25:12
tags:
- MailServer
categories:
- 搭建记录
- ldap
permalink: 
toc: 1

---
**原因**：2017年2月4日 星期六 MailServer搭建
**说明**：本文主要记录配置`openldap`的过程。

<!-- more -->

## 简介

### 名词介绍
- 什么是ldap?
轻型目录访问协议。具体的说就是得到某些数据的快捷方式，同时ldap也是一个协议，经常被用来作为集体的地址本使用，当然也可以做的更加庞大。可以看成是一种特殊的数据库，不过其在查询上做了很多的优化，所以可以很快的读取到想要的数据。当然它也是有缺陷的，在更新上就会很慢。
- 什么是openldap？
openldap 是一个开源的ldap服务器。

---

### 优点及使用场景

OpenLDAP 目录服务有以下10 个优点：
OpenLDAP 是一个跨平台的标准互联网协议，它基于X.500 标准协议。
OpenLDAP 提供静态数据查询搜索，不需要像在关系数据中那样通过SQL 语句维护数据库信息。
OpenLDAP 基于推和拉的机制实现节点间数据同步，简称复制（replication）并提供基于TLS、SASL 的安全认证机制，实现数据加密传输以及Kerberos 密码验证功能。
OpenLDAP 可以基于第三方开源软件实现负载（LVS、HAProxy）及高可用性解决方案，24 小时提供验证服务，如Headbeat、Corosync、Keepalived 等。
OpenLDAP 数据元素使用简单的文本字符串（简称LDIF文件）而非一些特殊字符，便于维护管理目录树条目。 章
OpenLDAP 可以实现用户的集中认证管理，所有关于账号的变更，只须在OpenLDAP 服务器端直接操作，无须到每台客户端进行操作，影响范围为全局。
OpenLDAP 默认使用协议简单如支持TCP/ZP 协议传输条目数据，通过使用查找操作实现对目录树条目信息的读写操作，同样可以通过加密的方式进行获取目录树条目信息。
OpenLDAP 产品应用于各大应用平台（Nginx、HTTP、vsftpd、Samba、SVN、Postfix、OpenStack、Hadoop 等）、服务器（HP、IBM、Dell 等）以及存储（EMC、NetApp 等）控制台，负责管理账号验证功能，实现账号统一管理。
OpenLDAP 实现具有费用低、配置简单、功能强大、管理容易及开源的特点。
OpenLDAP 通过ACL（Access Control List）灵活控制用户访问数据的权限，从而保证数据的安全性。

---

## 部署

### 下载及安装
- Openstack中镜像，添加VMDK格式镜像。[下载地址](https://www.turnkeylinux.org/openlda)，选择vmdk格式下载后解压，添加images后建立云主机，根据需求分配硬盘cpu内存等信息。进行安装，按照默认设置，设置密码及各项信息后添加float IP, 进行ssh登录验证。
![openldap web ui](http://okj8snz5g.bkt.clouddn.com/blog/openldapwebui.png)
- 安装完毕后即可在openstack的web ui看到openldap的shell了。

### 使用
