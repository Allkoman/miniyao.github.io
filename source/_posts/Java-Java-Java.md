---
title: Java
toc: 1
date: 2017-04-03 21:03:35
tags:
- Java
categories:
- 自主学习
permalink:
---
**原因**：2017年4月3日 星期一 拖延症之学习Java（个人兴趣）
**说明**：自从学了C之后变得懒惰至极，一直在前端和运维厮混没有入坑Java，自2014年唠叨入坑Java感受面向对象的乐趣至今仍旧没有刚过强迫症，本文定会是长文，排版及格式随时间线会更新，由于日常工作及健身时间较少，只能利用琐碎时间进行学习，故而定下flag学习周期为100天。
**状态**：updating now 2017-04-10 进度6/27
 <!-- more -->

## 学习资料
- 学习`Java 8`因为目测O司年底会放出`Java 9`，趁着版本稳定入坑慕课的`Java职业成长路径`，懒人不想自读官方文档及看书了，推视频毕竟能加快效率。
- 使用版本：JDK 1.8.152 
- 系统版本：macOS Sierra 10.12.4
- 使用编辑器：Intellij IDEA Ultimate 2017.1.1 EAP 及 sublime。

---

## 常量与变量
### 标识`zhi`符
![](http://okj8snz5g.bkt.clouddn.com/blog/biaozhifuzongjie.png)
![](http://okj8snz5g.bkt.clouddn.com/blog/biaozhifuguanjianzi.png)
![](http://okj8snz5g.bkt.clouddn.com/blog/biaozhifushujuleixing.png)
![](http://okj8snz5g.bkt.clouddn.com/blog/fenlei.png)
![](http://okj8snz5g.bkt.clouddn.com/blog/biaozhifuzimianzhi.png)
### 数据类型转换
![](http://okj8snz5g.bkt.clouddn.com/blog/zidongshujuleixingzhuanhuan.png)
![](http://okj8snz5g.bkt.clouddn.com/blog/qiangzhileixingzhuanhuan.png)
- 上图中`自动类型转换`虚线表示可能会有信息丢失的转换，实线表示无丢失的转换。

---
## 运算符
![](http://okj8snz5g.bkt.clouddn.com/blog/2017461.png)
![](http://okj8snz5g.bkt.clouddn.com/blog/2017462.png)
![](http://okj8snz5g.bkt.clouddn.com/blog/2017463.png)

---
## 流程控制之选择结构
- 这一部分讲解`if`、`if else`、`switch`等常用流程控制选择结构，无难点不多言。

---
## 流程控制之循环结构
- 这一部分讲解`do while`、`while`、`for`三种循环以及`break`、`continue`语句，无难点不多言。

---
## 数组之一维数组
- 这一部分讲解数组的声明、创建等过程，与C语言不同的是，`[]`的位置比较有趣，比如创建一个长度为6的整型数组：

```
int[] intArray = new int[6]; //java整型创建默认值为0
```
- 同样类似C的语法也可以写作：

```
int intArray[] = new int[6];
