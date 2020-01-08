---
title: Angularjs项目（1）
date: 2016-11-11 23:10:25
categories:
- 工作日常
- 前端框架
tags:
- Angularjs
permalink: Cwork
toc: 1
---

**原因**：2016年11月17日 星期四 由于工作需要，总结`Angularjs`与`JAVA EE`       开发过程中遇到的问题与解决办法，并进行记录。
**说明**：本记录中有许多软件需要前置依赖环境，譬如Netbeans之`Java`，Angularjs之`Node包管理器`，请查看`《Linux配置安装记录》`。
<!-- more -->

## 简介

### Angularjs简介
- Angularjs是谷歌开发的，开源的功能完善的JavaScript `模型-视图-控制器`（MVC--model-view-controllers）框架，[Angularjs](https://angularjs.org)，[jQuery](http://jquery.com)和[Twitter Bootstrap](http://getbootstrap.com/)是完美组合，仅用这三个工具就能迅速开发出[REST web](http://docs.oracle.com/javaee/6/tutorial/doc/gijqy.html)服务为后端的HTML5 JavaScript前端应用。

![Angularjs MVC ](http://image.yaopig.com/blog/angularjsmvc.png)
- Angularjs MVC 应用图解，作图工具：[Processon](http://www.processon.com/#)，支持团队在线跨平台作图。

---

### 单页应用
- 下述代码就是一个单页应用index.htm入口页面的代码，所有的动态内容都会插入`<div ng-view> </div>` 标签中。用户单击应用中的链接后，标签中现有的内容会被删除，插入新的动态内容。用户无需等待新页面刷新，新内容会动态显示出来，与加载新HTML页面相比，用时更少。

```html
<!-- SPA/index.html -->
<!DOCTYPE html>
<html lang="en" ng-app="helloWorldApp">

<head>
    <title>AngularJS Hello World</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script src="js/libs/angular.min.js"></script>
    <script src="js/libs/angular-route.min.js"></script>
    <script src="js/libs/angular-resource.min.js"></script>
    <script src="js/libs/angular-cookies.min.js"></script>
    <script src="js/app.js"></script>
    <script src="js/controllers.js"></script>
    <script src="js/services.js"></script>
</head>

<body>
    <div ng-view></div>
</body>

</html>
```


---
### 引导应用 
- 初次启动时应用加载Angularjs，页面加载库时会触发加载引导过程。解析器分析index.html。寻找ng-app标签，`<html lang="en" ng-app="helloWorldApp">`，这一句代码会触发js文件中如下的代码。这就是应用的接入口。在这一js文件中定义了名为helloWorldApp的应用（可以随意命名，这里保持一致是为了方便辨识），module里的是接入口，var后面的是应用名称。
```js
/* app.js excerpt */
`use strict`;
/* App Module */
var helloWorldApp = angular.module('helloWorldApp', [
    'ngRoute',
    'helloWorldControllers'
]);
```

---
### 依赖注入
- `依赖注入`（Dependency Injection,DI）是一种设计模式，目的是在配置应用时定义应用的依赖。初次启动应用时，Angularjs会使用依赖注入的模式加载模块的依赖。`引导应用`中我们为helloWorldApp应用定义了两个所需的依赖，这两个依赖在定义模块时通过一个数组参数指定，第一个依赖是Angualrjs的ngRoute`路由模块`。第二个则是自行定义的控制器，这里只需知道启动应用时需加载控制器，控制器会在后面提到。

---

### Angularjs路由
- 下述代码摘自app.js，定义了两个路由，/与/show。显而易见，当链接地址为xxx/时，会进入MainCtrl控制的main.html页面，而当点击xxx/show对应的内容时，会显示show.html页面内容
```js
/* app.js excerpt */
helloWorldApp.config(['$routeProvider', '$locationProvider',
    function($routeProvider, $locationProvider) {
        $routeProvider.
        when('/', {
            templateUrl: 'partials/mail.html',
            controller: 'MainCtrl'
        });
        when('/show', {
            templateUrl: 'partials/show.html',
            controller: 'ShowCtrl'
        });
    }
]);
```

## Netbeans Create Demo
---
### Netbeans
- 在官网进行下载  [Netbeans](http://www.netbeans.org)，选择带有`GlassFish`的版本。对下载的文件进行安装
```bash
chmod +x netbeans-8.1-linux.sh
./netbeans-8.1-linux.sh
```
![Alt text1](http://image.yaopig.com/blog/Unknown.png)
- 安装完成后，打开安装glassfish的文件夹。替换/glassfish/modules/中的文件org.eclipse.persistence.moxy.jar，文件在公司资料网中有提供。

---

### Server  :  RESTful Web Services
- 新建项目Maven：Web Application
![Alt text2](http://image.yaopig.com/blog/Unknown-2.png)
- Name and Location根据自己需要选择.
- server选择Netbeans自带的4.1.1版本，Java EE 7 Web.
![Alt text3](http://image.yaopig.com/blog/Unknown-3.png)
- 之后会弹出正在下载一些依赖文件，时间取决于网络
![Alt text4](http://image.yaopig.com/blog/Unknown-4.png)
- 右键新建的项目，对其新建RESTful Web Services from Database，选择sample样例数据库，并将数据库中表单全部添加，即Add all.
![Alt text5](http://image.yaopig.com/blog/Unknown-5.png)
- 之后不用更改，一路next。
- 如下图，在config文件中看到app的路径为webresources
![Alt text6](http://image.yaopig.com/blog/Unknown-6.png)
- 下图中，我们选取customer为演示样例，修改其路径为customers
![Alt text7](http://image.yaopig.com/blog/Unknown-7.png)
- 将工程的run路径修改为/webresources/customers，如下图
![Alt text8](http://image.yaopig.com/blog/Unknown-8.png)
- 再对工程新建一个Cross-Origin文件如下
![Alt text9](http://image.yaopig.com/blog/Unknown-9.png)
![Alt text10](http://image.yaopig.com/blog/Unknown-10.png)
- 这时选中该Server工程，点击Run（绿色三角），会弹出类似如下的效果：
![Alt text11](http://image.yaopig.com/blog/Unknown-11.png)
- 说明：出现XML格式文件即可，不必对照此图内的信息。

---
### Client Html/Angularjs
- 新建HTML工程如下，记得添加Angular seed
![Alt text12](http://image.yaopig.com/blog/Unknown-12.png)
![Alt text13](http://image.yaopig.com/blog/Unknown-13.png)
- 进入HTML工程所在文件夹安装依赖包
![Alt text14](http://image.yaopig.com/blog/Unknown-14.png)
- 这里全选
![Alt text15](http://image.yaopig.com/blog/Unknown-15.png)
- 建立完成后，发现项目并不可用，点击运行会提示无法加载Angualrjs，这是因为并没有在本地下载所需的依赖库文件，而已经建立了bower.json，内记录这所需的文件和版本号，只需进入该目录运行bower install即可
- 运行，可以发现Angular控制着版本号（v0.1），已经可以工作，环境搭建完毕
![Alt text](http://image.yaopig.com/blog/Unknown-16.png)

