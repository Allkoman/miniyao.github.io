---
title: Mac之自用软件推荐
date: 2017-01-28 05:38:52
tags:
- Mac Apps
categories:
- 生活娱乐
- 随笔
- 新年快乐
permalink: Swork
toc: 1000

---
**原因**：2017年1月28日 星期六 随笔记录。
**说明**：本文主要记录自用Mac软件，`多图移动端流量慎入`。

<!-- more -->

{% aplayer "成都" "赵雷" "http://image.yaopig.com/%E8%B5%B5%E9%9B%B7-%E6%88%90%E9%83%BD.mp3" "http://image.yaopig.com/blog/chengdu.jpg" %}

---

## 前言
使用Mac四年有余，对于我来说，Mac是一片纯净的环境，适于学习，适于开发。同时入门Linux半年，多多少少有一些软件及好玩的东西，写下来，总结自己，帮助别人。这里我用的基本都是正版，支持正版！支持正版！东西都是码农写的，用的大多也是码农，友军不要互相伤害！可在右侧使用目录跳转到你喜欢的部分阅读。
### 类型及价格
| 软件                                      | 类型                | 价格   |
| -------------                             | :-------------:     | -----: |
| [Dash](https://kapeli.com/dash)           | 编程／查询          | $24.99 |
| Shadowsocks                               | 科学上网            | 0      |
| Movist                                    | 播放器              | ¥30    |
| [CleanMyMac](http://www.mycleanmymac.com) | 清理                | ¥99    |
| iTranslate                                 | 翻译                | 0      |
| DaisyDisk                                 | 磁盘分析            | ¥68    |
| 1Password                                 | 密码管理            | ¥418   |
| Unibox                                    | 邮箱客户端          | ¥108   |
| PdfExpert                                 | PDF查看编辑         | ¥388   |
| [Omni系列](https://www.omnigroup.com)     | 项目流程管理        | ++     |
| [Evernot](https://www.yinxiang.com)       | 笔记                | 0      |
| istat mini/Monity                         | 状态查看            | cheap  |
| network speed monitor                     | 实时网速            | cheap  |
| [Sublime](http://www.sublimetext.com)     | 编辑器              | $70    |
| Spark                                     | 邮箱客户端          | 0      |
| [Tunnelblick](https://tunnelblick.net)    | VPN                 | 0      |
| SSH shell                                 | SSH客户端           | ¥68    |
| Dukto                                     | 局域网文件传输      | 0      |
| [Synergy](https://symless.com/synergy/)   | 局域网键鼠共享      | $19    |
| [Alfred3](https://www.alfredapp.com)      | 效率                | ￡19   |
| Manico                                    | 快速切换软件        | 0      |
| SwitchResx                                | 多屏幕扩展DIY分辨率 | --     |
| Affinity photo                            | 类PS                | ¥258   |
| Transmit                                  | FTP等文件传输       | ¥228   |
| Moom                                      | 快捷调整窗口大小    | ¥68    |
| Microsoft remote desktop                  | 远程桌面            | 0      |
| Newfilemenu                               | 新建文件            | ¥12    |
---

## 详细介绍
这里我将以自己使用的体验来介绍各个软件的使用情况，仅作为各位的参考，详细软件是否值得使用还是各位自行官方查看后下载体验为准。

---
### Dash
>Dash is an API Documentation Browser and Code Snippet Manager. Dash stores snippets of code and instantly searches offline documentation sets for 150+ APIs (for a full list, see below). You can even generate your own docsets or request docsets to be included.说白了这厮就是API文档查看神器，移动端目前支持IOS，没有安卓设备并不知道是否支持，OS也只有mac有，真心很好用，话不多说上图，图来源为官网及我自己整理。

---
![Dash1](http://image.yaopig.com/blog/dash-s1.png)
![Dash2](http://image.yaopig.com/blog/dash-s2.png)
![Dash3](http://image.yaopig.com/blog/dash-s3.png)
`同时支持大量软件，作为Plugin：`
![Dash1](http://image.yaopig.com/blog/dash-s4.png)

- 个人觉得Dash是神器一枚，可以极大程度提高你的开发效率，但是毕竟它也是收录各个环境、语言的官方API文件，所以美中不足是不支持中文。同时强大的代码片段功能使你可以快速查阅函数、方法调用等的具体用法。
- 无论是新上手一门语言亦或者在某个语言环境奋战很久，经历很多版本迭代的老程序员，都需要常常查看API文档，Dash都是程序员必备的效率工具。
- 下面是我展示的众多扩展支持的一项：

![](http://image.yaopig.com/blog/dashteriminal.jpg)
- 在命令行里输入：

```
open dash://php:{query}
```
- 即可搜索你想要的关键词。

---

### Shadowsocks

- 科学上网利器 ：A secure socks5 proxy,designed to protect your Internet traffic.
- GitHub 开源项目
- 同门师兄弟ShaodowsocksR等闭源
- 后文简称为`ss`
- 现在网上关于如何自己租用vps到自开ss的教程一搜一大把，大致流程都是租哪一家的服务器，搭建个Linux环境，安装ss-server，随后按照自己的加密方式，在客户端进行连接。客户端支持mac,window,linux及移动端全产品线使用，对于PC端，Google之一大把ss客户端，配置方法简单易懂，而对于移动端，我在ios使用的是Surge（肉疼买的时候600+），后来知道美区商店有卖土豆丝和小火箭的，很便宜，物美价廉不影响使用。
- 关于ss PAC模式，全局模式，及路由器刷入ss开启真全局，or PC端软件转发实现转发socks5-UDP实现ss打游戏等，自己常用的会后续拿来分享，因为涉及到的知识比较多。

<div align="center">
    ![shadowsocks](http://image.yaopig.com/blog/shadowsocks.png)
</div>

- 关于VPS机房，现在香港小油管，动不动就是2M带宽，真心坑，但是香港延迟低啊！譬如美国直连中国的海底光纤，那么长的光纤，延迟开销就会不低，我用的Linode洛杉矶等地的机房延迟都很高，浏览网页看视频还行，打游戏的话就不太好了。目前最好的是东京Linode开的第二个机房，性价比合适，延迟or带宽都适中，各位按自己的需求决定购买。
- 关于懒得自建vps，购买三方的，请先足够多的调研卖家会不会跑路，是否稳定，尽量月付，不要贪小便宜年费VIP，因为机房线路国际网络复杂，ZF又比较事儿，小心年费后用两天瞬间爆炸。同时，在和vps差不多价位的同时，购买可以使用多条线路也是不错的选择，省事省心。

### Movist
- 如下图，好东西，mac下播放器中的唯一极品，解析各种格式，同时可以倍速播放，功能太多不一一解释。

![](http://image.yaopig.com/blog/Jietu20170418-094048-2x.jpg)

---
### CleanMyMac
- 网址：http://www.mycleanmymac.com
- 主打功能：系统清理(也就清理一下缓存)，程序卸载（大多是自带配置文件的程序系统自带卸载不干净），健康监测（没啥用），文件粉碎（没用过），拓展管理（没用过），系统维护（没用过）

---
### iTranslate
- 在线翻译软件，支持语言比较多，用多了也蛮鸡肋的，单词右键直接系统翻译了，而大型的句子段落还是谷歌翻译靠谱，唯一的好处就是短语的发音查起来比较便捷。

![](http://image.yaopig.com/blog/Jietu20170418-100457-2x.jpg)

---

### DaisyDisk
- 神器，虽说不是自动化清理软件，但是对于层级浏览磁盘，查看大文件很有用，并且不仅仅是可以扫描本机硬盘，外置U盘也可以！。
- 当然版本分为AppStore版和官网版，推荐使用官网的stand-alone版本（免费），能够给予权限扫描权限不足的文件，否则你的mac会有很大的hidden-space不让你查看的哦。

![](http://image.yaopig.com/blog/020805.jpg)
![](http://image.yaopig.com/blog/Jietu20170418-100829-2x.jpg)

---
### 1Password
- 插件众多，支持mac以及ios产品线，记忆力不好的小伙伴分门别类记忆密码的好软件，不过自从前年safari更新后，大多网站safari也可以记忆密码，1Password对我来说就不是刚需了，仅仅留着作为了记忆库

---

### Unibox
- 邮箱客户端，支持gmail以及网易，重点是mbp上支持网易的太少了，而且界面做的很像聊天，UI美观精致。

![](http://image.yaopig.com/blog/Jietu20170418-102605-2x.jpg)

## 结语
- 暂时先写这么多，后面的大家可以根据名字和简介自行查看一二，我相信官方文档比我写的更精彩。


