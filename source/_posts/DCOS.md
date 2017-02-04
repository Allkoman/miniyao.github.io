---
title: Mesosphere Data Center Operation Systeam
date: 2016-11-29 23:10:25
categories:
- 工作日常
- 服务器集群架构
tags:
- Angularjs
permalink: Cwork
toc: 1
---

**原因**：2016年11月29日 星期二 架设`DCOS`（Data Center Operation Systeam）。
**说明**：本文主要记录DCOS架设过程中的问题与解决办法。
<!-- more -->

## 简介

---
### 百度百科
>数据中心操作系统（DCOS）是为整个数据中心提供分布式调度与资源协调功能，实现数据中心级弹性伸缩能力的软件堆栈，它将所有数据中心的资源当做一台计算机来调度和管理。

>数据中心操作系统（DCOS）是为整个数据中心提供分布式调度与协调功能，实现数据中心级弹性伸缩能力的软件堆栈，它将所有数据中心的资源当做一台计算机来调度。

>大规模应用的数据中心操作系统有：Google Borg/Omega系统和Twitter、Apple、Netflix等公司基于Mesos构建的系统。
可以用于数据中心操作系统构建的开源解决方案有：
- 1) Mesos：Mesos最早由美国加州大学伯克利分校AMPLab实验室开发，后在Twitter、Apple、Netflix等互联网企业广泛使用，成熟度高。其中，Mesosphere公司DCOS产品，就是以Mesos为核心，支持多领域的分布式集群调度框架，包括Docker容器集群调度框架Marathon、分布式 Cron（周期性执行任务）集群调度框架Chronos和大数据的主流平台Hadoop和Spark的集群调度框架等，实现系统的资源弹性调度。
- 2) Apache Hadoop YARN：Apache Hadoop YARN一种新的 Hadoop 资源管理器，它是一个通用资源管理系统，可为上层应用提供统一的资源管理和调度。
- 3) Kubernetes：Kubernetes是Google多年大规模容器管理技术的开源版本，面世以来就受到各大巨头及初创公司的青睐，社区活跃。
- 4) Docker Machine + Compose + Swarm：Docker公司的容器编排管理工具。
- 5) 此外，CloudFoundry/OpenShift等PaaS产品也可以作为DCOS的解决方案。
---

### 官网介绍及理解
>[DC/OS](https://dcos.io) is based on the production proven Apache Mesos distributed systems kernel, combining years of real-life experience with best practices for building and running modern applications in production.

>DCOS（数据中心操作系统）即是Mesos的“核心”与其周边的服务及功能组件所组成的一个生态系统。例如像mesos-dns这样的插件模块，类似一个CLI，一个GUI又或者是提供你想运行的所有的包的仓库等工具，以及像Marathon（又名分布式的init）、Chronos（又名分布式的cron）这样的框架等等。

>顾名思义，它即是意味着一个跨越在数据中心或者云环境所有主机之上的操作系统。DCOS 可以运行在任意的现代Linux环境，公有或私有云，虚拟机甚至是裸机环境。（当前所支持的平台有：亚马逊AWS、谷歌GCE、微软Azure、OpenStack、Vmware、RedHat、CentOS、CoreOS以及Ubuntu）。迄今为止，DCOS 在其公有仓库上已经提供了多达40余种服务组件（Hadoop、Spark、Cassandra、Jenkins、Kafka、MemSQL等等）。

---
## 环境搭建
这里的准备工作是面向物理机器的，如果是虚拟机安装进行学习测试请看后面的dcos_vagrant。

---
### 安装Linux系统
镜像版本：ubuntu-16.04-desktop-amd64
- master的安装，系统为English语言，English键盘，用户名为master，密码为123。
- 将安装好的master虚拟机进行备份，并克隆出slave1-3这3个节点虚拟机。
- 将clone出来的master镜像分别改为slave1-3hostname及用户名。
- 进入root 用户,分别增加用户，如下：

```bash
useradd -d /home/slave1 -s /bin/bash -m slave1  //创建新用户
passwd slave1   //为新用户设置密码
chmod u+w /etc/sudoers  //为新用户添加sudo权限
nano /etc/sudoers
chmod u-w /etc/sudoers //结束赋权，重启
userdel -r master //删除克隆过来的用户master
```

- 修改host名：

```bash
sudo nano /etc/hostname //将用户名修改为slave1
sudo nano /etc/hosts //修改域名地址
```

- 修改hosts图：

![hosts1](http://okj8snz5g.bkt.clouddn.com/blog/dcoslinux.png)
![hosts2](http://okj8snz5g.bkt.clouddn.com/blog/dcoslinux2.png)
上图为slave1节点，下图为master的hosts，修改后重启机器
- 分别安装 `sudo apt-get install openssh-client openssh-server`

---


