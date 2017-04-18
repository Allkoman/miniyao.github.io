---
title: Ceph理解
toc: 1
date: 2017-04-14 10:23:00
tags:
- Ceph
categories:
- 工作日常
permalink:
---
**原因**：2017年4月14日 星期五 学习记录。
**说明**：整理ceph资料。
<!-- more -->
## 前言
- 2006年Sage Weil发表了Ceph论文，启动一个伟大的开源项目ceph。
- 本文参考文献过多，包含github开源项目，UnitedStack项目等不一一引述。
- 本书主要引述于[tobe](https://github.com/tobegit3hub/ceph_from_scratch)的`《Ceph From Scratch》`一书。

---
## Ceph简介
- Ceph的设计思路以及基本组件，用于理解Ceph的架构设计、CRUSH、RADOS等概念，并且知道基于Ceph的RBD、RGW和CephFS等服务。

---
### 架构介绍
- Ceph is a distributed object, block, and file storage platform.
- 也就是说，使用Ceph系统我们可以提供对象存储、块设备存储和文件系统服务，更有趣的是基于Ceph的key-value存储和NoSQL存储也在开发中，让Ceph成为目前最流行的统一存储系统。
Ceph底层提供了分布式的RADOS存储，用与支撑上层的librados和RGW、RBD、CephFS等服务。Ceph实现了非常底层的object storage，是纯粹的SDS，并且支持通用的ZFS、BtrFS和Ext4文件系统，能轻易得Scale，没有单点故障。
- 接下来马上介绍Ceph的各个基础组件。

---
### 基础组件
- __Object__ : Ceph最底层的存储单元是Object对象，每个Object包含元数据和原始数据。
- __OSD__ : OSD全称Object Storage 
- __Device__ : 是负责响应客户端请求返回具体数据的进程。一个Ceph集群一般都有很多个OSD。
- __PG__ : PG全称Placement Grouops，是一个逻辑的概念，一个PG包含多个OSD。引入PG这一层其实是为了更好的分配数据和定位数据。
- __Monitor__ : 一个Ceph集群需要多个Monitor组成的小集群，它们通过Paxos同步数据，用来保存OSD的元数据。
- __RADOS__ : RADOS全称Reliable Autonomic Distributed Object 
- __Store__ : 是Ceph集群的精华，用户实现数据分配、Failover等集群操作。
- __Libradio__ : Librados是Rados提供库，因为RADOS是协议很难直接访问，因此上层的RBD、RGW和CephFS都是通过librados访问的，目前提供PHP、Ruby、Java、Python、C和C++支持。
- __CRUSH__ : CRUSH是Ceph使用的数据分布算法，类似一致性哈希，让数据分配到预期的地方。
- __RBD__ : RBD全称RADOS block device，是Ceph对外提供的块设备服务。
- __RGW__ : RGW全称RADOS gateway，是Ceph对外提供的对象存储服务，接口与S3和Swift兼容。
- __MDS__ : MDS全称Ceph Metadata Server，是CephFS服务依赖的元数据服务。
- __CephFS__ : CephFS全称Ceph File System，是Ceph对外提供的文件系统服务。

---
### 更多介绍
- 前面对Ceph各个组件都简要介绍了一下。而最重要的RADOS的设计和CRUSH算法的使用，后面会有更详细的介绍。
- 要想学好Ceph，最重要是实践。

---
## Ceph用法
- 本章将带领大家一步一步使用Ceph，分布式系统的安装和部署一般都是非常复杂的，而且很多教程不一定适用于本地的环境，我们本章所有代码与命令都使用官方提供Docker容器，保证任何人都能轻易地使用Ceph并且得到预期的结果。
- 通过本章大家都可以掌握Ceph的基本操作命令，基于Ceph搭建自己的存储系统。

![](http://okj8snz5g.bkt.clouddn.com/blog/ceph_usage.png)

---
### Ceph容器
__使用Docker__
- 使用Ceph最简单的方法是启动Ceph容器，使用前必须保证本地已经安装好Docker。Debian/Ubuntu用户可以通过apt-get install docker.io安装，CentOS/Redhat用户可以通过yum install docker安装，Mac和Windows建议下载boot2docker来使用。
- 基本的docker命令如下：

```
docker images
docker pull ubuntu
docker run -i -t ubuntu /bin/bash
docker exec -i -t ubuntu /bin/bash
docker ps
```

---

__Ceph容器__
- Ceph社区提供了官方的docker镜像，代码与教程都托管到Github：https://github.com/ceph/ceph-docker
- 自动化部署教程：https://www.youtube.com/watch?v=FUSTjTBA8f8&feature=youtu.be
- Ansible部署教程：https://www.youtube.com/watch?v=DQYZU1VsqXc&feature=youtu.be
- 由于Ceph的配置文件必须指定IP地址，因此使用Ceph容器前我们必须获得本机IP，如果是boot2docker用户需要获得其虚拟机IP。使用指令为`ifconfig`或者`ip addr`，注意IP与使用网卡的对应关系。

---
__启动Ceph__
- 启动单机版ceph非常简单，使用下述命令。

```
docker@dev:~$ docker run -d --net=host -e MON_IP=10.0.2.15 -e CEPH_NETWORK=10.0.2.0/24 ceph/demo
badaf5c8fed1e0edf6f2281539669d8f6522ba54b625076190fe4d6de79745ff
```
- 然后可以通过docker ps来检查容器状态。

```
docker@dev:~$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
badaf5c8fed1        ceph/demo           "/entrypoint.sh"    9 seconds ago       Up 9 seconds                            loving_pasteur
```
- 这里ceph容器的ID为“badaf5c8fed1”，可以快速进入容器。

```
docker@dev:~$ docker exec -i -t badaf5c8fed1 /bin/bash
root@dev:/#
```

---
### 基本命令
__检查状态__
- 最简单的ceph命令是，`ceph -w`，也就是watch整个ceph集群的状态。

```
root@dev:/# ceph -w
    cluster fee30c76-aec4-44d4-8138-763969aaa562
     health HEALTH_OK
     monmap e1: 1 mons at {dev=10.0.2.15:6789/0}
            election epoch 2, quorum 0 dev
     mdsmap e5: 1/1/1 up {0=0=up:active}
     osdmap e18: 1 osds: 1 up, 1 in
      pgmap v22: 120 pgs, 8 pools, 2810 bytes data, 63 objects
            4519 MB used, 13115 MB / 18603 MB avail
                 120 active+clean

2015-07-12 06:53:58.454077 mon.0 [INF] pgmap v22: 120 pgs: 120 active+clean; 2810 bytes data, 4519 MB used, 13115 MB / 18603 MB avail
```
- 或者通过ceph status命令。

```
root@dev:/# ceph status
    cluster fee30c76-aec4-44d4-8138-763969aaa562
     health HEALTH_OK
     monmap e1: 1 mons at {dev=10.0.2.15:6789/0}
            election epoch 2, quorum 0 dev
     mdsmap e5: 1/1/1 up {0=0=up:active}
     osdmap e21: 1 osds: 1 up, 1 in
      pgmap v30: 120 pgs, 8 pools, 2810 bytes data, 63 objects
            4521 MB used, 13114 MB / 18603 MB avail
                 120 active+clean
```

---
### RADOS命令
__Pool简介__
- Pool是Ceph中的逻辑概念，不同的应用可以使用不同的Pool。

---
__Pool相关命令__
```
root@dev:/# rados lspools
rbd
cephfs_data
cephfs_metadata
.rgw.root
.rgw.control
.rgw
.rgw.gc
.users.uid
```
- 如果想获得特定Pool的数据。

```
root@dev:/# rados -p .rgw ls
root@dev:/# rados -p .rgw.root ls
default.region
region_info.default
zone_info.default
```

---
__容量相关__
- 获得当前OSD所用容量。

```
root@dev:/# rados df
pool name                 KB      objects       clones     degraded      unfound           rd        rd KB           wr        wr KB
.rgw                       0            0            0            0           0            0            0            0            0
.rgw.control               0            8            0            0           0            0            0            0            0
.rgw.gc                    0           32            0            0           0          288          256          192            0
.rgw.root                  1            3            0            0           0            0            0            3            3
.users.uid                 0            0            0            0           0            0            0            0            0
cephfs_data                0            0            0            0           0            0            0            0            0
cephfs_metadata            2           20            0            0           0            0            0           31            8
rbd                        0            0            0            0           0            0            0            0            0
  total used         4630192           63
  total avail       13428976
  total space       19049892
```

---
### Bucket命令
__创建Bucket__
```
root@dev:/# ceph osd tree
ID WEIGHT  TYPE NAME     UP/DOWN REWEIGHT PRIMARY-AFFINITY
-1 1.00000 root default
-2 1.00000     host dev
 0 1.00000         osd.0      up  1.00000          1.00000
root@dev:/# ceph osd crush add-bucket rack01 rack
added bucket rack01 type rack to crush map
root@dev:/# ceph osd crush add-bucket rack02 rack
added bucket rack02 type rack to crush map
root@dev:/# ceph osd crush add-bucket rack03 rack
added bucket rack03 type rack to crush map
root@dev:/# ceph osd tree
ID WEIGHT  TYPE NAME     UP/DOWN REWEIGHT PRIMARY-AFFINITY
-5       0 rack rack03
-4       0 rack rack02
-3       0 rack rack01
-1 1.00000 root default
-2 1.00000     host dev
 0 1.00000         osd.0      up  1.00000          1.00000
```
__移动Rack__
```
root@dev:/# ceph osd crush move rack01 root=default
moved item id -3 name 'rack01' to location {root=default} in crush map
root@dev:/# ceph osd crush move rack02 root=default
moved item id -4 name 'rack02' to location {root=default} in crush map
root@dev:/# ceph osd crush move rack03 root=default
moved item id -5 name 'rack03' to location {root=default} in crush map
root@dev:/# ceph osd tree
ID WEIGHT  TYPE NAME       UP/DOWN REWEIGHT PRIMARY-AFFINITY
-1 1.00000 root default
-2 1.00000     host dev
 0 1.00000         osd.0        up  1.00000          1.00000
-3       0     rack rack01
-4       0     rack rack02
-5       0     rack rack03
```

---
### Object操作
__创建Pool__
```
root@dev:/# ceph osd pool create web-services 128 128
pool 'web-services' created
root@dev:/# rados lspools
rbd
cephfs_data
cephfs_metadata
.rgw.root
.rgw.control
.rgw
.rgw.gc
.users.uid
web-services
```
__添加Object__
```
root@dev:/# echo "Hello Ceph, You are Awesome like MJ" > /tmp/helloceph
root@dev:/# rados -p web-services put object1 /tmp/helloceph
root@dev:/# rados -p web-services ls
object1
root@dev:/# ceph osd map web-services object1
osdmap e29 pool 'web-services' (8) object 'object1' -> pg 8.bac5debc (8.3c) -> up ([0], p0) acting ([0], p0)
```
__查看Object__
```
root@dev:/# cd /var/lib/ceph/osd/
root@dev:/var/lib/ceph/osd# ls ceph-0/current/8.3c_head/
__head_0000003C__8  object1__head_BAC5DEBC__8
root@dev:/var/lib/ceph/osd# cat ceph-0/current/8.3c_head/object1__head_BAC5DEBC__8
Hello Ceph, You are Awesome like MJ
```

---
## Ceph架构
- 前面粗略地介绍了Ceph、RADOS、CRUSH等概念和用法，本章将重点剖析具体的架构与算法，详细介绍其设计和实现细节。

<div align="center">
![](http://okj8snz5g.bkt.clouddn.com/blog/ceph_architecture.png)
</div>

---

### 论文介绍
__简介__
- Ceph是Sega本人的博士论文作品，想了解Ceph的架构设计最好的方式是阅读Sega的论文，其博士论文我们称之为长论文，后来整理成三篇较短的论文。

__长论文__
- 长论文包含了RADOS、CRUSH等所有内容的介绍，但篇幅相当长，如果感兴趣可以阅读，标题为《CEPH: RELIABLE, SCALABLE, AND HIGH-PERFORMANCE DISTRIBUTED STORAGE》，地址 http://ceph.com/papers/weil-thesis.pdf 。

__CRUSH论文__
- CRUSH论文论文标题为《CRUSH: Controlled, Scalable, Decentralized Placement of Replicated Data》，地址 http://ceph.com/papers/weil-crush-sc06.pdf ，介绍了CRUSH的设计与实现细节。

__RADOS__
- RADOS论文论文标题为《RADOS: A Scalable, Reliable Storage Service for Petabyte-scale Storage Clusters》，地址为 http://ceph.com/papers/weil-rados-pdsw07.pdf ，介绍了RADOS的设计与实现细节。

__CephFS论文__
- CephFS论文标题为《Ceph: A Scalable, High-Performance Distributed File System》，地址为 http://ceph.com/papers/weil-ceph-osdi06.pdf ，介绍了Ceph的基本架构和Ceph的设计与实现细节。

---
### CRUSH详解
__CRUSH简介__
- CRUSH全称`Controlled Replication Under Scalable Hashing`，是一种数据分发算法，类似于哈希和一致性哈希。哈希的问题在于数据增长时不能动态加Bucket，一致性哈希的问题在于增加Bucket时数据迁移量比较大，其他数据分发算法依赖中心的Metadata服务器来存储元数据效率较低，CRUSH则是通过计算、接受多维参数的来解决动态数据分发的场景。

__算法基础__
- 在学习CRUSH之前，需要了解以下的内容。
- CRUSH算法接受的参数包括cluster map，也就是硬盘分布的逻辑位置，例如这有多少个机房、多少个机柜、硬盘是如何分布的等等。cluster map是类似树的多层结果，子节点是真正存储数据的device，每个device都有id和权重，中间节点是bucket，bucket有多种类型用于不同的查询算法，例如一个机柜一个机架一个机房就是bucket。
- 另一个参数是placement rules，它指定了一份数据有多少备份，数据的分布有什么限制条件，例如同一份数据不能放在同一个机柜里等的功能。每个rule就是一系列操作，take操作就是就是选一个bucket，select操作就是选择n个类型是t的项，emit操作就是提交最后的返回结果。select要考虑的东西主要包括是否冲突、是否有失败和负载问题。
- 算法的还有一个输入是整数x，输出则是一个包含n个目标的列表R，例如三备份的话输出可能是[1, 3, 5]。

__算法解读__
<div align="center">
  ![](http://okj8snz5g.bkt.clouddn.com/blog/crush_algorithm.png)
</div>
- 图虽然很复杂，但如果理解了几个基本操作的含义就很好读下来了，这里是三个操作的伪代码，take和emit很好理解，select主要是遍历当前bucket，如果出现重复、失败或者超载就跳过，其中稍微复杂的“first n”部分是一旦遇到失败，第一种情况是直接使用多备份，第二种情况是使用erasing code基本可以忽略。看着下面的图就更好理解具体的算法了

<div align="center">
  ![](http://okj8snz5g.bkt.clouddn.com/blog/crush_algorithm_easy.png)
</div>

---
### CRUSH总结
__算法总结__
- CRUSH与一致性哈希最大的区别在于接受的参数多了cluster map和placement rules，这样就可以根据目前cluster的状态动态调整数据位置，同时通过算法得到一致的结果。

__算法补充__
- 前面介绍了bucket根据不同场景有四种类型，分别是Uniform、List、Tree和Straw，他们对应运行数据和数据迁移量有不同的tradeoff，目前大家都在用Straw因此不太需要关系其他。
- 目前erasing code可以大大减小三备份的数据量，但除了会导致数据恢复慢，部分ceph支持的功能也是不能直接用的，而且功能仍在开发中不建议使用。

---
### RADOS详解
- RADOS是ceph实现高可用、数据自动恢复的框架，设计的点比较多后面在详细介绍。

<div align="center">
  ![](http://okj8snz5g.bkt.clouddn.com/blog/rados_erasure_coding.png)
</div>

---
## RBD
- 本章将介绍使用ceph搭建块设备服务。

<div align="center">
  ![](http://okj8snz5g.bkt.clouddn.com/blog/rados_rbd.jpg)
</div>

---
### RBD命令
__检查Pool__

- Ceph启动后默认创建rbd这个pool，使用rbd命令默认使用它，我们也可以创建新的pool。

```
rados lspools
ceph osd pool create rbd_pool 1024
```
__创建image__

- 使用rbd命令创建image，创建后发现rbd这个pool会多一个`rbd_directory`的object。

```
rbd create test_image --size 1024
rbd ls
rbd --image test_image info
rados -p rbd ls
```
__修改image大小__

- 增加Image大小可以直接使用resize子命令，如果缩小就需要添加--allow-shrink参数保证安全。

```
rbd --image test_image resize --size 2000
rbd --image test_image resize --size 1000 --allow-shrink
```
__使用Image__

- 通过map子命令可以把镜像映射成本地块设备，然后就可以格式化和mount了。

```
rbd map test_image
rbd showmapped
mkfs.ext4 /dev/rbd0
mount /dev/rbd0 /mnt/
```
__移除Image__

```
umount /dev/rbd0
rbd unmap /dev/rbd0
rbd showmapped
```
__删除Image__

- 删除和Linux类似使用rm命令即可。

```
rbd --image test_image rm
```
---
### RBD快照
__创建快照__

- 通过snap子命令可以创建和查看快照。

```
rbd snap create --image test_image --snap test_snap
rbd snap ls --image test_image
```
__快照回滚__

- 使用snap rollback就可以回滚快照，由于快照命名是镜像名后面加@，我们还可以下面的简便写法。

```
rbd snap rollback --image test_image --snap test_snap
rbd snap rollback rbd/test_image@test_snap
```
__删除快照__

- 删除快照也很简单，使用rm子命令，如果想清理所有快照可以使用purge子命令，注意Ceph删除是异步的不会立即释放空间。

```
rbd snap rm --image test_image --snap test_snap
rbd snap purge --image test_image
```
__保护快照__

- 保护快照可以防止用户误删数据，这是clone前必须做的。

```
rbd snap protect --image test_image --snap test_snap
```
- 要想不保护快照也很容易，使用unprotect子命令即可。

```
rbd snap unprotect --image test_image --snap test_snap
```
---
### RBD克隆
__创建clone__

- RBD克隆就是通过快照克隆出新的可读可写的Image，创建前需要创建format为2的镜像快照。

```
rbd create test_image2 --size 1024 --image-format 2
rbd snap create --image test_image2 --snap test_snap2
rbd snap protect --image test_image2 --snap test_snap2
```
- 通过clone子命令就可以创建clone了。

```
rbd clone --image test_image2 --snap test_snap2 test_clone
```
__列举clone__

- 通过children子命令可以列举这个快照的所有克隆。

```
rbd children --image test_image2 --snap test_snap2
```
__填充克隆__

- 填充克隆也就是把快照数据flatten到clone中，如果你想删除快照你需要flatten所有的子Image。

```
rbd flatten --image test_clone
```
---
### RBD和Qemu
__使用Qemu__

- 官方Qemu已经支持librbd，使用Qemu创建镜像前需要安装工具。

```
apt-get install -y qemu-utils
```
__创建镜像__

- 创建镜像非常简单，使用qemu-img命令，注意目前RBD只支持raw格式镜像。

```
qemu-img create -f raw rbd:rbd/test_image3 1G
```
__修改镜像大小__

- 修改镜像大小可以使用resize子命令。

```
qemu-img resize rbd:rbd/test_image3 2G
```
__查看镜像信息__

- 通过info可以获取Qemu镜像信息。

```
qemu-img info rbd:rbd/test_image3
```
---
### RBD和Virsh
__安装Virsh__

- Virsh是通用的虚拟化技术抽象层，可以统一管理Qemu/
- KVM、Xen和LXC等，要结合Virsh和RBD使用，我们需要安装对应工具。

```
apt-get install -y virt-manager
```
---
### RBD和Openstack

__OpenStack介绍__

- OpenStack开源的云平台，其中Nova提供虚拟机服务，Glance提供镜像服务，Cinder提供块设备服务。因为OpenStack是Python实现的，因此RBD与OpenStack集成需要安装下面的软件。

```
apt-get install -y python-ceph
```
__Nova与RBD__

- 修改nova.conf配置文件。

```
libvirt_images_type=rbd
libvirt_images_rbd_pool=volumes
libvirt_images_rbd_ceph_conf=/etc/ceph/ceph.conf
rbd_user=cinder
rbd_secret_uuid=457eb676-33da-42ec-9a8c-9293d545c337
```

```
libvirt_inject_password=false
libvirt_inject_key=false
libvirt_inject_partition=-2
```
__Glance与RBD__

- 修改glance-api.conf配置文件。

```
default_store=rbd
rbd_store_user=glance
rbd_store_pool=images
show_image_direct_url=True
```
__Cinder与RBD__

- 修改cinder.conf配置文件。

```
volume_driver=cinder.volume.drivers.rbd.RBDDriver
rbd_pool=volumes
rbd_ceph_conf=/etc/ceph/ceph.conf
rbd_flatten_volume_from_snapshot=false
rbd_max_clone_depth=5
glance_api_version=2
```

```
backup_driver=cinder.backup.drivers.ceph
backup_ceph_conf=/etc/ceph/ceph.conf
backup_ceph_user=cinder-backup
backup_ceph_chunk_size=134217728
backup_ceph_pool=backups
backup_ceph_stripe_unit=0
backup_ceph_stripe_count=0
restore_discard_excess_bytes=true
```
---
### Python librbd
__安装librbd__

- Ceph官方提供Python库来访问RBD，通过以下命令可以安装。

```
apt-get install -y python-ceph
```
__创建Image__

- 使用librbd创建Image也很简单，下面是示例代码。

```
import rados
import rbd

cluster = rados.Rados(conffile='/etc/ceph/ceph.conf')
cluster.connect()
ioctx = cluster.open_ioctx('rbd')

rbd_inst = rbd.RBD()
size = 1024**3
image_name = "test_image"
rbd_inst.create(ioctx, image_name, size)

image = rbd.Image(ioctx, image_name)
data = 'foo' * 200
image.write(data, 0)

image.close()
ioctx.close()
cluster.shutdown()
```

- 也可以把下面代码保存成文件直接执行。

```
cluster = rados.Rados(conffile='/etc/ceph/ceph.conf')
try:
    ioctx = cluster.open_ioctx('rbd')
    try:
        rbd_inst = rbd.RBD()
        size = 1024**3
    image_name = "test_image"
        rbd_inst.create(ioctx, image_name, size)
        image = rbd.Image(ioctx, image_name)
        try:
            data = 'foo' * 200
            image.write(data, 0)
        finally:
            image.close()
    finally:
        ioctx.close()
finally:
    cluster.shutdown()
```

- 或者这样。

```
with rados.Rados(conffile='/etc/ceph/ceph.conf') as cluster:
    with cluster.open_ioctx('rbd') as ioctx:
        rbd_inst = rbd.RBD()
        size = 1024**3
    image_name = "test_image"
        rbd_inst.create(ioctx, image_name, size)
        with rbd.Image(ioctx, image_name) as image:
            data = 'foo' * 200
            image.write(data, 0)
```
---
## RGW
- RGW是ceph提供对象存储服务，本章将介绍RGW的搭建和使用，从而提供类似S3和Swift服务。
通过本章你可以在本地起ceph的S3服务，然后使用命令行或者SDK工具来访问对象存储服务，并且使用ceph管理用户和quota。

<div align="center">
  ![](http://okj8snz5g.bkt.clouddn.com/blog/object_storage.png)
</div>

---
### RGW介绍
- RGW全称Rados Gateway，是ceph封装RADOS接口而提供的gateway服务，并且实现S3和Swift兼容的接口，也就是说用户可以使用S3或Swift的命令行工具或SDK来使用RGW。
- RGW对象存储也可以作为docker registry的后端，相对与本地存储，将docker镜像存储到RGW后端可以保证即使机器宕机或者操作系统crush也不会丢失数据。

<div align="center">
  ![](http://okj8snz5g.bkt.clouddn.com/blog/rgw_architecture.jpg)
</div>


---
### RGW用法
__使用RGW__

- RGW同时提供了S3和Swift兼容的接口，因此只要启动了RGW服务，就可以像使用S3或Swift那样访问RGW的object和bucket了。
- 本地启动RGW的命令也很简单，启动ceph/demo镜像即可，命令如下:

```
docker run -d --net=host -e MON_IP=10.251.0.105 -e CEPH_NETWORK=10.251.0.0/24 ceph/demo
```

__用户操作__

- 查看用户信息:

```
radosgw-admin user info --uid=mona
```

__Bucket操作__

- 查看bucket信息。

```
root@dev:~# radosgw-admin bucket stats
[]
```

---
### S3用法
__创建用户__

```
root@dev:/# radosgw-admin user create --uid=mona --display-name="Monika Singh" --email=mona@example.com
{
    "user_id": "mona",
    "display_name": "Monika Singh",
    "email": "mona@example.com",
    "suspended": 0,
    "max_buckets": 1000,
    "auid": 0,
    "subusers": [],
    "keys": [
        {
            "user": "mona",
            "access_key": "2196PJ0MA6FLHCVKVFDW",
            "secret_key": "eO1\/dmEOEU5LlooexlWwcqJYZrt3Gzp\/nBXsQCwz"
        }
    ],
    "swift_keys": [],
    "caps": [],
    "op_mask": "read, write, delete",
    "default_placement": "",
    "placement_tags": [],
    "bucket_quota": {
        "enabled": false,
        "max_size_kb": -1,
        "max_objects": -1
    },
    "user_quota": {
        "enabled": false,
        "max_size_kb": -1,
        "max_objects": -1
    },
    "temp_url_keys": []
}
```

__添加Capabilities__

```
radosgw-admin caps add --uid=mona  --caps="users=*"
radosgw-admin caps add --uid=mona  --caps="buckets=*"
radosgw-admin caps add --uid=mona  --caps="metadata=*"
radosgw-admin caps add --uid=mona --caps="zone=*"
```

__安装s3cmd__

```
apt-get install python-setuptools
git clone https://github.com/s3tools/s3cmd.git
cd s3cmd/
python setup.py install
```

__使用s3cmd__

- 必须提前设置.s3cfg文件。

```
s3cmd ls
```

---
### Swift用法
__创建用户__

```
root@dev:~# radosgw-admin subuser create --uid=mona --subuser=mona:swift --access=full --secret=secretkey --key-type=swift
{
    "user_id": "mona",
    "display_name": "Monika Singh",
    "email": "mona@example.com",
    "suspended": 0,
    "max_buckets": 1000,
    "auid": 0,
    "subusers": [
        {
            "id": "mona:swift",
            "permissions": "<none>"
        }
    ],
    "keys": [
        {
            "user": "mona",
            "access_key": "2196PJ0MA6FLHCVKVFDW",
            "secret_key": "eO1\/dmEOEU5LlooexlWwcqJYZrt3Gzp\/nBXsQCwz"
        },
        {
            "user": "mona:swift",
            "access_key": "2FTDLNGGOWALF1ZS5XHY",
            "secret_key": ""
        }
    ],
    "swift_keys": [
        {
            "user": "mona:swift",
            "secret_key": "secretkey"
        }
    ],
    "caps": [
        {
            "type": "buckets",
            "perm": "*"
        },
        {
            "type": "metadata",
            "perm": "*"
        },
        {
            "type": "users",
            "perm": "*"
        },
        {
            "type": "zone",
            "perm": "*"
        }
    ],
    "op_mask": "read, write, delete",
    "default_placement": "",
    "placement_tags": [],
    "bucket_quota": {
        "enabled": false,
        "max_size_kb": -1,
        "max_objects": -1
    },
    "user_quota": {
        "enabled": false,
        "max_size_kb": -1,
        "max_objects": -1
    },
    "temp_url_keys": []
}
```

__安装Swift客户端__

```
apt-get install python-pip
pip install python-swiftclient
```

__Swift命令__

```
swift -V 1.0 -A http://localhost/auth -U mona:swift -K secretkey post example-bucket
swift -V 1.0 -A http://localhost/auth -U mona:swift -K secretkey list
```
---
## CephFS
- 这一章计划介绍CephFS的搭建和使用。
由于CephFS仍未能上Production环境，本章内容将在CephFS稳定后继续完善。

---
## Ceph监控
- 这一章将介绍Ceph的监控与运维，搭建Ceph是一次性的工作，但运维Ceph却是长久的任务，幸运的是Ceph本身提供了很好的监控管理工具，方便我们管理Ceph集群。
- 通过本章我们可以学到Ceph官方提供的ceph-rest-api，并带领大家一步一步实现基于ceph-rest-api的Web监控管理工具。

![](http://okj8snz5g.bkt.clouddn.com/blog/ceph_monitor.jpg.png)

---
### Ceph-rest-api
__简介__

- Ceph-rest-api是Ceph官方提供的RESTful API接口，启动其进程后我们可以通过HTTP接口来收集Ceph集群状态与数据，并且进行起停OSD等管理操作。
- 详细的API文档可参考 https://dmsimard.com/2014/01/01/documentation-for-ceph-rest-api/ 。

__启动API__

- 因为ceph-rest-api需要管理一个ceph集群，我们建议通过ceph/demo来启动。

```
docker run -d --net=host -e MON_IP=10.0.2.15 -e CEPH_NETWORK=10.0.2.0/24 ceph/demo
ceph-rest-api -n client.admin
```

- 这样在启动单机版ceph的同时，也启动了ceph-rest-api。

__测试API__

- 通过简单的curl命令即可获得集群的状态信息。

```
root@dev:/# curl 127.0.0.1:5000/api/v0.1/health
HEALTH_OK
```

- 或者查询更复杂的数据。

```
root@dev:/# curl 127.0.0.1:5000/api/v0.1/osd/tree
ID WEIGHT  TYPE NAME       UP/DOWN REWEIGHT PRIMARY-AFFINITY
-1 1.00000 root default
-2 1.00000     host dev
 0 1.00000         osd.0        up  1.00000          1.00000
-3       0     rack rack01
-4       0     rack rack02
-5       0     rack rack03
```
---
### Ceph-web
__监控工具__

- 前面提到过的ceph-rest-api，为我们提供了HTTP接口来访问Ceph集群的状态信息，但是只有ceph-rest-api远远不够，我们需要更友好的Web管理工具。这里我们将介绍开源的ceph-web项目，是非常简单的Web前端，通过ceph-rest-api获得数据并展示。

__Ceph-web__

- 为了不增加API的复杂性，ceph-web遵循官方ceph-rest-api的接口，只是提供HTTP服务器并展示Ceph的数据，开源地址 https://github.com/tobegit3hub/ceph-web 。
- 目前ceph-web已经支持通过容器运行，执行下述命令即可一键启动Ceph监控工具。

```
docker run -d --net=host tobegit3hub/ceph-web
```
- 这样通过浏览器打开 http://127.0.0.1:8080 就可以看到以下管理界面。

![](http://okj8snz5g.bkt.clouddn.com/blog/ceph_web.png)

---
