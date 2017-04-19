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
**状态**：updating now 2017-04-19 进度11/27
 <!-- more -->

## 学习资料
- 学习`Java 8`因为目测O司年底会放出`Java 9`，趁着版本稳定入坑慕课的`Java职业成长路径`，懒人不想自读官方文档及看书了，推视频毕竟能加快效率。
- 使用版本：JDK 1.8.152 
- 系统版本：macOS Sierra 10.12.4
- 使用编辑器：Intellij IDEA Ultimate 2017.1.2 EAP 及 Sublime。

---

## 基础语法

### 常量与变量
#### 标识`zhi`符
![](http://okj8snz5g.bkt.clouddn.com/blog/biaozhifuzongjie.png)
![](http://okj8snz5g.bkt.clouddn.com/blog/biaozhifuguanjianzi.png)
![](http://okj8snz5g.bkt.clouddn.com/blog/biaozhifushujuleixing.png)
![](http://okj8snz5g.bkt.clouddn.com/blog/fenlei.png)
![](http://okj8snz5g.bkt.clouddn.com/blog/biaozhifuzimianzhi.png)
#### 数据类型转换
![](http://okj8snz5g.bkt.clouddn.com/blog/zidongshujuleixingzhuanhuan.png)
![](http://okj8snz5g.bkt.clouddn.com/blog/qiangzhileixingzhuanhuan.png)
- 上图中`自动类型转换`虚线表示可能会有信息丢失的转换，实线表示无丢失的转换。

---

### 运算符
![](http://okj8snz5g.bkt.clouddn.com/blog/2017461.png)
![](http://okj8snz5g.bkt.clouddn.com/blog/2017462.png)
![](http://okj8snz5g.bkt.clouddn.com/blog/2017463.png)

---

### 流程控制之选择结构
- 这一部分讲解`if`、`if else`、`switch`等常用流程控制选择结构，无难点不多言。

---

### 流程控制之循环结构
- 这一部分讲解`do while`、`while`、`for`三种循环以及`break`、`continue`语句，无难点不多言。

---

### 数组之一维数组
- 这一部分讲解数组的声明、创建等过程，与C语言不同的是，`[]`的位置比较有趣，比如创建一个长度为6的整型数组：

```
int[] intArray = new int[6]; //java整型创建默认值为0
```
- 同样类似C的语法也可以写作：

```
int intArray[] = new int[6];
```

---

### 数组之二维数组
- 二维数组的声明和创建
- 二维数组的初始化
- 二维数组的引用

```java
package com.imooc.array;

public class ArrayDemo5 {
    public static void main(String[] args){
        //二维数组的声明
        //三种形式
        //声明int类型的二维数组
        int[][] intArray;
        //声明float类型的二维数组
        float floatArray[][];
        //声明double类型的二维数组
        double[] doubleArray[];
        //创建一个三行三列的int类型的数组
        intArray=new int[3][3];
        System.out.println("intArray数组的第3行第2列的元素为："+intArray[2][1]);
        //为第2行第3个元素赋值为9
        intArray[1][2]=9;
        System.out.println("intArray数组第2行第3列的元素为:"+intArray[1][2]);
        //声明数组的同时进行创建
        char[][] ch=new char[3][5];
        //创建float类型的数组时，只指定行数
        floatArray=new float[3][];
        //System.out.println(floatArray[0][0]);
        //每行相当于一个一维数组，需要创建
        floatArray[0]=new float[3];//第一行有三列
        floatArray[1]=new float[4];//第二行有四列
        floatArray[2]=new float[5];//第三行有5列
        System.out.println(floatArray[0][0]);
        //System.out.println(floatArray[0][3]);//数组下标越界
        //二维数组的初始化
        int[][] num={{1,2,3},{4,5,6},{7,8,9}}; 
        System.out.println("num数组第1行第2列的元素为："+num[0][1]);
        System.out.println("num数组的行数为："+num.length);
        System.out.println("num数组的列数为:"+num[0].length);
        int[][] num1={{78,98},{65,75,63},{98}};
        System.out.println("num1数组的第1行的列数为:"+num1[0].length);
        //循环输出二维数组的内容
        for(int i=0;i<num1.length;i++){
            for(int j=0;j<num1[i].length;j++){
                System.out.print(num1[i][j]+"     ");
            }
            System.out.println();
        }
    }
}
```

---

### 方法

__什么是方法？__
- 所谓方法，就是用来解决一类问题的代码的有序组合，是一个功能模块。

__主要内容__
- 方法的声明
- 方法的重载

__方法声明__
- 语法格式

```
访问修饰符  返回类型  方法名(参数列表){

}
```

__方法分类__
- 根据方法是否带参数、是否有返回值，可分为四类:
- 无参无返回值
- 无参带返回值
- 带参无返回值
- 带参带返回值

__方法重载__
- 方法名相同，参数列表不同

__可变参数列表总结__
- 可变参数一定是方法中的最后一个参数
- 数组可以传递给可变参数的方法，反之不行
- 在重载中，含有可变参数的方法是最后被选中的

---

## 面向对象
### 面向对象


