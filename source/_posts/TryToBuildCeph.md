---
title: 尝试部署Ceph
toc: 1
date: 2017-04-17 15:38:01
tags:
- Ceph
categories:
- Practical
- 工作记录
permalink:
---
**原因**：2017年4月14日 星期五 尝试搭建Ceph环境
**说明**：尝试Vagrant、Ansible、SaltStack自动部署Ceph或DockerCeph

<!-- more -->

## 简介
- 测试环境为macOS Sierra 10.12.4
- 在对Ceph了解程度极低的情况喜爱，完成部署Ceph环境，进行API、命令等的调研，难度在于Ceph是一个很复杂的开源项目，安装方式多种多样，安装的形式也很多，选择的路很多但是没有非常简单的办法，经过思考大致有如下几种方式以及优缺点：
- Docker部署Ceph：适用于小规模部署以及测试，开箱即用，损坏益于恢复，但是距离真实开发环境仍有距离。
- Ansible、Vagrant部署Ceph，部署较为复杂，部署到虚拟机中，接近真实环境，部署难度较为复杂。
- 虚拟机直接部署Ceph：部署很复杂，维护困难，但是极接近生产环境。

---

## 部署记录
### Ansible部署记录
#### Virtualenv
- `virtualenv`可以用来建立一个专属于项目的`python`环境，保持一个干净的环境。只需要通过命令创建一个虚拟环境，不用的时候通过命令退出，删除。
- 在了解到`Ansible`是python项目后，第一时间使用`virtualenv`+`virtualenvwrapper`进行开发，这样不会影响到机器中的其他环境。
- 使用pip安装`virtualenv`以及其扩展工具`virtualenvwrapper`，并展示如何使用。
```
sudo easy_install pip
sudo pip install virtualenv
sudo easy_install virtualenvwrapper
```

- 在`.zshrc` 或者`.bashrc`中加入如下代码，从而使用`virtualenvwrapper`

```
WORKON_HOME=$HOME/.virtualenvs
export PIP_REQUIRE_VIRTUALENV=true
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
source /usr/local/bin/virtualenvwrapper.sh
```

- 使用`mkvirtualenv ansible`新建一个名为`ansible`的虚拟环境，如下图，到虚拟环境中发现新建后多出了一个ansible文件夹。可以使用`workon`命令列出所有的虚拟环境，使用`workon + 环境名`的方式进入虚拟环境，使用`deactivate`命令退出当前虚拟环境。

![](http://image.yaopig.com/blog/Screen%20Shot%202017-04-17%20at%2015.54.05.png)
![](http://image.yaopig.com/blog/Screen%20Shot%202017-04-17%20at%2015.54.37.png)

#### Ansible的部署安装
- Ansible的github中演示视频过于老旧，已经不适用现存github开源项目，多次尝试后无法安装，更换方法。

---

## 参考
- [Ansible官网](https://www.ansible.com)
- [Ansible中文权威指南](http://www.ansible.com.cn/index.html)

---

### SaltStack自动安装
- [Ceph-Salt](https://github.com/komljen/ceph-salt)，从github的ceph-salt项目后：

```
cd ceph-salt/vagrant
vagrant up
```
- vagrant会bootstrap自动安装3个节点，master、node01、node02，安装如下：

![](http://image.yaopig.com/blog/Jietu20170418-102922.jpg)

- this may take a long long while.
- 

