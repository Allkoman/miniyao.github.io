---
title: Openstack侦探故事3
toc: 1
date: 2017-02-06 17:04:34
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

## Episode 3

在[Episode2](http://minichao.me/2017/02/06/Openstack侦探故事2/)的Openstack侦探故事中，两个负载平衡器运行在基于OpenStack的云虚拟机，共享一个简单的基于高可用的IP地址开始拍打，来回切换IP地址。在排除虚拟网络错误配置的简单问题后，我终于得到了暗示，问题可能不是来源于虚拟，而在我们的云背后裸露的金属世界。也许高IO是造成VRRP包之间保持间隙的原因。

当我到达虚拟主机loadbalancer01的托管裸机node01，我急于看到IO统计。当虚拟机的消息等待五秒时，机器必须承受大量的IO负载。

我打开我的iostat闪光灯，并且看到：
```shell
$ iostat
Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              12.00         0.00       144.00          0        144
sdc               0.00         0.00         0.00          0          0
sdb               6.00         0.00        24.00          0         24
sdd               0.00         0.00         0.00          0          0
sde               0.00         0.00         0.00          0          0
sdf              20.00         0.00       118.00          0        118
sdg               0.00         0.00         0.00          0          0
sdi              22.00         0.00       112.00          0        112
sdh               0.00         0.00         0.00          0          0
sdj               0.00         0.00         0.00          0          0
sdk              21.00         0.00        96.50          0         96
sdl               0.00         0.00         0.00          0          0
sdm               9.00         0.00        64.00          0         64
```

没有？啥也没有？硬盘上没有IO？也许我更大的闪光灯iotop可以帮上忙：
`$ iotop`

不幸的是，我看到的结果太可怕，因此我决定省略iotop的截图。这纯粹是恐怖。在IO中6个虚拟进程生吃物理CPU。

所以，没有磁盘IO，但是超高的IO造成QEMU。它必须是网络IO。但所有性能计数器几乎没有网络活动。如果这个IO不是真实的，而是虚拟的呢？它可能是虚拟网络驱动程序！它必须是虚拟网络驱动程序。

我检查了Openstack的配置文件，它被设置为使用半虚拟化的网络驱动[vhost_net](http://www.linux-kvm.org/page/VhostNet)。

我检查了在运行的qemu进程，它们也被设置为使用半虚拟化网络vhost_net
```shell
$ ps aux | grep qemu
libvirt+  6875 66.4  8.3 63752992 11063572 ?   Sl   Sep05 4781:47 /usr/bin/qemu-system-x86_64
 -name instance-000000dd -S ... -netdev tap,fd=25,id=hostnet0,vhost=on,vhostfd=27 ...
```
越来越近了！我检查了内核模块，内核模块的vhost_net被加载并激活了。
```shell
$ lsmod | grep net
vhost_net              18104  2
vhost                  29009  1 vhost_net
macvtap                18255  1 vhost_net
```
我检查了qemu-kvm，然后，就僵硬了。。。。
```shell
$ cat /etc/default/qemu-kvm
# To disable qemu-kvm's page merging feature, set KSM_ENABLED=0 and
# sudo restart qemu-kvm
KSM_ENABLED=1
SLEEP_MILLISECS=200
# To load the vhost_net module, which in some cases can speed up
# network performance, set VHOST_NET_ENABLED to 1.
VHOST_NET_ENABLED=0
 
# Set this to 1 if you want hugepages to be available to kvm under
# /run/hugepages/kvm
KVM_HUGEPAGES=0
```
vhost_net被默认禁用qemu-kvm。我们运行的所有数据包通过用户空间和QEMU而传递给内核直接作为vhost_net呢！这就是滞后的来源！

终于解决了~ I did it!

但我不能停在这里。我想知道，是谁干的，可怜的小负载平衡器。谁是这个网络延迟残疾背后的主谋？

我知道只有一种方法可以抓住那个人。我设陷阱。我安装了一个新的，干净的，原始的Ubuntu 14.04在虚拟机中，然后，嗯，然后我等待： apt-get install qemu-kvm完成。

```
$ sudo apt-get install qemu-kvm
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following extra packages will be installed:
  acl cpu-checker ipxe-qemu libaio1 libasound2 libasound2-data libasyncns0
  libbluetooth3 libboost-system1.54.0 libboost-thread1.54.0 libbrlapi0.6
  libcaca0 libfdt1 libflac8 libjpeg-turbo8 libjpeg8 libnspr4 libnss3
  libnss3-nssdb libogg0 libpulse0 librados2 librbd1 libsdl1.2debian
  libseccomp2 libsndfile1 libspice-server1 libusbredirparser1 libvorbis0a
  libvorbisenc2 libxen-4.4 libxenstore3.0 libyajl2 msr-tools qemu-keymaps
  qemu-system-common qemu-system-x86 qemu-utils seabios sharutils
Suggested packages:
  libasound2-plugins alsa-utils pulseaudio samba vde2 sgabios debootstrap
  bsd-mailx mailx
The following NEW packages will be installed:
  acl cpu-checker ipxe-qemu libaio1 libasound2 libasound2-data libasyncns0
  libbluetooth3 libboost-system1.54.0 libboost-thread1.54.0 libbrlapi0.6
  libcaca0 libfdt1 libflac8 libjpeg-turbo8 libjpeg8 libnspr4 libnss3
  libnss3-nssdb libogg0 libpulse0 librados2 librbd1 libsdl1.2debian
  libseccomp2 libsndfile1 libspice-server1 libusbredirparser1 libvorbis0a
  libvorbisenc2 libxen-4.4 libxenstore3.0 libyajl2 msr-tools qemu-keymaps
  qemu-kvm qemu-system-common qemu-system-x86 qemu-utils seabios sharutils
0 upgraded, 41 newly installed, 0 to remove and 2 not upgraded.
Need to get 3631 kB/8671 kB of archives.
After this operation, 42.0 MB of additional disk space will be used.
Do you want to continue? [Y/n] &lt;
...
Setting up qemu-system-x86 (2.0.0+dfsg-2ubuntu1.3) ...
qemu-kvm start/running
Setting up qemu-utils (2.0.0+dfsg-2ubuntu1.3) ...
Processing triggers for ureadahead (0.100.0-16) ...
Setting up qemu-kvm (2.0.0+dfsg-2ubuntu1.3) ...
Processing triggers for libc-bin (2.19-0ubuntu6.3) ...
```

然后，我让陷阱捕捉：

```
$ cat /etc/default/qemu-kvm
# To disable qemu-kvm's page merging feature, set KSM_ENABLED=0 and
# sudo restart qemu-kvm
KSM_ENABLED=1
SLEEP_MILLISECS=200
# To load the vhost_net module, which in some cases can speed up
# network performance, set VHOST_NET_ENABLED to 1.
VHOST_NET_ENABLED=0
 
# Set this to 1 if you want hugepages to be available to kvm under
# /run/hugepages/kvm
KVM_HUGEPAGES=0
```
我不敢相信！这是Ubuntu的默认设置。Ubuntu，我们的云中很基础的东西，尽管现代硬件支持vhost_net默认关掉。Ubuntu被判有罪，我终于可以休息了。

>这是我侦探小说的结尾。我发现和抓获罪犯Ubuntu默认设置并能阻止他进一步削弱我们的虚拟的网络延迟。
请随意留下评论，询问我旅程的细节。我已经谈判出售电影版权。
[原文链接](https://blog.codecentric.de/en/2014/09/openstack-crime-story-solved-tcpdump-sysdig-iostat-episode-3/)