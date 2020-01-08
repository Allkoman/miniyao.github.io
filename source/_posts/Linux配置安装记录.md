---
title: Linux配置安装记录
date: 2016-07-29 23:55:13
categories:
- 工作日常
- 优化美化
tags:
- Linux
permalink: Cwork
toc: 1
---

**原因**：2016年7月29日 星期五 由于机器声卡出现问题，耳机无法使用， 始终是外放，无法观看视频，听音乐，决定修改驱动参数，于是：系统无限重启决定重新配置环境并记录
**说明**：由于工作需要，接触需要使用Linux开发环境，与之前个人常用的Mac与Windows还是有较大区别，进行详细记录（其实是各种错误BUG重装了好几次后的笔记...）
**环境**：Ubuntu 16.04 on Alienware 17R3 Samsung 950 Pro 256g SSD

<!-- more -->
## 前期准备
- 我用的是Alienware 17R3，硬盘为自带固态外加Samsung 950 Pro 256g SSD，安装Ubuntu双系统时会有各种各样的问题，譬如BIOS设置不当双固态引导双系统，谁做主引导，谁负责启动，等一系列问题。同时N卡驱动不适用，会发生连接HDMI外接显示器无法分屏等问题，在多次摸索尝试后，找到了适用于自己环境的安装方式并记录下来（安这么多次记下来复制粘贴省时间。。。），主要准备2发U盘，一个Win一个Ubuntu。本文主要讲一些比较浅显的`入门设置`。


## 基础安装
---
### 安装
- 首先使用的是U盘刻录后在Win10基础上的双系统，Win引导Linux，可以用 [Ultraiso](http://www.ezbsystems.com/ultraiso/)进行刻录安装U盘，开机选择启动项为U盘后安装，我为Ubuntu预留了100G空间。主逻辑分区/ 22000mb，swap交换空间2048mb，/boot 200mb，/home分配剩余的空间，启动器挂在于/boot所在的盘符，由win引导ubuntu用easybcd更改即可。

---
### Passwd 
```bash
sudo passwd
```
- 进入Ubuntu第一件事情，重置sudo密码，由于使用频繁，推荐简易的密码

---
### Ubuntu Nvidia
```
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get install nvidia-364.
```
- nvidia系列笔记本必装驱动。（否则系统自带的带不动多显示器）

---
### JDK
- 在官网下载JDK文件，安装并配置
- 首先cd到下载好的压缩包的文件夹，创建一个jvm文件夹，并将其解压进去

```bash
sudo mkdir /usr/lib/jvm
sudo tar zxvf jdk-8u101-linux-x64.tar.gz -C /usr/lib/jvm
```
- 打开bashrc文件，在底下加上四条参数

```bash
gedit ~/.bashrc
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_101  
export JRE_HOME=/usr/lib/jvm/jdk1.8.0_101/jre   
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH  
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$JAVA_HOME:$PATH
```
- 最后测试一下是否安装成功

```bash
java -version
```

---
### Node&Npm&Bower
```bash
sudo apt install nodejs-legacy
sudo apt install npm
sudo npm install -g bower
```

### Mysql
- ubuntu上安装mysql非常简单只需要几条命令就可以完成。

```bash
sudo apt-get install mysql-server
sudo apt-get install mysql-client
sudo apt-get install libmysqlclient-dev
```
- 安装过程中会提示设置密码什么的，注意设置了不要忘了，安装完成之后可以使用如下命令来检查是否安装成功：

```bash
 sudo netstat -tap | grep mysql
```
- 通过上述命令检查之后，如果看到有mysql 的socket处于 listen 状态则表示安装成功。
- 登陆mysql数据库可以通过如下命令：

```bash
 mysql -u root -p 
```
- 介于现阶段使用的数据库都是Mysql，一般来讲开发过程中，常用到的:

```bash
create database srametadb;
use srametadb;
show tables;
source /XX/XX/study.sql;
```
- 可以写好，或拷贝来库文件直接source导入到库文件中

-------------------

## 优化美化


---
### Git&Solrized
```bash
sudo apt install git
git clone --recursive https://github.com/reversiblean/solarized-light-ubuntu.git
Run ./install.sh
```
![Solrized](http://image.yaopig.com/blog/solrized.png)
- 有效保护眼睛的主题,个人喜好～

---
### Unity Tweak Tool
```bash
sudo add-apt-repository ppa:freyja-dev/unity-tweak-tool-daily
sudo apt-get update
sudo apt-get install unity-tweak-tool
```
- 可用于强迫症将左侧的边栏移动到下方并隐藏，便于增大屏幕利用率，使用锁定在边栏的软件可以通过WIN+1,2,3等数字的方式唤醒。
![Unity](http://image.yaopig.com/blog/unitytweaktools.png)
- 如下图，工作时完全可以从下方呼出菜单栏，Tweak还有分屏，workspace等很强大的功能
![Unity2](http://image.yaopig.com/blog/unitytweaktools2.png)

---
### Unity Numix
```bash
sudo apt-add-repository ppa:numix/ppa
sudo apt-get update
sudo apt-get install numix-icon-theme-circle
```
- 比较炫酷的icons主题

---
### Shutter 
```bash
sudo add-apt-repository ppa:shutter/ppa
sudo apt-get update
sudo apt-get install shutter
```
- 截图工具，可自定义快捷键，方便好用

---
### Unity Arc
```bash
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' >> /etc/apt/sources.list.d/arc-theme.list"
sudo apt-get update
sudo apt-get install arc-theme
```
- 比较炫酷的theme
