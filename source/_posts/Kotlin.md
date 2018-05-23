---
title: Kotlin
toc: 1
top: 2
date: 2017-12-12 13:31:46
tags:
- Kotlin
categories:
- 自主学习
permalink:
---
**原因**：2017年12月12日 星期二 Kotlin笔记（个人兴趣）
**说明**：记录函数式编程思想
<!-- more -->

# 简介

## 数据类型

### 空类型和数据转换

- Java空指针示例

```
public class NullUnSafe {
    public static void main(String[] args) {
        System.out.println(getName().length());
    }

    public static String getName(){
        return null;
    }
}
```

- Kotlin示例

```
package net.println.kotlin

fun getName(): String?{
    return null
}

fun main(args: Array<String>) {
    println(getName()?.length)
}
```

- Java强转示例

```
public class TypeCast {
    public static void main(String[] args) {
        Parent parent = new Parent();
        System.out.println(((Child)parent).getName());
        
        if (parent instanceof Child){
            System.out.println(((Child) parent).getName());
        }
    }
}
```

- Kotlin Smart Cast

```
fun main(args: Array<String>) {
    val parent : Parent = Child()
    if(parent is Child){
        println(parent.name)
    }
}
```