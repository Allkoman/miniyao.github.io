---
title: Openstack侦探故事1
toc: 1
date: 2017-02-04 17:04:28
tags:
- openstack
- 自行翻译
categories:
- 技术文艺
- 国外转载
permalink: 
---
**原因**：2017年2月4日 翻译外文blog。
**说明**：仅供`个人学习`用途。

<!-- more -->

## Episode 1

这是一个关于有时微小的事物可能就是巨大的罪犯的故事。首先最重要的是，这是一个侦探故事。所以跟我来，以一个犯罪现场调查的视角，发现了一个令人难以置信的，近乎是犯罪的默认设置，导致了ubuntu 14.04的虚拟网络性能几乎瘫痪，尤其是延迟方面。

以防你不喜欢侦探故事，防止你们这些书呆子都跑了。我保证你会觉得阅读下去很值得，因为同时这也是一篇介绍keepalived, tcpdump,与sysdig的故事。所以坐回来！继续享受吧。

问题出现的很突然，我们正在为下一代中心器件（CenterDevice）进行一项OpenStack的安装。
>CenterDevice是是一个基于云计算的文件解决方案，我们的客户依靠其24 / 7的可用性。为了实现这种可用性，我们所有的组件都是乘法冗余。例如，我们的负载均衡是两个独立的虚拟机运行HAProxy。这两种情况下管理一个高度可用的IP地址，通过keepalived。

这个系统起初运行得很好。直到负载均衡成为一个邪恶的犯罪的受害者。这两个虚拟机开始拍打他们的高度可用的虚拟IP地址，我们收到了一堆警报电子邮件，但没有明显的变化可以解释该系统的这种行为。

- 这就是故事开始的原因。

当我被叫去调查这一奇怪的行为，回答可怜的负载均衡究竟发生了什么。我开始近近的观察犯罪现场：keepalived，下面的名单是我们虚拟主机loadbalancer01的keepalived的主结构配置文件
``` shell
$ sudo cat /etc/keepalived/keepalived.conf
global_defs {
        notification_email {
                some-e-mail-address@veryimportant.people
        }
        notification_email_from loadbalancer01@protecting.the.innocent.local
        smtp_server 10.10.9.8
        smtp_connect_timeout 30
        router_id loadbalancer01
}
vrrp_script chk_haproxy {
        script "killall -0 haproxy"
        interval 2
        weight 2
}
vrrp_instance loadbalancer {
        state MASTER
        interface eth0
        virtual_router_id 205
        priority 101
        smtp_alert
        advert_int 1
        authentication {
                auth_type PASS
                auth_pass totally_secret
        }
        virtual_ipaddress {
                192.168.205.7
        }
        track_script {
                chk_haproxy
        }
}
```
与这一个相同，第二个负载均衡loadbalancer02的配置文件看起来和通知邮件一模一样，路由器ID以更低的优先级作出相应的改变。这一切看起来很好，很清楚，责任不在keepalived.conf。我需要找到一个不同的理由，为什么这两台虚拟机不断拍打简单的虚拟IP地址。

>现在了解VRRP协议很重要，keepalived用来检查其合作伙伴的工作可用性。所有的合作伙伴不断交换保活包，通过组播地址vrrp.mcast.net分组解析到224.0.0.18。这些数据包使用IP协议号112。如果备份不从目前的主人接收这些保活分组，它假定合伙人死亡，谋杀，或擅离职守并且接管虚拟IP地址，现在作为新的主人。如果老主人决定再次检查，虚拟IP地址再次交换。

因为我们观察这个IP交换的过程，我怀疑虚拟网络非法无视其责任。我立即赶到终点，开始监视网络交通。这似乎很容易，但它比你想象的要复杂得多。下面的图，来自openstack.redhat.com对Neutron创造虚拟网络概述。![OpenStack Neutron Architecture ](http://okj8snz5g.bkt.clouddn.com/blog/Neutron_architecture.png)
因为两个负载均衡在不同的节点上运行，VRRP包从A发送到J并返回Q，那么去哪儿寻找丢失的包？
我决定在A、E和J跟踪包，也许那儿是罪犯躲藏的地方，所以我开始在计算节点node01的loadbalancer01运行tcpdump命令，和网络控制器control01寻找丢失的包。有包，我告诉你。大量的数据包。但我看不见的丢失的数据包，直到我停止了tcpdump：
```shell
$ tcpdump -l host vrrp.mcast.net
...
45389 packets captured
699 packets received by filter
127 packets dropped by kernel
```
Dropped packets by the kernel? 这是我们的罪犯么，很不幸不是。

>tcpdump使用内核中的一个小的缓冲区来存储捕获的数据包。如果太多的新的数据包在用户进程tcpdump可以解码内核之前到达，内核丢掉它们，使新到达的数据包存储在空间内。

这对于当你试图找到数据包的来源以及去向不是很有帮助。但tcpdump有方便的参数b增加这个缓冲区。我再次尝试：
`$ tcpdump -l -B 10000 host vrrp.mcast.net`
好了很多，没有更多被内核丢弃的包。这时，我看到了什么。在VRRP包被倾倒在我的屏幕上时，我注意到，在VRRP存活期间，有时候会有超过一秒的延迟。这让我觉得很奇怪。这与VRRP包默认设置为间隔1秒的参数不相符，并不应该发生。我意识到我发现了什么，只需要更深的发掘。
我让tcpdump给我展示成功的包的时间不同之处，并且查明大于1秒的包的不同之处。
`$ tcpdump -i any -l -B 10000 -ttt host vrrp.mcast.net  | grep -v '^00:00:01'`
![](http://okj8snz5g.bkt.clouddn.com/blog/014608.jpg)
哦，我的上帝.看看上面的截图。有一个延迟超过3，5秒。当然loadbalancer02假定他的伙伴失踪了。
但是等等，延迟在loadbalancer01已经开始？我有点懵逼了！它不是虚拟网络？要掌握简单的主机！但是为什么呢？为什么虚拟机的包要回来？一定有一些邪恶藏在这台机器里，我会发现并面对它…

后文：[Openstack侦探故事2](http://minichao.me/2017/02/06/Openstack侦探故事2/)

[原文地址](https://blog.codecentric.de/en/2014/09/openstack-crime-story-solved-tcpdump-sysdig-iostat-episode-1/)



