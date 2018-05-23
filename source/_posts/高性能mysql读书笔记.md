---
title: 高性能mysql读书笔记
toc: 1
date: 2018-04-21 14:13:36
tags:
- 读书笔记
categories:
permalink:
---
**原因**：2018年4月21日 星期六
**说明**：读书笔记

<!-- more -->

##

共享锁 (shared lock) 读锁 (read lock)
排他锁 (exclusive lock) 写锁 (write lock)

### 事务
事务就是一组原子性的SQL查询，一个独立的工作单元。
原子性(atomicity) 一致性(consistency) 隔离性(isolation) 持久性(durability)

### 隔离级别
- READ UNCOMMITED ： 事务可以读取到未提交的数据，也被称为脏读。 (未提交读)
- READ COMMMITED ： 一个事务从开始到提交，所做的任何修改对其他事务都是不可见的 (提交读,不可重复读)
- REPEATTABLE READ ：解决脏读，Mysql通过MVVC多版本并发控制解决幻读。 (可重复读)
- SERIALIZABLE ：加读锁

###
InnoDB 两阶段锁定协议
,MyISAM

