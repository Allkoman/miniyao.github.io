---
title: Openstack侦探故事2
toc: 1
date: 2017-02-06 17:04:31
tags:
- openstack
- 自行翻译
categories:
- 技术文艺
- 国外转载
permalink: 
---
**原因**：2017年2月6日 翻译外文blog。
**说明**：仅供`个人学习`用途。

<!-- more -->

## Episode 2

在[Episode1](http://minichao.me/2017/02/04/Openstack侦探故事1/)的Openstack侦探故事中，我被叫到犯罪现场：我们的基于OpenStack的私有云中心器件。什么人或什么东西造成了我们的虚拟负载均衡可以拍动高度可用的IP地址。tcpdump显示我有个VRRP包具有时间延迟。这些延迟源于第一个平衡器，主负载均衡器。

在发现罪魁祸首可能是藏在里面的虚拟机，我取来我的助理[sysdig](http://www.sysdig.org)我们ssh登录到为loadblancer01。与sysdig一起，开始提出问题：非常激烈，不舒服的问题，终于到达深层次。

>sysdig是一个相对较新的工具，基本上所有的系统调用的痕迹和使用lua脚本–称为凿子–捕获系统调用序列的结论。总的来说，它就像tcdump一样被系统调用。因为每一个想要做有利事情的进程都需要被系统调用，你的系统的行为非常详细的视图。sysdig发展成锋利的瑞士军刀，你应该尝试一下它；特别是，读这三篇博客了解sysdig的能力，相信我。

sysdig是好的侦探助手，将其立即投入工作，把所有的问题和答案记录在一个文件中。
`$ sysdig -w transcript`
我对发送指令的系统命令，即实际发送keepalived的网络包问题的指令很感兴趣。

>在一个进程被系统调用时，进程暂停直到系统调用已由内核完成，并且只有在执行的过程中恢复。

我感兴趣的是调用，即从用户进程到内核的事件方向。
`$ sysdig -r transcript proc.name=keepalived and evt.type=sendmsg and evt.dir='>'`
这引发了相当多的证据。但我想找到时间差距大于1秒的。我把我的夹克里的Lua从我隐蔽枪套里面拿出，在两条发送信息系统调用之间快速发射了一个凿子。
```shell
$ sysdig -r transcript -c find_time_gap proc.name=keepalived and evt.type=sendmsg and evt.dir='>'
370964 17:01:26.375374738 (5.03543187) keepalived > sendmsg fd=13(192.168.205.8->224.0.0.18) size=40 tuple=0.0.0.0:112->224.0.0.18:0
```
找到了！一个大于5秒的延迟出现在我眼前，我仔细的观看事件号为370964的事件：
```shell
$ sysdig -r transcript proc.name=keepalived and evt.type=sendmsg and evt.dir='>' | grep -C 1 370964
368250 17:01:21.339942868 0 keepalived (10400) > sendmsg fd=13(192.168.205.8->224.0.0.18) size=40 tuple=0.0.0.0:112->224.0.0.18:0
370964 17:01:26.375374738 1 keepalived (10400) > sendmsg fd=13(192.168.205.8->224.0.0.18) size=40 tuple=0.0.0.0:112->224.0.0.18:0
371446 17:01:26.377770247 1 keepalived (10400) > sendmsg fd=13(192.168.205.8->224.0.0.18) size=40 tuple=0.0.0.0:112->224.0.0.18:0
```
现在清晰了，上文中第一行与第二行，远大于1秒的延迟。引起keepalived发送数据延迟的罪犯就隐藏在虚拟机之中，但是，它是谁？

- 经过排除一些无关的旁观者，我发现了这个：
```
$ sysdig -r transcript | tail -n +368250 | grep -v "keepalived\|haproxy\|zabbix"
369051 17:01:23.621071175 3  (0) > switch next=7 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369052 17:01:23.621077045 3  (7) > switch next=0 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369053 17:01:23.625105578 3  (0) > switch next=7 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369054 17:01:23.625112785 3  (7) > switch next=0 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369055 17:01:23.628568892 3  (0) > switch next=25978(sysdig) pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369056 17:01:23.628597921 3 sysdig (25978) > switch next=0 pgft_maj=0 pgft_min=2143 vm_size=99684 vm_rss=6772 vm_swap=0
369057 17:01:23.629068124 3  (0) > switch next=7 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369058 17:01:23.629073516 3  (7) > switch next=0 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369059 17:01:23.633104746 3  (0) > switch next=7 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369060 17:01:23.633110185 3  (7) > switch next=0 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369061 17:01:23.637061129 3  (0) > switch next=7 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369062 17:01:23.637065648 3  (7) > switch next=0 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369063 17:01:23.641104396 3  (0) > switch next=7 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369064 17:01:23.641109883 3  (7) > switch next=0 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369065 17:01:23.645069607 3  (0) > switch next=7 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369066 17:01:23.645075551 3  (7) > switch next=0 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369067 17:01:23.649071836 3  (0) > switch next=7 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369068 17:01:23.649077700 3  (7) > switch next=0 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369069 17:01:23.653073066 3  (0) > switch next=7 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369070 17:01:23.653078791 3  (7) > switch next=0 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369071 17:01:23.657069807 3  (0) > switch next=7 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369072 17:01:23.657075525 3  (7) > switch next=0 pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369073 17:01:23.658678681 3  (0) > switch next=25978(sysdig) pgft_maj=0 pgft_min=0 vm_size=0 vm_rss=0 vm_swap=0
369074 17:01:23.658698453 3 sysdig (25978) > switch next=0 pgft_maj=0 pgft_min=2143 vm_size=99684 vm_rss=6772 vm_swap=0
```
端口号为0与7后的进程任务在消耗虚拟CPU0与7?这些低进程ID指示内核线程！我使用sysdig的管理员权限重复检验了，只为了保证我的猜想是对的。
内核，犯罪者？这个努力工作，永远可靠的家伙？不，我不敢相信。必须有更多。顺便说一下，虚拟机没有被载入。那么虚拟机的内核在做什么……除了…什么都没做？也许它在等待IO！会是这样吗？因为所有的虚拟机硬件，嗯，虚拟的，IO等待只能在裸机的水平。
我离开loadbalancer01的裸机node01。在路上，我试图让我的头思考正在发生的事情。这是怎么回事？这么多的代理，这么多的事情发生在阴影。这么多假嫌疑犯。这不是一个正常的情况。幕后有更恶毒的事情发生。我必须找到它…

后文：[Openstack侦探故事3](http://minichao.me/2017/02/06/Openstack侦探故事3/)

[原文地址](https://blog.codecentric.de/en/2014/09/openstack-crime-story-solved-tcpdump-sysdig-iostat-episode-2/)
