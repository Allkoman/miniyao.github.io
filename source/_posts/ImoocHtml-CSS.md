---
title: Imooc之Html与CSS
toc: 1
date: 2017-04-19 20:27:46
tags:
- Imooc
categories:
- 自主学习
permalink:
---
**原因**：2017年4月19日 星期三 其实是在复习
**说明**：学无止境哦。

<!-- more -->

```python
def my_abs(x): 
if x >= 0: 
        return x 
    else: 
        return -x
```
## Imooc Html
### span、em、strong
-  `<em>`和`<strong>`标签是为了强调一段话中的关键字时使用，它们的语义是强调。
-  `<span>`标签是没有语义的，它的作用就是为了设置单独的样式用的。

---

### img标签
- src：标识图像的位置；
- alt：指定图像的描述性文本，当图像不可见时（下载不成功时），可看到该属性指定的文本；
- title：提供在图像可见时对图像的描述(鼠标滑过图片时显示的文本)；
- 图像可以是GIF，PNG，JPEG格式的图像文件。

### mailto

```html
<a href="mailto:yy@imooc.com?subject=观后感&body=你好">对此影评有何感想，发送邮件给我</a>
```

---

### blockquote
- 长文本引用

### q标签
- 短文本引用，自带双引号

### 空格、水平横线、单行多行代码
```html
&nbsp;  <!-- 空格 --> 
<hr/>  <!-- 水平横线 -->
<address>为网页加入地址信息</address>
<code>var i = i + 300;</code> <!-- 插入单行代码 -->
<pre>
  var message="欢迎";
  for(var i=1;i<=10;i++)
  {
     alert(message);
  }
</pre>
```

---

### form标签
- 表单是可以把浏览者输入的数据传送到服务器端，这样服务器端程序就可以处理表单传过来的数据。
- 语法：

```
<form   method="传送方式"   action="服务器文件">
```

### 文本域
- textarea标签：

```html
<textarea  rows="行数" cols="列数">文本</textarea>
```

---

### 单选框复选框
- 语法：

```
<input   type="radio/checkbox"   value="值"    name="名称"   checked="checked"/>
```
- type:
- 当 type="radio" 时，控件为单选框
- 当 type="checkbox" 时，控件为复选框
- value：提交数据到服务器的值（后台程序PHP使用）
- name：为控件命名，以备后台程序 ASP、PHP 使用
- checked：当设置 checked="checked" 时，该选项被默认选中

---

### 下拉列表框
```html
<form action="save.php" method="post" >
    <label>爱好:</label>
    <select multiple="multiple">
      <option value="看书">看书</option>
      <option value="旅游" selected = "selected">旅游</option>
      <option value="运动">运动</option>
      <option value="购物">购物</option>
    </select>
</form>
```
---

### 提交、重置

```
<input type="submit" value="提交">
<input type="reset" value="重置">
```

### label
- label标签不会向用户呈现任何特殊效果，它的作用是为鼠标用户改进了可用性。如果你在 label 标签内点击文本，就会触发此控件。就是说，当用户单击选中该label标签时，浏览器就会自动将焦点转到和标签相关的表单控件上（就自动选中和该label标签相关连的表单控件上）。
- lable的for与控件的id对应。

---

## Imooc CSS

### 认识CSS样式
- CSS全称为“层叠样式表 (Cascading Style Sheets)”，它主要是用于定义HTML内容在浏览器内的显示样式，如文字大小、颜色、字体加粗等。

#### CSS代码语法
- css 样式由选择符和声明组成，而声明又由属性和值组成。
- 选择符：又称选择器，指明网页中要应用样式规则的元素，如本例中是网页中所有的段（p）的文字将变成蓝色，而其他的元素（如ol）不会受到影响。
- 声明：在英文大括号“｛｝”中的的就是声明，属性和值之间用英文冒号“：”分隔。当有多条声明时，中间可以英文分号“;”分隔，如下所示：

```
p{font-size:12px;color:red;}
```

---

#### 内联式css样式
- 直接写在现有的HTML标签中

```
<p style="color:red">这里文字是红色。</p>
```

---

#### 嵌入式css样式
- 写在当前的文件中

```
<style type="text/css">
span{
color:red;
}
</style>
```

#### 外部式css样式
- 写在单独的一个文件中

```
<link href="base.css" rel="stylesheet" type="text/css" />
```
- css样式文件名称以有意义的英文字母命名，如 main.css。
- rel="stylesheet" type="text/css" 是固定写法不可修改。
- `<link>`标签位置一般写在`<head>`标签之内。

---

#### 三种方法的优先级
- 内联式 > 嵌入式 > 外部式
- 但是嵌入式>外部式有一个前提： 嵌入式css样式的位置一定在外部式的后面
- 其实总结来说，就是--就近原则（离被设置元素越近优先级别越高）

---
### CSS选择器
#### 什么是选择器

```
选择器{
    样式；
}
```

---

#### 标签选择器
- 标签选择器其实就是html代码中的标签。如右侧代码编辑器中的`<html>、<body>、<h1>、<p>、<img>`

---

#### 类选择器
>1、英文圆点开头
 2、其中类选器名称可以任意起名（但不要起中文噢）
使用方法：
第一步：使用合适的标签把要修饰的内容标记起来，如下：
`<span>`胆小如鼠`</span>`
第二步：使用class="类选择器名称"为标签设置一个类，如下：


```
<span class="stress">胆小如鼠</span>
```
>第三步：设置类选器css样式，如下：
.stress{color:red;}

---

#### ID选择器
- 在很多方面，ID选择器都类似于类选择符，但也有一些重要的区别：

<p>1、为标签设置id="ID名称"，而不是class="类名称"。</p>
<p>2、ID选择符的前面是井号（#）号，而不是英文圆点（.）。</p>

---

#### ID和类选择器的区别
- 相同点：可以应用于任何元素
- 不同点：

<p>1、ID选择器只能在文档中使用一次。与类选择器不同，在一个HTML文档中，ID选择器只能使用一次，而且仅一次。而类选择器可以使用多次。</p>
<p>2、可以使用类选择器词列表方法为一个元素同时设置多个样式。我们可以为一个元素同时设多个样式，但只可以用类选择器的方法实现，ID选择器是不可以的（不能使用 ID 词列表）。</p>

---

#### 子选择器
- 还有一个比较有用的选择器子选择器，即大于符号(>),用于选择指定标签元素的第一代子元素。

```
.first>span{color:red;}
```

---
#### 包含(后代)选择器
- 包含选择器，即加入空格,用于选择指定标签元素下的后辈元素。如代码：

```
.first  span{color:red;}
```
- 这行代码会使span中字体颜色变为红色。

```
p span{color:red;}
```

- 这行代码意为只选择作为p元素的span元素
- 请注意这个选择器与子选择器的区别，子选择器（child selector）仅是指它的直接后代，或者你可以理解为作用于子元素的第一代后代。而后代选择器是作用于所有子后代元素。后代选择器通过空格来进行选择，而子选择器是通过“>”进行选择。
- 总结：>作用于元素的第一代后代，空格作用于元素的所有后代

---

#### 通用选择器
- 通用选择器是功能最强大的选择器，它使用一个（*）号指定，它的作用是匹配html中所有标签元素，如下使用下面代码使用html中任意标签元素字体颜色全部设置为红色：

```
* {color:red;}
```

---

#### 伪类选择符
- 更有趣的是伪类选择符，为什么叫做伪类选择符，它允许给html不存在的标签（标签的某种状态）设置样式

---

#### 分组选择符
- 当你想为html中多个标签元素设置同一个样式时，可以使用分组选择符（，），如下代码为编辑器中的h1、span标签同时设置字体颜色为红色：

```
h1,span{color:red;}
```

---

#### 总结
>标签选择器，标签名{}，作用于所有此标签。
类选择器， .class{}，在标签内定义class=""，属图形结构。
ID选择器，#ID{}, 在标签内定义id=""，有严格的一一对应关系。
子选择器， .span>li{}，作用于父元素span类下一层的li标签。
包含选择器，.span li{}，作用于父元素span下所有li标签。
通用选择器，*{}，匹配所有html的标签元素。

---

### CSS的继承、层叠和特殊性
#### 继承
- CSS的某些样式是具有继承性的，那么什么是继承呢？继承是一种规则，它允许样式不仅应用于某个特定html标签元素，而且应用于其后代。比如下面代码：如某种颜色应用于p标签，这个颜色设置不仅应用p标签，还应用于p标签中的所有子元素文本，这里子元素为span标签。

---

#### 特殊性
- 标签的权值为1，类选择符的权值为10，ID选择符的权值最高为100。例如下面的代码：

```
p{color:red;} /*权值为1*/
p span{color:green;} /*权值为1+1=2*/
.warning{color:white;} /*权值为10*/
p span.warning{color:purple;} /*权值为1+1+10=12*/
#footer .note p{color:yellow;} /*权值为100+10+1=111*/
```

#### 层叠

- 相同权重，覆盖。内联样式表（标签内部）> 嵌入样式表（当前文件中）> 外部样式表（外部文件中）。

---

#### 重要性
- 我们在做网页代码的时，有些特殊的情况需要为某些样式设置具有最高权值，怎么办？这时候我们可以使用!important来解决。

```
p{color:red!important;}
p{color:green;}
<p class="first">三年级时，我还是一个<span>胆小如鼠</span>的小女孩。</p>
```

---

### CSS格式化排版
#### 字体
- 粗体:{font-weight:bold;}
- 斜体:{font-style:italic;}
- 下划线:{text-decoration:underline;}
- 删除线:{text-decoration:line-through;}

---
#### 段落排版--缩进
- 设置两个空格缩进:{text-indent:2em;}

---

#### 段落排版--行间距（行高）
- 设置行间距为2em:{line-height:2em;}

---

#### 段落排版--中文字间距、字母间距

```h1{
    letter-spacing:50px;
}
...
<h1>了不起的盖茨比</h1>
h1{
    word-spacing:50px;
}
...
<h1>welcome to imooc!</h1>
```

---

#### 段落排版--对齐

```
h1{
    text-align:center;
}
<h1>了不起的盖茨比</h1>
```
- 这是块状元素中的文本

---
### CSS盒模型
- 在讲解CSS布局之前，我们需要提前知道一些知识，在CSS中，html中的标签元素大体被分为三种不同的类型：块状元素、内联元素(又叫行内元素)和内联块状元素。
- 常用的块状元素有：

```
<div>、<p>、<h1>...<h6>、<ol>、<ul>、<dl>、<table>、<address>、<blockquote> 、<form>
```
- 常用的内联元素有：

```
<a>、<span>、<br>、<i>、<em>、<strong>、<label>、<q>、<var>、<cite>、<code>
```
- 常用的内联块状元素有：

```
<img>、<input>
```

---

#### 元素分类--块级元素
- 什么是块级元素？在html中`<div>、 <p>、<h1>、<form>、<ul> 和 <li>`就是块级元素。设置display:block就是将元素显示为块级元素。如下代码就是将内联元素a转换为块状元素，从而使a元素具有块状元素特点。

```
a{display:block;}
```
- 块级元素特点：
- 每个块级元素都从新的一行开始，并且其后的元素也另起一行。（真霸道，一个块级元素独占一行）
- 元素的高度、宽度、行高以及顶和底边距都可设置。
- 元素宽度在不设置的情况下，是它本身父容器的100%（和父元素的宽度一致），除非设定一个宽度。

---
#### 元素分类--内联元素
- 在html中，`<span>、<a>、<label>、 <strong> 和<em>`就是典型的内联元素（行内元素）（inline）元素。当然块状元素也可以通过代码display:inline将元素设置为内联元素。如下代码就是将块状元素div转换为内联元素，从而使 div 元素具有内联元素特点。

```
 div{
     display:inline;
 }

......

<div>我要变成内联元素</div>
```
- 内联元素特点：
- 和其他元素都在一行上；
- 元素的高度、宽度及顶部和底部边距不可设置；
- 元素的宽度就是它包含的文字或图片的宽度，不可改变。

---
#### 元素分类--内联块状元素
- 内联块状元素（inline-block）就是同时具备内联元素、块状元素的特点，代码display:inline-block就是将元素设置为内联块状元素。(css2.1新增)，`<img>、<input>`标签就是这种内联块状标签。
- inline-block 元素特点：
- 和其他元素都在一行上；
- 元素的高度、宽度、行高以及顶和底边距都可设置。

---

#### 盒模型--边框（一）
- 盒子模型的边框就是围绕着内容及补白的线，这条线你可以设置它的`粗细`、`样式`和`颜色`(边框三个属性)。
- 如下面代码为 div 来设置边框粗细为 2px、样式为实心的、颜色为红色的边框：

```
div{
    border:2px  solid  red;
}
```
- 上面是 border 代码的缩写形式，可以分开写：

```
div{
    border-width:2px;
    border-style:solid;
    border-color:red;
}
```
- 注意：
- border-style（边框样式）常见样式有：

>dashed（虚线）| dotted（点线）| solid（实线）。

- border-color（边框颜色）中的颜色可设置为十六进制颜色

>如: border-color:#888;//前面的井号不要忘掉。

- border-width（边框宽度）中的宽度也可以设置为：

>thin | medium | thick（但不是很常用），最常还是用象素（px）。

---
#### 盒模型--边框（二）
- 现在有一个问题，如果有想为 p 标签单独设置下边框，而其它三边都不设置边框样式怎么办呢？css 样式中允许只为一个方向的边框设置样式：

div{border-bottom:1px solid red;}
同样可以使用下面代码实现其它三边(上、右、左)边框的设置：

border-top:1px solid red;
border-right:1px solid red; 
border-left:1px solid red;

---

#### 盒模型--宽度和高度
- 盒模型宽度和高度和我们平常所说的物体的宽度和高度理解是不一样的，css内定义的宽（width）和高（height），指的是填充以里的内容范围。
- 因此一个元素实际宽度（盒子的宽度）=左边界+左边框+左填充+内容宽度+右填充+右边框+右边界。
- 边界margin;边框border;填充podding;

<div align="center">![](http://image.yaopig.com/blog/539fbb3a0001304305570259.jpg)</div>

---

#### 盒模型--填充
- 元素内容与边框之间是可以设置距离的，称之为“填充”。填充也可分为上、右、下、左(顺时针)。如下代码：

```
div{padding:20px 10px 15px 30px;}
```
- 顺序一定不要搞混。可以分开写上面代码：

```
div{
   padding-top:20px;
   padding-right:10px;
   padding-bottom:15px;
   padding-left:30px;
}
```
- 如果上、右、下、左的填充都为10px;可以这么写

```
div{padding:10px;}
```
- 如果上下填充一样为10px，左右一样为20px，可以这么写：

```
div{padding:10px 20px;}
```

---

#### 盒模型--边界
- 元素与其它元素之间的距离可以使用边界（margin）来设置。边界也是可分为上、右、下、左。如下代码：

```
div{margin:20px 10px 15px 30px;}
```
- 也可以分开写：

```
div{
   margin-top:20px;
   margin-right:10px;
   margin-bottom:15px;
   margin-left:30px;
}
```
- 如果上右下左的边界都为10px;可以这么写：

```
div{ margin:10px;}
```
- 如果上下边界一样为10px，左右一样为20px，可以这么写：

```
div{ margin:10px 20px;}
```
- padding和margin的区别，padding在边框里，margin在边框外。

---

### CSS布局模型

- 清楚了CSS 盒模型的基本概念、 盒模型类型
- 我们就可以深入探讨网页布局的基本模型了。布局模型与盒模型一样都是 CSS 最基本、最核心的概念。 但布局模型是建立在盒模型基础之上，又不同于我们常说的CSS布局样式或CSS布局模板。如果说布局模型是本，那么 CSS 布局模板就是末了，是外在的表现形式。 
- CSS包含3种基本的布局模型，用英文概括为：Flow、Layer 和 Float。

>在网页中，元素有三种布局模型：

- 流动模型（Flow）
- 浮动模型 (Float)
- 层模型（Layer）

---

#### 流动模型（一）
- 先来说一说流动模型，流动（Flow）是默认的网页布局模式。也就是说网页在默认状态下的 HTML 网页元素都是根据流动模型来分布网页内容的。
- 流动布局模型具有2个比较典型的特征：
- 第一点，块状元素都会在所处的包含元素内自上而下按顺序垂直延伸分布，因为在默认状态下，块状元素的宽度都为100%。实际上，块状元素都会以行的形式占据位置

---

#### 流动模型（二）
- 第二点，在流动模型下，内联元素都会在所处的包含元素内从左到右水平分布显示。（内联元素可不像块状元素这么霸道独占一行

---

#### 浮动模型
- 块状元素这么霸道都是独占一行，如果现在我们想让两个块状元素并排显示，怎么办呢？不要着急，设置元素浮动就可以实现这一愿望。
- 任何元素在默认情况下是不能浮动的，但可以用 CSS 定义为浮动，如 div、p、table、img 等元素都可以被定义为浮动。如下代码可以实现两个 div 元素一行显示。

```
div{
    width:200px;
    height:200px;
    border:2px red solid;
    float:left;
}
<div id="div1"></div>
<div id="div2"></div>
```
# 层布局模型
- 什么是层布局模型？层布局模型就像是图像软件PhotoShop中非常流行的图层编辑功能一样，每个图层能够精确定位操作，但在网页设计领域，由于网页大小的活动性，层布局没能受到热捧。但是在网页上局部使用层布局还是有其方便之处的。下面我们来学习一下html中的层布局。
- 如何让html元素在网页中精确定位，就像图像软件PhotoShop中的图层一样可以对每个图层能够精确定位操作。CSS定义了一组定位（positioning）属性来支持层布局模型。
- 层模型有三种形式：
- 绝对定位(position: absolute)
- 相对定位(position: relative)
- 固定定位(position: fixed)

---







## Review
- hx 文章的标题 h1-h6
- p 段落
- em 斜体
- strong 粗体
- `<em>和<strong>`标签是为了强调一段话中的关键字时使用，它们的语义是强调。
- `<span>`标签是没有语义的，它的作用就是为了设置单独的样式用的。
- `<q>引用文本</q>`自带双引号。
- `<blockquote>引用文本</blockquote>`长文本引用
- `<br />`换行标签
- 空格`&nbsp;`
- `<hr/>`水平横线
- `<address>标签`，为网页加入地址信息，默认为斜线显示。
- `<code>标签`加入一行代码
- `<pre> 标签`的主要作用:预格式化的文本。被包围在 pre 元素中的文本通常会保留空格和换行符。大段代码可用。
- `ul-li无序标签`
- `ol-li有序标签`
- 在网页制作过程过中，可以把一些独立的逻辑部分划分出来，放在一个`<div>`标签中，这个`<div>`标签的作用就相当于一个容器。
- table、tbody、tr、th、td tr表格的一行、th表头、td表格单元

```
<style type="text/css">
table tr td,th{border:1px solid #000;}
</style>
```
- `<table summary="表格简介文本">`
- `caption`表格上方，表格标题
- a标签：`<a  href="目标网址"  title="鼠标滑过显示的文本">链接显示的文本</a>`
- `<img src="图片地址" alt="下载失败时的替换文本" title = "提示文本">`
- form 语法：

```
<form   method="传送方式"   action="服务器文件">

<form    method="post"   action="save.php">
        <label for="username">用户名:</label>
        <input type="text" name="username" />
        <label for="pass">密码:</label>
        <input type="password" name="pass" />
</form>
```
- 文本输入框、密码输入框

```
<form>
   <input type="text/password" name="名称" value="文本" />
</form>

1、type：
   当type="text"时，输入框为文本输入框;
   当type="password"时, 输入框为密码输入框。
2、name：为文本框命名，以备后台程序ASP 、PHP使用。
3、value：为文本输入框设置默认值。(一般起到提示作用)
```
- 文本域，多行文本输入 `<textarea  rows="行数" cols="列数">文本</textarea>`
- 单选框、复选框：

```
<input   type="radio/checkbox"   value="值"    name="名称"   checked="checked"/>
1、type:
   当 type="radio" 时，控件为单选框
   当 type="checkbox" 时，控件为复选框
2、value：提交数据到服务器的值（后台程序PHP使用）
3、name：为控件命名，以备后台程序 ASP、PHP 使用
4、checked：当设置 checked="checked" 时，该选项被默认选中
```

![](http://image.yaopig.com/blog/52e604590001ae4005270185.jpg)
- 下拉列表也可以进行多选操作，在`<select>`标签中设置multiple="multiple"属性，就可以实现多选功能，在 windows 操作系统下，进行多选时按下Ctrl键同时进行单击（在 Mac下使用 Command +单击），可以选择多个选项。
- 提交按钮`<input   type="submit"   value="提交">`
- 重置按钮`<input type="reset" value="重置">`
- lable标签：

```
label标签不会向用户呈现任何特殊效果，它的作用是为鼠标用户改进了可用性。如果你在 label 标签内点击文本，就会触发此控件。就是说，当用户单击选中该label标签时，浏览器就会自动将焦点转到和标签相关的表单控件上（就自动选中和该label标签相关连的表单控件上）。
语法：
<label for="控件id名称">
注意：标签的 for 属性中的值应当与相关控件的 id 属性值一定要相同。
```
```
css 样式由选择符和声明组成，而声明又由属性和值组成，如下图所示：
选择符：又称选择器，指明网页中要应用样式规则的元素，如本例中是网页中所有的段（p）的文字将变成蓝色，而其他的元素（如ol）不会受到影响。
声明：在英文大括号“｛｝”中的的就是声明，属性和值之间用英文冒号“：”分隔。当有多条声明时，中间可以英文分号“;”分隔，如下所示：
p{font-size:12px;color:red;}
```
- 类选择器：

```
语法：
.类选器名称{css样式代码;}
注意：
1、英文圆点开头
2、其中类选器名称可以任意起名（但不要起中文噢）
使用方法：
第一步：使用合适的标签把要修饰的内容标记起来，如下：
<span>胆小如鼠</span>
第二步：使用class="类选择器名称"为标签设置一个类，如下：
<span class="stress">胆小如鼠</span>
第三步：设置类选器css样式，如下：
.stress{color:red;}/*类前面要加入一个英文圆点*/
```
- ID选择器：

```
在很多方面，ID选择器都类似于类选择符，但也有一些重要的区别：
1、为标签设置id="ID名称"，而不是class="类名称"。
2、ID选择符的前面是井号（#）号，而不是英文圆点（.）。
```

- ID选择器和类选择器的区别：

```
ID选择器只能在文档中使用一次。
可以使用类选择器词列表方法为一个元素同时设置多个样式。
```

- 子选择器

```
还有一个比较有用的选择器子选择器，即大于符号(>),用于选择指定标签元素的第一代子元素。如代码编辑器中的代码：
.food>li{border:1px solid red;}
这行代码会使class名为food下的子元素li（水果、蔬菜）加入红色实线边框。
```

- 包含选择器

```
包含选择器，即加入空格,用于选择指定标签元素下的后辈元素。如右侧代码编辑器中的代码：
.first  span{color:red;}
这行代码会使第一段文字内容中的“胆小如鼠”字体颜色变为红色。
请注意这个选择器与子选择器的区别，子选择器（child selector）仅是指它的直接后代，或者你可以理解为作用于子元素的第一代后代。而后代选择器是作用于所有子后代元素。后代选择器通过空格来进行选择，而子选择器是通过“>”进行选择。
总结：>作用于元素的第一代后代，空格作用于元素的所有后代。
```

- 通用选择器

```
通用选择器是功能最强大的选择器，它使用一个（*）号指定，它的作用是匹配html中所有标签元素
```

- 伪类选择器

```
a:hover{color:red}
```

- 分组选择器

```
当你想为html中多个标签元素设置同一个样式时，可以使用分组选择符（，
```

- 权值

```
标签的权值为1，类选择符的权值为10，ID选择符的权值最高为100。例如下面的代码：
p{color:red;} /*权值为1*/
p span{color:green;} /*权值为1+1=2*/
.warning{color:white;} /*权值为10*/
p span.warning{color:purple;} /*权值为1+1+10=12*/
#footer .note p{color:yellow;} /*权值为100+10+1=111*/
```

- 重要性：important
- 文字排版：

```
p{font-weight:bold;} /*粗体*/
p{font-style:italic;} /*斜体*/
p a{text-decoration:underline;} /*下划线*/
.oldPrice{text-decoration:line-through;} /*删除线*/
p{text-indent:2em;} /*段落缩进*/
p{line-height:1.5em;} /*行高*/
```

- 段落排版

```
h1{
    letter-spacing:50px;   
    word-spacing:50px;
    text-align:center; /*居中对齐*/
}
```

- 元素分类

```
在讲解CSS布局之前，我们需要提前知道一些知识，在CSS中，html中的标签元素大体被分为三种不同的类型：块状元素、内联元素(又叫行内元素)和内联块状元素。

常用的块状元素有：

<div>、<p>、<h1>...<h6>、<ol>、<ul>、<dl>、<table>、<address>、<blockquote> 、<form>

常用的内联元素有：

<a>、<span>、<br>、<i>、<em>、<strong>、<label>、<q>、<var>、<cite>、<code>

常用的内联块状元素有：

<img>、<input>
```

- 块级元素

```
块级元素特点：
1、每个块级元素都从新的一行开始，并且其后的元素也另起一行。（真霸道，一个块级元素独占一行）
2、元素的高度、宽度、行高以及顶和底边距都可设置。
3、元素宽度在不设置的情况下，是它本身父容器的100%（和父元素的宽度一致），除非设定一个宽度。
设置a{display:block;}
```

- 内联元素

```
内联元素特点：
1、和其他元素都在一行上；
2、元素的高度、宽度及顶部和底部边距不可设置；
3、元素的宽度就是它包含的文字或图片的宽度，不可改变。
div{display:inline;}
```

- 内联块状元素

```
inline-block 元素特点：
1、和其他元素都在一行上；
2、元素的高度、宽度、行高以及顶和底边距都可设置。
.food{display:inline-block;}
```

- 边框

```
1、border-style（边框样式）常见样式有：

dashed（虚线）| dotted（点线）| solid（实线）。


2、border-color（边框颜色）中的颜色可设置为十六进制颜色，如:

border-color:#888;//前面的井号不要忘掉。

3、border-width（边框宽度）中的宽度也可以设置为：

thin | medium | thick（但不是很常用），最常还是用象素（px）。
```

- 布局模型

```
清楚了CSS 盒模型的基本概念、盒模型类型， 我们就可以深入探讨网页布局的基本模型了。布局模型与盒模型一样都是 CSS 最基本、 最核心的概念。 但布局模型是建立在盒模型基础之上，又不同于我们常说的 CSS 布局样式或 CSS 布局模板。如果说布局模型是本，那么 CSS 布局模板就是末了，是外在的表现形式。 
CSS包含3种基本的布局模型，用英文概括为：Flow、Layer 和 Float。
在网页中，元素有三种布局模型：
1、流动模型（Flow）
2、浮动模型 (Float)
3、层模型（Layer）
```

- 流动布局模型：

```
第一点，块状元素都会在所处的包含元素内自上而下按顺序垂直延伸分布，因为在默认状态下，块状元素的宽度都为100%。实际上，块状元素都会以行的形式占据位置。如右侧代码编辑器中三个块状元素标签(div，h1，p)宽度显示为100%。
第二点，在流动模型下，内联元素都会在所处的包含元素内从左到右水平分布显示。（内联元素可不像块状元素这么霸道独占一行）
a、span、em、strong都是内联元素。
```

- 浮动模型

```
div{
  border:2px red solid;
    width:200px;
    height:400px;
  float:left;
}
```

- 层布局模型

```
如何让html元素在网页中精确定位，就像图像软件PhotoShop中的图层一样可以对每个图层能够精确定位操作。CSS定义了一组定位（positioning）属性来支持层布局模型。
层模型有三种形式：
1、绝对定位(position: absolute)
2、相对定位(position: relative)
3、固定定位(position: fixed)
```

- absolute

```
如果想为元素设置层模型中的绝对定位，需要设置position:absolute(表示绝对定位)，这条语句的作用将元素从文档流中拖出来，然后使用left、right、top、bottom属性相对于其最接近的一个具有定位属性的父包含块进行绝对定位。如果不存在这样的包含块，则相对于body元素，即相对于浏览器窗口
```
