---
title: LAMP_Xdebug
toc: 1
date: 2017-03-24 15:06:32
tags:
- 工作日常
categories:
- lamp
- xdebug
permalink:
---
**原因**：2017年3月24日 星期五 随笔记录。
**说明**：记录为mediawiki搭建LAMP_Xdebug的过程。

<!-- more -->

### Xdebug
- 点击[xdebug](https://xdebug.org/wizard.php)，进入后使用命令行命令`curl locahost/info.php`将info.php文件的html页面拷贝到该网页进行php版本在线检测与自动选择Xdebug版本。
- 下载网站筛选出的xdebug-xx.tgz文件。
- 解压下载文件并进入xdebug-xx文件夹。

```
tar -xvzf xdebug-xx.tgz
cd xdebug-xx
```
- 输入`phpize`后返回结果：

```
Configuring for:
PHP Api Version:         20131106
Zend Module Api No:      20131226
Zend Extension Api No:   220131226
```
- 对于ubuntu与debian系统，假如提示没有phpize，安装下面包后再次执行phpize。

```
apt install php5-dev 
```
- 运行如下代码进行编译安装：

```
./configure
make
cp modules/xdebug.so /usr/lib/php5/20131226
```
- 编辑文件`/etc/php5/apache2/php.ini`，添加：

```
zend_extension = /usr/lib/php5/20131226/xdebug.so
[XDebug]
xdebug.remote_enable = 1
xdebug.remote_autostart = 1
```