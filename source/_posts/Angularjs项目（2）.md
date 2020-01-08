---
title: Angularjs项目（2）
date: 2016-11-23 23:10:25
categories:
- 工作日常
- 前端框架
tags:
- Angularjs
permalink: Cwork
toc: 1
---

**原因**：2016年11月23日 星期三 继Angularjs项目（1）后接着总结开发的经验与遇到的问题。
**说明**：本记录主要介绍`bower`与`MVC框架`。
<!-- more -->

## Bower
Bower 是`twitter`推出的一款包管理工具，基于nodejs的模块化思想，把功能分散到各个模块中，让模块和模块之间存在联系，通过 Bower 来管理模块间的这种联系。
包管理工具一般有以下的功能：
- 1.注册机制：每个包需要确定一个唯一的 ID 使得搜索和下载的时候能够正确匹配，所以包管理工具需要维护注册信息，可以依赖其他平台。
- 2.文件存储：确定文件存放的位置，下载的时候可以找到，当然这个地址在网络上是可访问的。
- 3.上传下载：这是工具的主要功能，能提高包使用的便利性。比如想用 jquery 只需要 install 一下就可以了，不用到处找下载。上传并不是必备的，根据文件存储的位置而定，但需要有一定的机制保障。
- 4.依赖分析：这也是包管理工具主要解决的问题之一，既然包之间是有联系的，那么下载的时候就需要处理他们之间的依赖。下载一个包的时候也需要下载依赖的包。

---

`nodejs`是时下流行的`javascript`运行环境，而`npm`就是其管理工具，而bower是解决js依赖关系的包工具，比如需要引入某个模块功能，只需` bower install xx`即可自动引入前置环境。
- 这里为什么要提到bower呢，现在下图是通过Netbeans建立的包含Angularjs Seed文件的项目文件图：
![Flod](http://image.yaopig.com/blog/Angularjs1.png)
![Bower.json](http://image.yaopig.com/blog/Angularjs2.png)
- Ubuntu下Ctrl+H即可显示隐藏文件，如图中左侧，为.bowerrc文件，它的作用就是在这一级目录下使用Bower时，bower下载的文件所要去的地址，右侧的bower.json是记录文件，这是angularjs-seed自动生成的(也可以通过bower init在当前目录下生成)，当工程发生位置变更时，为了减少存储负担，无需转移依赖库文件，只需在每次安装依赖时`bower install --save xx`其中xx为要安装的包，而在安装后，就会自动记录到bower.json的dependencies中。
- 当新建了Angularjs工程后，由于只是下载了angularjs-seed（包含bower.json），而并无包依赖文件，故在这一级目录下命令行输入`bower install`，bower就会自动从json文件中提取记录，下载想要的对应版本的依赖文件了。

---

## MVC
- 上一节简单介绍了Angularjs的应用引导，依赖注入，以及路由，这里介绍Angualrjs与MVC。Apache Struts,Spring MVC和Zend Framework等MVC框架在过去多年中是Web开发框架的领导者，对于这些框架，完全运行在服务器中，所有的功能，例如数据库、业务逻辑、现实逻辑和UI活动都在服务器中完成，因此要消耗服务器的内存和资源，虽然这种设计适用于大多数情况，但是近年来移动端的发展，这种设计模式在移动设备中是不可行的（原因自行查找，不再赘述），这里只介绍Angulajrs的MVC，与上述框架不同的是，Angularjs的视图、模型、控制器等模块都在web浏览器，或用户的设备中运行，解放了服务器，或者只让服务器处理业务逻辑和数据存储，极大的改善了用户体验。

---
### Angulajrs的视图（MVC中的V）
- 基本上只需要使用简单的HTML和CSS，很简单，不做介绍

---
### Angularjs的模型（MVC中的M）
- Angularjs在$scope对象中存储应用的模型，附在DOM上，如果想获取模型，可以使用赋给$scope对象的数据属性。

---
### Angularjs的控制器（MVC中的C）
- 技术核心，controller，要讲的太多，后文介绍。

