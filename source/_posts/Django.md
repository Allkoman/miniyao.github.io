---
title: Django
toc: 1
date: 2017-02-17 13:23:33
tags:
- Python
- Django
categories:
- 自主学习
permalink:
---
**原因**：2017年2月17日 星期六 学习Django加深python理解
**说明**：自主学习，兴趣爱好，操作系统为mac
**状态**：updating 2.17
<!-- more -->

## 简介
- 本博客为记录开发流程
- 项目为python django框架开发的流程及环境的配置
- 为避免python包及语言版本问题造成混乱采用virtualenv
- 数据库采用mysql及navicat for mysql
- 未完待续

---

## virtualenv搭建
### 背景
- mac自带python为2.7.10，而有时需要2.7.5或者3.x版本，而pip也是版本混杂，包管理混乱，故而采用`virtualenv`及`virtualenvwrapper`搭建独立的开发环境。

---

### 环境
- MacOs Sierra 10.12.3 
- python2.7.10

---

### 环境搭建
- Mac自带python2.7.10，其余unix操作系统可直接官网下载安装or包管理器安装

```shell
sudo easy_isntall pip   #安装python包管理工具pip
pip install pip -U  #升级pip，目前最新为9.0.1
```

- 使用virtualenv的原因如下：
- 使不同应用开发环境独立
- 环境升级不影响其他应用，也不影响全局的python环境
- 可以防止系统中出现包管理混乱和版本冲突

---
#### 安装virtualenv：

```shell
pip install virtualenv  #安装virtualenv
virtualenv django #当前目录下新建名为django的python环境
source  django/bin/activate #开启环境
deactivate  #关闭环境
```

- 安装完VirtualEnv后，便可以直接使用pip来安装依赖包了，但要注意的是，如果未启动虚拟环境，而且系统也安装了pip，此时会安装到系统环境中，为了避免类似的情况发生，可以在~/.bashrc(我的是zsh)中添加行:

```shell 
export PIP_REQUIRE_VIRTUALENV=true
```

- 来强制pip使用虚拟环境，另外在~/.bashrc中添加行来设置pip的缓存：

```shell 
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
```

---

#### 安装virtualenvwrappre:

```shel
sudo pip install virtualenvwrapper  #直接安装，如果是win系统，在wrapper后加-win即可
sudo -H pip install virtualenvwrapper --upgrade --ignore-installded six #安装时组件six报错
```
- 安装完之后先进行设置后再使用：
- 创建目录来存放虚拟环境:

```shell
mkdir $HOME/.virtualenvs
```
- 在~/.bashrc中添加行：

```shell
export WORKON_HOME=$HOME/.virtualenvs   #以后所有的虚拟环境都在$HOME/.virtualenvs目录下了
```
- 在.bashrc中添加行：

```shell
source /usr/local/bin/virtualenvwrapper.sh
```
- 运行

```shell
source ~/.bashrc  #如果是zsh，替换为source ~/.zshrc即可
```
- 之后便可以使用Virtualenvwrapper了。

---

#### 使用:
- 列出虚拟环境列表

```shell
workon
```
- 也可以使用

```shell
lsvirtualenv
```
- 新建虚拟环境

```shell
mkvirtualenv [虚拟环境名称]
```
- 启动/切换虚拟环境

```shell
workon [虚拟环境名称]
```
- 关闭虚拟环境

```shell
deactivate
```
- 删除虚拟环境

```shell
rmvirtualenv [虚拟环境名称]
```

---

### 测试使用virtualenv
- 新建环境django并进入环境

```shell
mkvirtualenv django
workon django
pip list    #列出pip安装的软件
```
- 发现9.0.1的warning如下
![bug](http://image.yaopig.com/blog/virtualpipbug.png)
- 解决办法为在当前virtualenv的目录，即我的是~/.virtualenv/django下新建文件pip.conf，写入:

```shell
[list]
format=columns
```
- 解决后如下图：
![solution](http://image.yaopig.com/blog/virtualenvbugsolution.png)

---

## Pycharm Navicat
### Pycharm简介
- 废话不多说上图：
![pycharm](http://image.yaopig.com/blog/pycharm.png)
- pycharm是[jetbrains](https://www.jetbrains.com)旗下的一款python IDE，我也是刚入坑，据说口碑很不错。

### 新建Django项目
- 注意`Interpreter`选择环境为我们自己的虚拟环境。下图提示没有django，可以直接下一步自动安装或手动pip安装。
![django_create](http://image.yaopig.com/blog/pythondjangocreate.png)
- 新建成功后，进入项目点击run，可以在`127.0.0.1:8000`看到默认的"it worded!"

---
### Navicat使用

