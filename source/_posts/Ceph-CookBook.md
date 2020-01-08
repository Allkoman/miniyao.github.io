---
title: Ceph CookBook
toc: 1
date: 2017-05-04 09:58:17
tags:
- Ceph
categories:
- 日常学习
permalink:
---
 **原因**：2017年5月4日 星期四 理解Ceph。
**说明**：阅读书籍。

<!-- more -->

- 官方文档：http://docs.ceph.com/docs/master/rbd/rbd-openstack/
- 块存储、文件储存、对象存储：http://limu713.blog.163.com/blog/static/15086904201222024847744/
- 可靠性、低成本、可扩展
- SDS(软件定义存储-softwate defined storage)
- SDS可以降低存储基础设施的TCO（Total Cost of Ownership）
- 统一存储：由一个单一的系统来提供文件存储和块存储，Ceph能在一个系统中统一地提供块存储、文件存储和对象存储。
- CRUSH算法：Controlled Replication Under Scalable Hashing，数据存储的分布式选择算法。该算法取代了在元数据表中为每个客户端请求进行查找，它计算系统中数据应该被写入或读出的位置。通过计算元数据，就不再需要管理元数据表了。现代高性能计算机可以快速执行CRUSH查找，计算量不大还可以分布到集群的多个节点上。此外CRUSH还独具架构感知功能。同时保存数据的多个副本，增加可靠性和持久性，正是CRUSH算法实现了Ceph的自我管理和自我修复。通过使用CRUSH我们能够设计出一个无单一故障点的高度可靠的存储基础设施。

---

## Ceph——架构概述

<div align="center">![](http://image.yaopig.com/blog/Screen%20Shot%202017-05-11%20at%2015.23.43.png)</div>
- Ceph Monitor（监视器，简称MON）：通过保存一份集群状态映射来维护整个集群的健康状态。分别为每个组件维护映射信息，包括OSD map、MON map、PG map和CRUSH map。所有集群节点都向MON节点汇报状态信息，并分享它们状态中的任何变化。Ceph monitor不存储数据，这是OSD的任务。
- Ceph Object Storage Device（对象存储设备，简称OSD）：只要应用程序向Ceph集群发出写的操作，数据就会被以对象的形式存储在OSD中。这是Ceph集群中唯一能存储用户数据的组件，同时用户也可以发送命令来去读数据。通常一个OSD守护进程会被捆绑到集群中的一块物理磁盘上。所以，在通常情况下，Ceph集群中的物理磁盘的总数，与在磁盘上运行的存储用户数据的OSD守护进程的数量是相同的。
- Ceph Metadata Server（元数据服务器，简称MDS）：MDS只为CephFS文件系统跟踪文件的层次结构和存储元数据。Ceph块设备和RADOS并不需要元数据，因此也不需要Ceph MDS守护进程。MDS不直接提供数据给客户端，从而消除了系统中的故障单点。
- Reliable Autonomic Distributed Object（可靠地自律分布式对象，简称RADOS）：RADOS是Ceph存储集群的基础。在Ceph中，所有的数据都以对象形式存储，并且无论是哪种数据类型，RADOS对象存储都负责保存这些对象。RADOS层可以确保数据始终保持一致。RADOS层可以确保数据始终保持一致。要做到这一点，须执行数据复制、故障检测和恢复，以及数据迁移和在所有集群节点实现再平衡。
- librados：librados库为高级编程语言提供了方便地访问RADOS接口的方式。同时它还为诸如RBD、RGW和CephFS这些组件提供了原生的接口。Librados还支持直接访问RADOS来节省HTTP开销。
- RADOS block device（块设备，简称RBD）：RBD是Ceph块设备，提供持久块存储，它是自动精简配置并可调整大小的，而且将数据分散存储在多个OSD上。RBD服务已经被封装成了基于librados的一个原生接口。
- RADOS gateway（网关接口，简称RGW）：RGW提供对象存储服务。它使用librgw（RADOS Gateway Library）和librados，允许应用程序与Ceph对象存储建立连接。RGW提供了RESTful API。
- Ceph File System（CephFS）：Ceph文件系统提供了一个使用Ceph存储集群存储用户数据的与POSIX兼容的文件系统。和RBD、RGW一样，CephFS服务也基于librados封装了原生接口。

## 规划Ceph的部署
- 下面的图标可以帮助了解Ceph集群：
![](http://image.yaopig.com/blog/Jietu20170504-110428.jpg)

### 环境准备
- 软件需求：VirtualBox、Vagrant、git
- 自行搭建虚拟机环境or使用Vagrant部署，这一部分没难度，不做记录
- 我这里采用Vagrant自动化部署的方式:

```
git clone https://github.com/ksingh7/ceph-cookbook.git
cd ceph-cookbook
vagrant up ceph-node1 ceph-node2 ceph-node3 //包在国外，注意翻墙
vagrant status ceph-node1 ceph-node2 ceph-node3 //The passwd And Account Of this Repository is both `vagrant`
```
- 环境检查：包括hosts、hostname、ip地址、磁盘挂载等的常规检查
- 配置ssh免密登录:

```
ssh-copy-id vagrant@ceph-node2
```

- 关闭防火墙或者打开需要用到的端口。同时禁用Selinux：

```
firewall-cmd --zone=public --add-port=6789/tcp --permanent
firewall-cmd --zone=public --add-port=6800-7100/tcp --permanent
firewall-cmd --reload
firewall-cmd --zone=public --list-all
```
- 在所有机器上配置ntp服务，并设置开机启动：

```
yum install ntp ntpdate -y
#vim /etc/ntp.conf 
#Add server ntp1.aliyun.com //修改server为阿里云ntp服务器
ntpq -p
systemctl restart ntpd.service
systemctl enable ntpd.service
systemctl enable ntpdate.service
```

---
### 安装和配置ceph
- 在ceph-node1上安装ceph，选用你的网络情况下合适的源：

```
sudo yum install ceph-deploy -y
mkdir /etc/ceph & cd /etc/ceph
sudo ceph-deploy new ceph-node1 //创建新的ceph集群
sudo ceph-deploy install --release jewel --repo-url http://mirrors.ustc.edu.cn/ceph/rpm-jewel/el7 --gpg-url http://mirrors.ustc.edu.cn/ceph/keys/release.asc ceph-node1 ceph-node2 ceph-node3 //在所有节点安装ceph二进制软件包

ceph-deploy install --release hammer --repo-url http://mirrors.ustc.edu.cn/ceph/rpm-hammer/el7/ --gpg-url http://mirrors.ustc.edu.cn/ceph/keys/release.asc ceph-node1 ceph-node2 ceph-node3

ceph -v //查看安装好的ceph版本信息
```
- 在ceph-node1上创建第一个Ceph monitor：

```
sudo ceph-deploy mon create-initial
```
- 创建mon后可以使用`ceph -s`或者`ceph status`查看ceph状态，这时状态为不健康
- 在ceph-node1上创建osd：date

```
sudo ceph-deploy disk list ceph-node1 //列出所有可用磁盘
sudo ceph-deploy disk zap ceph-node1:sdb ceph-node1:sdc ceph-node1:sdd //删除现有分区表和磁盘内容
sudo ceph-deploy osd create ceph-node1:sdb ceph-node1:sdc ceph-node1:sdd //准备磁盘
```

- 这时查看ceph状态可以看到osdmap后面为3

### 扩展ceph集群
- 上一步在ceph-node1创建了一个mon及3个osd。这里通过添加ceph-node2和ceph-node3作为mon和osd节点来扩展集群，mon应为奇数个且至少为1个，这是为了高可用性，毕竟mon的工作是监视器，奇数的个数才能在监控时形成有效的仲裁策略，使用Paxos算法来确保仲裁的一致性
- 在ceph-node1上将公共网络的地址添加到地址文件`/etc/ceph/ceph.conf`
- 这里的公共网络即为`/etc/hosts`中各个节点连接的网络，并非连接公网的公网。

```
public network = 192.168.1.0/24 //根据你实际网络情况填写，比如我node1网络为192.168.1.101
```
- 在ceph-node1使用deploy工具部署monitor到ceph-node2与ceph-node3：

```
cd /etc/ceph
sudo ceph-deploy mon create ceph-node2
sudo ceph-deploy mon create ceph-node3
```
- 这时查看ceph状态可以看到monmap后面为3，可使用`ceph mon stat`查看具体的mon节点名以及ip等信息。
- 这时仿照ceph-node1创建osd的过程在ceph-node2.ceph-node3上创建osd

```
sudo ceph-deploy disk list ceph-node2 ceph-node3 //列出所有可用磁盘
sudo ceph-deploy disk zap ceph-node2:sdb ceph-node2:sdc ceph-node2:sdd
sudo ceph-deploy disk zap ceph-node3:sdb ceph-node3:sdc ceph-node3:sdd //删除现有分区表和磁盘内容
sudo ceph-deploy osd create ceph-node2:sdb ceph-node2:sdc ceph-node2:sdd
sudo ceph-deploy osd create ceph-node3:sdb ceph-node3:sdc ceph-node3:sdd //准备磁盘
```
- 在添加更多的osd后需要调整rbd存储池的pg_num和pgp_num来使ceph为health状态：

```
sudo ceph osd pool set rbd pg_num 256
sudo ceph osd pool set rbd pgp_num 256
```
- 这时查看ceph状态，为health，3个mon,9个osd。

---

### 实践中使用ceph集群
- 简单的命令来体验ceph集群：
```
#1.检查ceph安装状态
ceph -s
ceph status //同上
#2.观察集群健康状况
ceph -w
#3.检查Ceph monitor仲裁状态
ceph quorum_status --format json-pretty
#4.导出Ceph monitor状态
ceph mon dump
#5.检查集群使用状态
ceph df
#6.检查Ceph monitor、OSD 和 PG（配置组）状态：
ceph mon stat
ceph osd stat
ceph pg stat
#7.列表PG
ceph pg dump
#8.列表Ceph存储池
ceph osd lspools
#9.检查OSD的CRUSH map：
ceph osd tree
#10.列表集群的认证密钥
ceph auth list
```

>仲裁quorom
Quorom 机制，是一种分布式系统中常用的，用来保证数据冗余和最终一致性的投票算法，其主要数学思想来源于鸽巢原理。

---

## 使用Ceph块存储
### 配置Ceph客户端
- 配置机器并设置好hostname为client-node1，设置网络为192.168.1.100，并登陆设置好ntp服务
- 安装python-minimal，配置sudoers文件免密码并给予ceph用户权限
- 登陆ceph-node1机器并拷贝ssh：

```
ssh-copy-id ceph@client-node1
```
- 在ceph-node1上使用ceph-deploy工具把Ceph二进制程序安装到client-node1上，分别为ustc与163的源（其实这部分网速好的直接安装就好，这里用到的国外源没被屏蔽，只是慢！）：

```
sudo ceph-deploy --username ceph install  --release jewel --repo-url http://mirrors.ustc.edu.cn/ceph/rpm-jewel/el7 --gpg-url http://mirrors.ustc.edu.cn/ceph/keys/release.asc client-node1
```

```
sudo ceph-deploy --username ceph install  --release jewel --repo-url http://mirrors.163.com/ceph/rpm-jewel/el7/x86_64/ --gpg-url http://mirrors.163.com/ceph/keys/release.asc client-node1


```

- 将Ceph的配置文件复制到client-node1上：

```
sudo ceph-deploy --username ceph config push client-node1
```

- 创建Ceph用户client.rbd，并给予访问rbd存储池的权限：

```
sudo ceph auth get-or-create client.rbd mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=rbd'
```

- 为client-node1上的cleint.rbd用户添加密钥：

```
sudo ceph auth get-or-create client.rbd | ssh ceph@client-node1 sudo tee /etc/ceph/ceph.client.rbd.keyring
```

- 通过这一步，client-node1应该准备好充当Ceph客户端了，提供用户名以及密钥在client-node1上检查集群状态：

```
ssh ceph@client-node1
sudo su 
cat /etc/ceph/ceph.client.rbd.keyring >> /etc/ceph/keyring
ceph -s --name client.rbd
```

### 创建Ceph块设备
- 创建一个名为rbd1的，大小为10240MB的RADOS块设备：

```
rbd create rbd1 --size 10240 --image-format 2 --image-feature layering --name client.rbd //centos7.3内核只支持layering特性
rbd create rbd1 --size 20480 --name client.rbd
```

- 这里内核版本低的仅支持layering特性，涵盖（ubuntu 16.04 centos7.3）
- 多种方法列出RBD镜像：

```
rbd ls --name client.rbd
rbd ls -p rbd --name client.rbd
rbd list --name client.rbd
```
- 检查RBD镜像细节：

```
rbd --image rbd1 info --name client.rbd
```

### 映射Ceph块设备
- 现在我们已经在Ceph集群上创建了一个块设备，要使用它，我们要将它映射到客户机。要做到这一点，要在client-node1上执行下面的命令：
- 映射块设备到client-node1:

```
rbd map --image rbd1 --name client.rbd
```
- 检查被映射的块设备：

```
rbd showmapped --name client.rbd
```
- 要使用这个块设备，我们需要创建并挂在一个文件系统：

```
fdisk -l /dev/rbd0
mkfs.xfs /dev/rbd0
mkdir /mnt/ceph-disk1
mount /dev/rbd0 /mnt/ceph-disk1
df -h /mnt/ceph-disk1
```
- 要在机器重启后映射该设备，你需要在系统启动中添加init-rbdmap脚本，并且将Ceph用户和keyring详细信息添加到/etc/ceph/rbdmap，最后更新/etc/fstab文件：

```
wget https://raw.githubusercontent.com/ksingh7/ceph-cookbook/master/rbdmap -O /etc/init.d/rbdmap
chmod +x /etc/init.d/rbdmap
update-rc.d rbdmap defaults //ubuntu
chkconfig rbdmap on //centos
# cat /etc/ceph/keyring可获得你ceph的keyring
echo "rbd/rbd1 id=rbd,key = AQCYjBFZX8zLDxAAT7c3Azx/iuZLZh8ZYhs/JQ==" >> /etc/ceph/rbdmap
echo "/dev/rbd0 /mnt/ceph-disk1 xfs defaults, _netdev0 0" >> /etc/fstab
mkdir /mnt/ceph-disk1
/etc/init.d/rbdmap start
```
 
### 调整Ceph RBD 大小
- Ceph支持精简配置的块设备，这意味着，直到你开始在块设备上存储数据前，物理存储空间都不会被占用，你可以在Ceph存储端增加或减少RBD的大小。然而，底层文件系统应支持调整大小。高级文件系统，如XFS、Btrfs、EXT、ZFS和其他文件系统都在一定程度上支持调整大小的调整。
- 要增加或减少RBD镜像的大小，使用`rbd resize`命令的`--size<NEW_SIZE_IN_MB>参数`
- 下面将刚才创建的10G大小的RBD镜像扩大到20G

```
rbd resize --image rbd1 --size 20480 --name client.rbd
rbd info --image rbd1 --name client.rbd 
```
- 当我们要扩展文件系统来来利用增加的存储空间时，修改文件系统的大小是操作系统和设备文件系统的一个特性，调整分区前请查看文档，这里的XFS支持在线调整大小：

```
dmesg | grep -i capacity
xfs_growfs -d /mnt/ceph-disk1
```

### 使用RBD快照
- Ceph全面支持快照，这些快照是在某时间点上生成的只读的RBD镜像副本。你可以通过创建和恢复快照来保持RBD镜像的状态以及从快照恢复原始数据。
- 首先查看Ceph是如何工作的，在我们创建好的rbd1块设备上创建一个文件：

```
echo "Hello Ceph This is snapshot test" > /mnt/ceph-disk1/snapshot_test_file
ls -l /mnt/ceph-disk1
cat /mnt/ceph-disk1/snapshot_test_file
```
- 为Ceph块设备创建快照：

```
rbd snap create <pool-name>/<image-name>@<snap-name> 语法
rbd snap create rbd/rbd1@snapshot1 --name client.rbd
```
- 列出镜像快照的命令如下：

```
rbd snap ls rbd/rbd1 --name client.rbd
```
- 为了测试快照的恢复功能，我们在文件系统中删除一些文件：

```
rm -f /mnt/ceph-disk1/*
```
- 现在我们将恢复CephRBD快找来找回我们之前删除的文件，回滚操作会使用快照版本来覆盖当前版本的RBD镜像和里面的数据，操作需要谨慎：

```
rbd snap rollback rbd/rbd1@snapshot1 --name client.rbd
```
- 快照回滚操作后，重挂载CephRBD文件系统并刷新其状态后你会发现删除的文件都被恢复了：

```
apt install ruby-sprite-factory
umount /mnt/ceph-disk1
mount /dev/rbd0 /mnt/ceph-disk1
ls -l /mnt/ceph-disk1
```
- 当你不再需要使用某快照时，可用下面的语法删除指定的快照，删除快照不会影响当前CephRBD镜像上的数据：

```
rbd snap rm rbd/rbd1@snapshot1 --name client.rbd
```

- 如果RBD镜像有多个快照，并且你希望用一条命令删除所有的快照，可以使用purge子命令：

```
rbd snap purge rbd/rbd1 --name client.rbd
```


### 使用RBD克隆
- Ceph支持一个很好的特性即为COW方式从RBD快照创建克隆，在Ceph中这也被成为快照分层，这一特性仅在format-2类型镜像中可以使用，但通常镜像为format-1
- 为了演示RBD克隆，特意创建一个format-2类型的RBD镜像，然后创建一个快照保护它，再通过快照创建一个COW克隆。
- 1 .创建format-2类型的RBD镜像，并检查它的细节：

```
rbd create rbd2 --size 10240 --image-format 2 --image-feature layering --name client.rbd
rbd info --image rbd2 --name client.rbd
```
- 2 .创建这个RBD镜像的快照：

```
rbd snap create rbd/rbd2@snapshot_for_cloning --name client.rbd
```
- 3 .要创建COW克隆，首先要保护这个快照，不然当快照被删除时，依赖于它的COW都会被摧毁：

```
rbd snap protect rbd/rbd2@snapshot_for_cloning --name client.rbd
```
- 4 .接下来我们通过快照创建一个克隆的RBD镜像：

```
rbd clone <pool-name>/<parent-image>@<snap-name><pool-name>/<child-image-name> //语法
rbd clone rbd/rbd2@snapshot_for_cloning rbd/clone_rbd2 --name client.rbd
```
- 5 .创建克隆是一个很快的过程。一旦完成则可检查镜像的信息，你会注意到它的父存储池、镜像和快照信息如下：

```
rbd info rbd/clone_rbd2 --name client.rbd
```
- 6 .现在已经克隆了一个依赖于父镜像快照的RBD镜像，为了让这个克隆独立于父镜像，我们需要将父镜像中的信息合并到子镜像。操作时间取决于父镜像当前数据量的大小，而合并完成时父子镜像之间不会存在任何依赖关系：

```
rbd flatten rbd/clone_rbd2 --name client.rbd
rbd info --image clone_rbd2 --name client.rbd
```

- 7 .如果你不在使用父镜像，你可以移除它，首先要做的是解除它的保护状态：

```
rbd snap unprotect rbd/rbd2@snapshot_for_cloning --name client.rbd
rbd snap rm rbd/rbd2@snapshot_for_cloning --name client.rbd
```

### Openstack简介
- Openstack提供了企业级的基础架构即服务（Infrastructure-as-a-Service，IaaS）已满足你所有的云需要。
- 本章重点关注Cinder和Glance（介绍就略了，[官网传送门](http://www.openstack.org/))

### 配置Openstack为Ceph客户端
```
sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sudo yum install -y https://rdoproject.org/repos/rdo-release.rpm
sudo yum install -y centos-release-openstack-ocata
sudo yum update -y
sudo yum install -y openstack-packstack
sudo packstack --allinone
```

```
ceph osd pool create images 128
ceph osd pool create volumes 128
ceph osd pool create vms 128
```

```
sudo ceph auth get-or-create client.cinder mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=volumes,allow rwx pool=vms,allow rx pool=images'
sudo ceph auth get-or-create client.glance mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=images'
```

```
sudo ceph auth get-or-create client.glance | ssh root@os-node1 sudo tee /etc/ceph/ceph.client.glance.keyring 
sudo ceph auth get-or-create client.cinder | ssh root@os-node1 sudo tee /etc/ceph/ceph.client.cinder.keyring

sudo chown glance:glance /etc/ceph/ceph.client.glance.keyring
sudo chown cinder:cinder /etc/ceph/ceph.client.cinder.keyring
```

```
sudo ceph auth get-key client.cinder | ssh root@os-node1 tee /etc/ceph/temp.client.cinder.key
```

```
ssh root@os-node1
cd /etc/ceph
ceph -s --name client.cinder --keyring ceph.client.cinder.keyring
ceph -s --name client.glance --keyring ceph.client.glance.keyring
```

```
cd /etc/ceph
uuidgen //生成随机uuid：4689f4f4-5964-4715-af62-3b6480eb94c1
cat > secret.xml << EOF
<secret ephemeral='no' private='no'>
    <uuid>4689f4f4-5964-4715-af62-3b6480eb94c1</uuid>
    <usage type='ceph'>
        <name>client.cinder secret</name>
    </usage>
</secret>
EOF
virsh secret-define --file secret.xml //virsh secret-undefine uuid
```

```
virsh secret-set-value --secret 4689f4f4-5964-4715-af62-3b6480eb94c1 --base64 $(cat temp.client.cinder.key) && rm temp.client.cinder.key secret.xml
virsh secret-list
```

### 配置Ceph作为glance后端存储
- 首先登陆到openstack-node1节点，我这hostname为os-node1。编辑`/etc/glance/glance-api.conf`文件，在[DEFAULT]部分添加代码如下：

```
default_store = rbd
show_image_direct_url=True
```
- 验证是否添加成功：

```
cat /etc/glance/glance-api.conf | egrep -i "default_store|image_direct"
```
- 在[glance_store]部分添加代码如下：

```
stores = rbd
rbd_store_ceph_conf=/etc/ceph/ceph.conf
rbd_store_user=glance
rbd_store_pool=images
rbd_store_chunk_size=8
```
- 验证是否添加成功：

```
cat /etc/glance/glance-api.conf | egrep -v "#default" | grep -i rbd
```
- 随后重启glance服务：

```
service openstack-glance-api restart
```
- 列出现有的glance image

```
source /root/keystonerc_admin
glance image-list
```
- 从网上下载镜像由于测试：

```
wget http://download.cirros-cloud.net/0.3.1/cirros-0.3.1-x86_64-disk.img
```
- 使用命令创建新的镜像，并检验是否创建成功：

```
glance image-create --name cirros_image  --disk-format=qcow2 --container-format=bare < cirros-0.3.1-x86_64-disk.img
glance image-list
```
- 通过Ceph的镜像池中查询镜像的ID来验证我们新添加的镜像：

```
rados -p images ls --name client.glance --keyring /etc/ceph/ceph.client.glance.keyring | grep -i id 
```
- 使用新添加的镜像创建虚拟机：

```
nova boot --flavor 1 --image e778db95-bad8-41ab-a6f1-4927c9dc87b7 vm1
```

### 配置Ceph为Cinder后端存储
- Openstack的Cinder程序为虚拟机提供了块存储。在本节中我们将配置Ceph作为Openstack Cinder的后端存储。Openstack Cinder需要一个驱动程序与Ceph的块设备进行交互。
- 1 .在这个操作演示中没有使用多个Cinder后端存储配置，编辑/etc/cinder/cinder.conf文件，注释掉`enabled_backends`
- 2 .在cinder.volime.drivers.rbd选项部分，添加如下配置选项(uuid替换为上文自己随机生成的值)：

```
volume_driver = cinder.volume.drivers.rbd.RBDDriver
rbd_pool=volumes
rbd_ceph_conf=/etc/ceph/ceph.conf
rbd_flatten_volume_from_snapshot=false
rbd_max_clone_depth=5
rbd_store_chunk_size=4
rados_connect_timeout=-1
glance_api_version=2
rbd_user=cinder
rbd_secret_uuid=6dd3cd39-a1e1-49b9-82a3-c91ee3530d48
```
- 3 .执行以下命令来验证：

```
cat /etc/cinder/cinder.conf | egrep "rbd|rados|version"|grep -v "#"
```
- 4 .重新启动Openstack Cinder服务： 

```
service openstack-cinder-volume restart 
service openstack-cinder-api restart 
service openstack-cinder-backup restart
```
- 5 .查看cinder列表：

```
source keystonerc_admin
cinder list
```
- 6 .创建新的cinder卷：

```
cinder create --display-name ceph-volume1 --display-description "Cinder volume on CEPH storage " 2
```
- 7 .列出Ceph和Cinder存储池来查看这个卷：

```
cinder list
rados -p volumes --name client.cinder --keyring ceph.client.cinder.keyring ls | grep -i id 
```


### 将Ceph RBD挂载到Nova上：
- 要挂载Ceph RBD到Openstack实例，我们需要配置Openstack Nova模块，添加它访问Ceph集群所需要的rbd用户和uuid信息。
- 1 .找到`/etc/nova/nova.conf`中的nova.virt.libvirt.volume选项部分，添加以下代码：

```
rbd_user=cinder
rbd_secret_uuid=4689f4f4-5964-4715-af62-3b6480eb94c1
```
- 2 .重新启动Openstack Nova服务：

```
service openstack-nova-compute restart
```

- 3 .下面将Cinder挂载到Openstack实例上：

```
nova list
cinder list
nova volume-attach d6ae1f6c-3a67-45ac-a495-0e660bfa4cbe c54ce4df-5a60-462b-9a93-b76f467bfa4d
cinder list

```

### Nova基于Ceph RBD启动实例
- 1 .浏览[libvirt]部分并添加以下内容：

```
inject_partition = -2
images_type = rbd
images_rbd_pool = vms
images_rbd_ceph_conf = /etc/ceph/ceph.conf
```

```
cat /etc/nova/nova.conf | egrep "rbd|partition" | grep -v '#'
```

```
qemu-img convert -f qcow2 -O raw cirros-0.3.1-x86_64-disk.img cirros-0.3.1-x86_64-disk.raw
```

```
glance image-create --name cirros_raw_image  --disk-format=raw --container-format=bare < cirros-0.3.1-x86_64-disk.raw
glance image-list
```

```
cinder create --image-id 9f175ca3-8e6c-462e-ab3c-5b12dff82f49  --display-name cirros-ceph-boot-volume 1 
```

```
nova boot --flavor 1 --block-device-mapping vda=29aa621b-5e13-4bbe-9a66-cdab52d41c63::1 --image  9f175ca3-8e6c-462e-ab3c-5b12dff82f49 vm2 
```

### 删除pool与认证的方法：
```
sudo ceph auth del client.glance
sudo ceph auth del client.cinder
sudo ceph osd pool delete volumes volumes --yes-i-really-really-mean-it
sudo ceph osd pool delete images images --yes-i-really-really-mean-it
sudo ceph osd pool delete vms vms --yes-i-really-really-mean-it
sudo ceph osd pool delete backups backups --yes-i-really-really-mean-it
```

--- 

## 使用Ceph对象存储
- 对象存储将数据以对象形式存储，而不是以传统的文件和数据块的形式存储，每个对象都要存储数据、元数据和一个唯一的标识符。

### 理解Ceph对象存储
- 对象存储不能像文件系统的磁盘那样被操作系统直接访问。相反，它只能通过API在应用层面被访问，Ceph是一个分布式对象存储系统，该系统通过建立在Ceph RADOS层之上的Ceph对象网关RGW接口提供对象存储接口，RGW使用librgw和librados，允许应用程序与Ceph对象存储建立连接，该RGW为应用提供了与RESTful S3/Swift兼容的API接口，以在Ceph集群中存储对象格式的数据。Ceph还支持多对象存储，通过RESTful API存取。
- librados软件库非常灵活，允许用户应用程序通过C、C++、Java、Python和PHP绑定直接访问Ceph存储集群。Ceph对象存储还具有多站点功能，也就是说，它提供了灾难恢复解决方案。

### RADOS网关标准设置、安装和配置
- 在生产环境中，建议在物理专用服务器上配置RGW。RGW是一个从外面连接到Ceph集群的独立服务，向它的客户端提供对象访问。在生产环境中，我们建议在负载均衡器后面运行多个RGW实例。

### 搭建RADOS 网关节点
- 要运行Ceph对象存储服务，我们需要一个正在运行的Ceph集群，并且RGW节点必须能够访问Ceph网络。

### 操作指南
- 启动虚拟机
- 创建keyring,为RGW实例生成网关用户和密钥，我们在RGW实例名是gateway：

```
cd /etc/ceph
ceph-authtool --create-keyring /etc/ceph/ceph.client.radosgw.keyring
chmod +r /etc/ceph/ceph.client.radosgw.keyring
ceph-authtool /etc/ceph/ceph.client.radosgw.keyring -n client.radosgw.gateway --gen-key
```
- 为密钥添加权限

```
ceph-authtool -n client.radosgw.gateway --cap osd 'allow rws' --cap mon 'allow rwx' /etc/ceph/ceph.client.radosgw.keyring
```
- 将密钥添加到Ceph集群：

```
ceph auth add client.radosgw.gateway -i /etc/ceph/ceph.client.radosgw.keyring
```
- 将秘钥分配给Ceph集群：

```
scp /etc/ceph/ceph.client.radosgw.keyring rgw-node1:/etc/ceph/ceph.client.radosgw.keyring
```
- 在rgw-node1的ceph.conf中添加如下内容：

```
[client.radosgw.gateway]
host = rgw-node1
keyring = /etc/ceph/ceph.client.radosgw.keyring
rgw socket path = /var/run/ceph/ceph.radosgw.gateway.fastcgi.sock
log file = /var/log/ceph/client.radosgw.gateway.log
rgw dns name = rgw-node1
rgw print continue = false
```
- 将默认用户由apache改为root：

```
sed -i s"/DEFAULT_USER.*=.*'apache'/DEFAULT_USER='root'"/g /etc/rc.d/init.d/ceph-radosgw
```
- 重启ceph的radosgw服务并验证：

```
ceph -s -k /etc/ceph/ceph.client.radosgw.keyring --name client.radosgw.gateway
```

### 创建radosgw用户（这一步为S3的参考部分）
- 为S3访问创建RADOS网关用户：

```
radosgw-admin user create --uuid="testuser" --display-name="First User"
```

```
radosgw-admin subuser create --uid=testuser --subuser=testuser:swift --access=full
```

```
radosgw-admin key create --subuser=testuser:swift --key-type=swift --gen-secret
```

```
sudo apt-get install python-setuptools
sudo easy_install pip
sudo pip install --upgrade setuptools
sudo pip install --upgrade python-swiftclient
```

```
swift -A http://192.168.1.106:7480/auth/1.0 -U testuser:swift -K EQetFsHWwz5AgIQPxVeshKBFjqTdgSdXcSEOVGrP list
```

### openstack之keystone与ceph
- source admin_key //key位于/root目录下
- openstack endpoint list
- 删除swift的认证

```
openstack endpoint delete 5f4ebe3e6e9a49579a62990f3a9f880b
openstack endpoint delete 6825c8ebfc6245d4b2bab958ca6ca72e
openstack endpoint delete 6983844d8c87442eb21f0f1c6d9b1612
```
- 创建新的endpoint指向rgw-node1的rgw-gateway端口：

```
openstack endpoint create --region RegionOne swift public http://192.168.1.106:7480/swift/v1
openstack endpoint create --region RegionOne swift internal http://192.168.1.106:7480/swift/v1
openstack endpoint create --region RegionOne swift admin http://192.168.1.106:7480/swift/v1
```
- 查看admin_token

```
cat /etc/keystone/keystone.conf | grep -i admin_token
admin_token = a3a1eed3fa424ad3b58fe9d554f6c15c
mkdir -p /var/ceph/nss
```

---
- 后续未成功：

```
openssl x509 -in /etc/keystone/ssl/certs/ca.pem -pubkey |  certutil -d /var/ceph/nss -A -n ca -t "TCu,Cu,Tuw"
openssl x509 -in /etc/keystone/ssl/certs/signing_cert.pem -pubkey | \
        certutil -A -d /var/ceph/nss -n signing_cert -t "P,P,P"
```
