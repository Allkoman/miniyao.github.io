---
title: Hexo-plugins&Issues
toc: 1
date: 2017-04-17 11:50:38
tags:
- hexo
ecategories:
- Practical
- Tips
permalink:
---
**原因**：2017年4月17日 星期一 解决使用hexo中遇到的问题
**说明**：虽说不要重复制造轮子，前提是轮子跑得起来。

<!-- more -->
{% aplayer "倒带" "miniyao" "http://image.yaopig.com/%E5%80%92%E5%B8%A6.mp3" "http://image.yaopig.com/blog/nvpu2.jpg" %}
## 简介
- 本文用于介绍使用hexo架构博客半年来的奇技淫巧，使用后才有发言权，摸着石头过河后也该搭一座自己的桥了。
- 特别感谢[MOxFIVE](https://github.com/MOxFIVE/hexo-theme-yelee)由[yilia](https://github.com/litten/hexo-theme-yilia)改版而来的`yelee`主题。
- 本文针对hexo版本信息如下，不同版本可能并不适用。

![](http://image.yaopig.com/blog/hexo-version.png)
<div a></div>
### hexo代码块解析异常
- 当时用`markdown`插入代码块时，hexo部署后出现代码块无法解析空行的问题，影响页面代码块的显示，如下图。
![](http://image.yaopig.com/blog/hexo-code.png)
- 解决办法为修改`highlight.js`文件的解析办法，从`div`判断改为`span`
- 文件路径为：`blog/node_modules/hexo-util/highlight.js`
- 修改该文件35-38行为如下内容：

```
      numbers += '<span class="line">' + (firstLine + i) + '</span>\n';
      content += '<span class="line';
      content += (mark.indexOf(firstLine + i) !== -1) ? ' marked' : '';
      content += '">' + line + '</span>\n';
```
- 修改后重启`hexo server`，显示如下。
![](http://image.yaopig.com/blog/hexo-codesupp.png)
- 成功解决无法解析换行的问题。

### hexo字数统计扩展
- `yelee`主题使用`不蒜子统计`，在博客`footer`显示到访人数，经过使用`hexo-wordcount`插件可以显示`文章字数`,`站点字数`,`阅读时间`等功能，具体查看[wordcount](https://github.com/willin/hexo-wordcount)。
- 安装：

```
npm install hexo-wordcount --save
```
- 插件参数：

__字数统计 WordCount__:`wordcount(post.content)`
__阅读时长预计 Min2Read__:`min2read(post.content)`
__总字数统计 TotalCount__:`totalcount(site, '0,0.0a')`
- 适用于Swig,Ejs,Jade等环境，我这里`yelee`主题使用的是`Ejs`。
- 在这里介绍我是如何使用`WordCount`以及`TotalCount`功能的，`Min2Read`遇到了一些bug，解决后会更新。如果读者有好的解决办法也可以在评论区联系我。

---
#### WordCount
- 修改`blog/themes/yelee/layout/_partial/post/nav.ejs`文件，在第8行插入` <p><span class="post-count">文章字数:</span><%= wordcount(post.content) %></p> //添加本行`，如下：

```ejs
<% if ((post.original != false && !is_page() && theme.copyright) || post.original){ %>
    <div class="copyright">
        <p><span><%= __('copyright_info.title') %>:</span><a href="<%- url_for(post.path) %>"><%= post.title %></a></p>
        <p><span><%= __('copyright_info.author') %>:</span><a href="/" title="<%= __('tooltip.back2home') %>"><%=theme.author%></a></p>
        <p><span class="post-count">文章字数:</span><%= wordcount(post.content) %></p> //添加本行
        <p><span><%= __('copyright_info.date') %>:</span><%= post.date.format("YYYY-MM-DD, HH:mm:ss") %></p>
        <p><span><%= __('copyright_info.updated') %>:</span><%= post.updated.format("YYYY-MM-DD, HH:mm:ss") %></p>
        <p>
            <span><%= __('copyright_info.url') %>:</span><a class="post-url" href="<%- url_for(post.path) %>" title="<%= post.title %>"><%= post.permalink %></a>
            <span class="copy-path" data-clipboard-text="<%= __('copyright_info.from') %> <%= post.permalink %>　　<%= __('copyright_info.by') %> <%=theme.author%>" title="<%= __('tooltip.copyPath') %>"><i class="fa fa-clipboard"></i></span>
            <script> var clipboard = new Clipboard('.copy-path'); </script>
        </p>
        <p>
            <span><%= __('copyright_info.license') %>:</span><i class="fa fa-creative-commons"></i> <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/" title="CC BY-NC-SA 4.0 International" target = "_blank">"<%= __('copyright_info.cc') %>"</a> <%= __('copyright_info.notice') %>
        </p>
    </div>
<% } %>

<% if (post.prev || post.next){ %>
    <nav id="article-nav">
        <% if (post.prev){ %>
            <div id="article-nav-newer" class="article-nav-title">
                <a href="<%- url_for(post.prev.path) %>">
                    <%= post.prev.title %>
                </a>
            </div>
        <% } %>
        <% if (post.next){ %>
            <div id="article-nav-older" class="article-nav-title">
                <a href="<%- url_for(post.next.path) %>">
                    <%= post.next.title %>
                </a>
            </div>
        <% } %>
    </nav>
<% } %>
```
- 在页面底部的`copyright`可看到多出一项`文章字数`:

![](http://image.yaopig.com/blog/hexo-wordcount1-1.png)

---
#### TotalCount
- TotalCount可集成在底部`不蒜子统计`中，具体操作为：
- 修改`blog/themes/yelee/layout/_partial/footer.ejs`文件，在代码27行后添加：

```
                   <span title="本站总字数统计">
                         <span><i class="fa fa-map" aria-hidden="true"></i></span>
                        <span class="post-count"><b><%= totalcount(site) %></b></span>
                    </span>
```
- 添加后显示为：

```
<footer id="footer">
    <div class="outer">
        <div id="footer-info">
            <div class="footer-left">
                <i class="fa fa-copyright"></i> 
                <% if (theme.since && !isNaN(theme.since) && theme.since < date(new Date(), 'YYYY')) { %><%- theme.since%>-<% } %><%= date(new Date(), 'YYYY') %> <%= config.author || config.title %>
            </div>
            <div class="footer-right">
                <a href="http://hexo.io/" target="_blank" title="<%= __('tooltip.Hexo') %>">Hexo</a>  Theme <a href="https://github.com/MOxFIVE/hexo-theme-yelee" target="_blank" title="<%= __('tooltip.Yelee') %>  v<%= theme.Yelee %>">Yelee</a> by MOxFIVE <i class="fa fa-heart animated infinite pulse"></i>
            </div>
        </div>
        <% if (theme.visit_counter.on) { %>
            <div class="visit">
                <% if (theme.visit_counter.site_visit) { %>
                    <span id="busuanzi_container_site_pv" style='display:none'>
                        <span id="site-visit" title="<%= __('visit_counter.site') %>"><i class="fa fa-user" aria-hidden="true"></i><span id="busuanzi_value_site_uv"></span>
                        </span>
                    </span>
                <% } %>
                <% if (theme.visit_counter.site_visit && theme.visit_counter.page_visit) { %>
                    <span>| </span>
                <% } %>
                <% if (theme.visit_counter.page_visit) { %>
                    <span id="busuanzi_container_page_pv" style='display:none'>
                        <span id="page-visit"  title="<%= __('visit_counter.page') %>"><i class="fa fa-eye animated infinite pulse" aria-hidden="true"></i><span id="busuanzi_value_page_pv"></span>
                        </span>
                    </span>
                    <span>| </span>
                    <span title="本站总字数统计">
                         <span><i class="fa fa-map" aria-hidden="true"></i></span>
                        <span class="post-count"><b><%= totalcount(site) %></b></span>
                    </span>
                <% } %>
            </div>
        <% } %>
    </div>
</footer>
```
- 最终显示效果如下：

![](http://image.yaopig.com/blog/hexo-footer1.png)

---
### hexo使用图床

#### 定义
- 就是专门用来存放图片，同时允许你把图片对外连接的网上空间，不少图床都是免费的。

---

#### 用途
- 个人认为是开发的一种奇技淫巧了，最早的邮箱传图，简单的qq截图等都不失为一种好用的信息传递方式，但是当你书写文本，或者建设网站需要大批量插入图片时，图片的质量与大小都会制约你网站的速度和书写文本的大小，当然插入本地图片很简单。但会对你的版本发布产生一些小的麻烦。所以这里记录我自己的图床使用方式，利人利己。
- 我使用的是国内免费七牛云，快捷方便，安全免费。

#### 用法
- 注册，登录
- 新建存储空间
- 找一个趁手的客户端，我这里用的是ipic，国内大大出品，好用简洁，只有mac
具体使用很简单，在ipic设置好image host是七牛，填写你自己七牛账户的相应信息，大致如下图
![面板](http://image.yaopig.com/blog/mbb.png)
- 填写好信息后，在你的内容管理内能看到最近上传了哪些图，我一般会选择上传时就压缩，精简，能看就成，质量也不差，同时可以在线下载，预览，生成外链，有了外链用处就很多了。如下图。
![七牛](http://image.yaopig.com/blog/qiniu2.png)
![上传](http://image.yaopig.com/blog/mianban.png)
- 上图转圈转了一半的就是ipic正在往服务器传送本地的图，最骚的是传送完会直接生成md格式的图片插入外链，直接ctrl+v，完成图片插入，省时省力。

---
### hexo音乐Aplayer
- 插件github[官方地址](https://github.com/grzhan/hexo-tag-aplayer)，有详细介绍。
- 安装插件：

```
npm install --save hexo-tag-aplayer
```
- 使用方式：

```
{% aplayer title author url [picture_url, narrow, autoplay, width:xxx, lrc:xxx] %}
```

- 参数：

+ `title` : music title
+ `author`: music author
+ `url`: music file url
+ `picture_url`: optional, music picture url
+ `narrow`: optional, narrow style
+ `autoplay`: optional, autoplay music, not supported by mobile browsers
+ `width:xxx`: optional, prefix `width:`, player's width (default: 100%)
+ `lrc:xxx`: optional, prefix `lrc:`, LRC file url

- 例子

```
{% aplayer "Caffeine" "Jeff Williams" "caffeine.mp3" "autoplay" "width:70%" "lrc:caffeine.txt" %}
```

---
### hexo动画效果
- [canvas-nest.js](https://github.com/hustcc/canvas-nest.js/blob/master/README-zh.md)是一个不依赖任何框架or内库的原生js插件，非常非常小，仅有1.6kb，效果可见[demo](http://jerey.cn/)
- Ejs架构yelee使用办法：
- 在`blog/themes/yelee/layout/layout.ejs`的body标签内添加代码:

```
<script type="text/javascript" color="0,0,255" opacity='0.7' zIndex="-2" count="99" src="//cdn.bootcss.com/canvas-nest.js/1.0.1/canvas-nest.min.js"></script>
```
- 注意其中的属性分别为：
- color: 线条颜色, 默认: '0,0,0' ；三个数字分别为(R,G,B)，注意用,分割
- opacity: 线条透明度（0~1）, 默认: 0.5
- count: 线条的总数量, 默认: 150
- zIndex: 背景的z-index属性，css属性用于控制所在层的位置, 默认: -1

---
