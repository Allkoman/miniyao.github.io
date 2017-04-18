---
title: python学习笔记
date: 2017-02-14 00:48:58
tags:
- Python
categories:
- 自主学习
- 随笔
permalink: Swork
toc: 1

---
**原因**：2017年2月4日 星期六 随笔记录。
**说明**：本文主要记录学习python的过程，需求不大，轻度使用，所以进行简单的认识性学习。
**状态**：Updating to 2.14

<!-- more -->

## 准备
### 认识python

- 通过[廖雪峰老师](http://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000)的python教程进行学习，python个人理解，适用于编写应用程序，首选是网络应用，包括网站、后台服务等等；其次是许多日常需要的小工具，包括系统管理员需要的脚本任务等等；编写方便，语言简单易懂高效。缺点是语言属于解释性语言，会比常规编译型语言跑起来慢（毕竟要一点一点解释给CPU）。

---

### 安装python

- mac下安装python3，通过homebrew进行安装，即：`brew install python3`
- 为以后方便使用，在~/.zshrc 内添加`alias py='python3`
- 使用python3指令只需输入`py`即可。

---

## 第一个程序
### 语言概述
- python是解释型语言。需要解释器进行解释，与java等编译型语言对比，语法简单易懂高效，编写方便。缺点就是需要解释器会造成运行时的时间开销。常见的解释器有CPython等。

---

### 输入与输出
- 输出可以直接CLI输入py ，进入python3命令行，输入函数print('')，单引号内为要输出的内容，同时连续输出时，遇到逗号会自动解析为空格。
- 输入为input()函数。譬如>>> name = input() ，这时就会换行输入，你输入的结果就会存入name中。

---

### helloworld
- 使用任意编辑器，vi or sublime 
- vi helloworld.py

```python
#!/usr/bin/env python3
print('hello, world')
```
- py helloworld.py

---

## Python基础
### 注释及缩紧
- Python是一种计算机编程语言。计算机编程语言和我们日常使用的自然语言有所不同，最大的区别就是，自然语言在不同的语境下有不同的理解，而计算机要根据编程语言执行任务，就必须保证编程语言写出的程序决不能有歧义，所以，任何一种编程语言都有自己的一套语法，编译器或者解释器就是负责把符合语法的程序代码转换成CPU能够执行的机器码，然后执行。Python也不例外。
- Python的语法比较简单，采用缩进方式，写出来的代码就像下面的样子：

```python
# print absolute value of an integer:
a = 100
if a >= 0:
    print(a)
else:
    print(-a)
```
- 以`#`开头的是注释，以`：`结尾 
- Python使用缩进来组织代码块，请务必遵守约定俗成的习惯，坚持使用4个空格的缩进。在文本编辑器中，需要设置把Tab自动转换为4个空格，确保不混用Tab和空格。

---

### 数据类型和变量
python中可以处理的数据类型有以下几种：
- 整数：包含负整数
- 浮点数：即小数
- 字符串：单引号或双引号扩起来的文本称为字符串，单双引号可用转义字符`\`辨别，`\n`换行`\t`制表符。`r''`表示`''`内的字符串不转义。注意在输入多行内容时，提示符由>>>变为...，提示你可以接着上一行输入。如果写成程序，就是：

```python
print('''line1
line2
line3''')
```
- 布尔值：布尔值即布尔代数，python中只有True与False两种值，区分大小写。
- 空值：None， 不同于0 。0 是一个表示空的数
- 变量：变量在程序中就是用一个变量名表示了，变量名必须是大小写`英文`、`数字`和`_`的组合，且不能用数字开头。这种变量本身类型不固定的语言称之为动态语言，与之对应的是静态语言。静态语言在定义变量时必须指定变量类型，如果赋值的时候类型不匹配，就会报错。例如Java是静态语言。
- 常量：不能变的变量，譬如圆周率`π`。python中常用大写变量PI表示，但事实也是一个变量，python没有机制保障PI不会被改变。
- python的除法，首先是`/`，计算机结果为浮点数。还有一个地板除`//`，地板除只保留整数部分。取余为`%`。

---

### 字符串和编码
#### `编码`

- 由于计算机是美国人发明的，因此，最早只有127个字母被编码到计算机里，也就是大小写英文字母、数字和一些符号，这个编码表被称为ASCII编码，比如大写字母A的编码是65，小写字母z的编码是122。
- 但是要处理中文显然一个字节是不够的，至少需要两个字节，而且还不能和ASCII编码冲突，所以，中国制定了GB2312编码，用来把中文编进去。
- 你可以想得到的是，全世界有上百种语言，日本把日文编到Shift_JIS里，韩国把韩文编到Euc-kr里，各国有各国的标准，就会不可避免地出现冲突，结果就是，在多语言混合的文本中，显示出来会有乱码。
- 因此，Unicode应运而生。Unicode把所有语言都统一到一套编码里，这样就不会再有乱码问题了。
- Unicode解决了编码乱码问题但是存储空间翻倍，故而有了可变长编码`UTF-8`。UTF-8编码把一个Unicode字符根据不同的数字大小编码成1-6个字节，常用的英文字母被编码成1个字节，汉字通常是3个字节，只有很生僻的字符才会被编码成4-6个字节。如果你要传输的文本包含大量英文字符，用UTF-8编码就能节省空间：

| 字符 |  ASCII   |      Unicode      |           UTF-8            |
|------|----------|-------------------|----------------------------|
| A    | 01000001 | 00000000 01000001 | 01000001                   |
| 中   | x        | 01001110 00101101 | 11100100 10111000 10101101 |

- 在计算机内存中，统一使用Unicode编码，当需要保存到硬盘或者需要传输的时候，就转换为UTF-8编码。用记事本编辑的时候，从文件读取的UTF-8字符被转换为Unicode字符到内存里，编辑完成后，保存的时候再把Unicode转换为UTF-8保存到文件

---

#### `字符串`
- 在最新的Python 3版本中，字符串是以Unicode编码的，也就是说，Python的字符串支持多语言。对于单个字符的编码，Python提供了`ord()`函数获取字符的整数表示，`chr()`函数把编码转换为对应的字符。
- 由于Python的字符串类型是str，在内存中以Unicode表示，一个字符对应若干个字节。如果要在网络上传输，或者保存到磁盘上，就需要把str变为以字节为单位的bytes。Python对bytes类型的数据用带`b`前缀的单引号或双引号。
- 如果我们从网络或磁盘上读取了字节流，那么读到的数据就是bytes。要把bytes变为str，就需要用`decode()`方法(编码`encode`)：

```python
>>> b'ABC'.decode('ascii')
'ABC'
>>> b'\xe4\xb8\xad\xe6\x96\x87'.decode('utf-8')
'中文'
```
- 要计算str包含多少个字符，可以用len()函数：

```python
>>> len('ABC')
3
>>> len('中文')
2
```
- 由于Python源代码也是一个文本文件，所以，当你的源代码中包含中文的时候，在保存源代码时，就需要务必指定保存为UTF-8编码。当Python解释器读取源代码时，为了让它按UTF-8编码读取，我们通常在文件开头写上这两行：

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
```
- 第一行注释是为了告诉Linux/OS X系统，这是一个Python可执行程序，Windows系统会忽略这个注释；第二行注释是为了告诉Python解释器，按照UTF-8编码读取源代码，否则，你在源代码中写的中文输出可能会有乱码。申明了UTF-8编码并不意味着你的.py文件就是UTF-8编码的，必须并且要确保文本编辑器正在使用UTF-8 without BOM编码。

---

#### `格式化`
- 最后一个常见的问题是如何输出格式化的字符串。我们经常会输出类似'亲爱的xxx你好！你xx月的话费是xx，余额是xx'之类的字符串，而xxx的内容都是根据变量变化的，所以，需要一种简便的格式化字符串的方式。
- 在Python中，采用的格式化方式和C语言是一致的，用`%`实现，举例如下：

```python
>>> 'Hello, %s' % 'world'
'Hello, world'
>>> 'Hi, %s, you have $%d.' % ('Michael', 1000000)
'Hi, Michael, you have $1000000.'
```
- %运算符就是用来格式化字符串的。在字符串内部，%s表示用字符串替换，%d表示用整数替换，有几个%?占位符，后面就跟几个变量或者值，顺序要对应好。如果只有一个%?，括号可以省略。

---

### 使用list与tuple
#### `list`
- 方括号定义
- Python内置的一种数据类型：list。list是一种有序的集合，可以随时添加和删除其中的元素。
- 列出数据可用list，类似数组有序，引索从0开始，倒叙从-1开始。
- 可用函数len()获得元素的个数
- 可用函数.append往list中追加元素到末尾
- 可用函数insert插入特定位置
- 可用函数pop删除指定位置元素
- 可以直接赋值替换特定位置元素

---

#### `tuple`
- 括号定义
- 与list 类似但是定义后指向无法改变。
- 无append()，insert()等函数
- 为区别与(1)区别，当只有一个元素并且会有歧义时，后面加一个逗号，即(1,)

---

### 条件判断
#### `条件判断`
- python使用if语句实现配合`elif`，`else`实现，从上向下以此判断，当有合适的条件，就会跳出，不继续向下判断。

---

#### 再议input
- input()返回的数据类型是str，str不能直接和整数比较，必须先把str转换成整数。Python提供了int()函数来完成这件事情`a = int(b)` 将字符串b转为数值。

---

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
a = float(input('身高 : '))
b = float(input('体重 : '))
bmi = b/a/a
if bmi < 18.5 :
    print('过轻')
elif bmi <= 25 :
    print('正常')
elif bmi <= 28 :
    print('过重')
elif bmi <= 32 :
    print('肥胖')
elif bmi > 32 :
    print('严重肥胖')   
```

---

### 循环
#### `for`
- python的第一种循环是for循环，将list或tuple中的每个元素迭代出来，用法为`for x in lsit：`，可以用range()函数生成从0开始的整数序列。

---

#### `while`
- python的第二种循环时while循环，用法为`while x :` 当不满足条件x时跳出循环。

---

#### `break`
- python的break的作用是跳出循环。

---

#### `continue`
- python的continue的作用是跳出本轮循环，进入下一轮

---

### 使用dict和set
#### `dict`
- Python内置了字典：dict的支持，dict全称dictionary，在其他语言中也称为map，使用键-值（key-value）存储，具有极快的查找速度。
- 用法：

```python
>>> d = {'Michael': 95, 'Bob': 75, 'Tracy': 85}
>>> d['Michael']
95
```

- 可以通过`d['Bob'] = 99`的方法进行赋值替换，但是key-value是一对一的关系，故会将之前的值冲掉。
- 要避免key不存在的错误，有两种办法，第一种为用`in`进行判断

```python
>>> 'miniyao' in d
False
```
- 第二种通过dict提供的get方法，可以返回结果None,或者自己指定的value。

```python
>>> d.get('miniyao')
>>> d.get('miniyao',-1)
-1 
```

- 删除一个key，可以使用pop的方式，对应的value也会删除：

```python
>>> d.pop('Michael')
95
>>> d
{'Bob': 75, 'Tracy': 85}
```

- 请务必注意，dict内部存放的顺序和key放入的顺序是没有关系的。和list比较，dict有以下几个特点：
- 查找和插入的速度极快，不会随着key的增加而变慢；
- 需要占用大量的内存，内存浪费多。
- key必须是不可变的整数或字符串，不可使用list。
- 而list相反：
- 查找和插入的时间随着元素的增加而增加；
- 占用空间小，浪费内存很少。
- 所以，dict是用空间来换取时间的一种方法。

---

#### `set`
- set与dict类似，也是一组key的集合，但不存储value。由于key不能重复，所以在set中，没有重复的key。
- 创建一个set需要使用list作为输入集合。

```python
>>> s = set([1,2,3])
>>> s
{1,2,3}
```

- set传入的参数是一个list，显示的是元素，显示的顺序不能表明set是有序的。
- 重复元素在set内自动被过滤。
- 通过add(key)的方式添加元素，重复添加某一元素无效果。
- 通过remove(key)的方式删除元素。
- set可以看作数学意思上无序和无重复的元素的集合。可以进行交集，并集等操作。
- set和dict的唯一区别仅在于没有存储对应的value，但是，set原理与dict一样。

---
#### `再议不可变对象`
- str是不可变对象，而list是可变对象。
- 对于可变对象，比如list进行操作，内容会发生变化：
```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
myList=[1,3,2,5,61,123]
 
#从小到大排序
myList.sort()
print(myList)
 
#从大到小排序
myList.sort(reverse = True)
print(myList)
```
- 而不可变对象操作内容不变。

---
## 函数
- 处理有规律的重复等问题，使用函数。

---
### 调用函数
- 对于内置函数，调用时需要知道函数`名称`和`参数`。比如求绝对值函数abs，可以直接查看文档or在交互式命令中输入`help(abs)`

---
#### `数据类型转换`
- python内置的常用函数还包括数据类型转换，譬如int()函数将其他数据类型转为整数

---
### 定义函数
- 在Python中，定义一个函数要使用def语句，依次写出函数名、括号、括号中的参数和冒号:，然后，在缩进块中编写函数体，函数的返回值用return语句返回。
- 我们以自定义一个求绝对值的my_abs函数为例：

```python
def my_abs(x):
    if x >= 0:
        return x
    else:
        return -x
```
- 请自行测试并调用my_abs看看返回结果是否正确。
- 请注意，函数体内部的语句在执行时，一旦执行到return时，函数就执行完毕，并将结果返回。因此，函数内部通过条件判断和循环可以实现非常复杂的逻辑。
- 如果没有return语句，函数执行完毕后也会返回结果，只是结果为None。
- `from test import my_abs`可用于从test.py文件导入my_abs函数。

---
#### `空函数`
- 当定义了一个函数，暂时不知道用途，可以加上pass语句，这样就可以在不影响运行的情况下占位了。

```python
def nop()
    pass
```
- 这样可以避免函数报错。

---
#### `参数检查`
- 调用函数时，如果参数个数不对，解释器会自动检查出来，并抛出`TypeError:`

---
#### `返回多个值`
- 函数可以返回多个值吗？答案是肯定的。
- 比如在游戏中经常需要从一个点移动到另一个点，给出坐标、位移和角度，就可以计算出新的新的坐标：

```python
import math
def move(x, y, step, angle=0):
    nx = x + step * math.cos(angle)
    ny = y - step * math.sin(angle)
    return nx, ny
```
- import math语句表示导入math包，并允许后续代码引用math包里的sin、cos等函数。
- 然后，我们就可以同时获得返回值：

```python
>>>x, y = move(100, 100, 60, math.pi / 6)
>>> print(x, y)
151.96152422706632 70.0
```
- 但其实这只是一种假象，Python函数返回的仍然是单一值：

```python
>>> r = move(100, 100, 60, math.pi / 6)
>>> print(r)
(151.96152422706632, 70.0)
```
- 求解二元一次方程函数

```python
#!/usr/bin/env python3
import math
def quadratic(a,b,c):
    n = b*b - 4*a*c
    if a==0:
        x = -c/b
        return x
    elif a!=0:
        if n > 0:
            x1 = (-b + math.sqrt(n))/(2*a)
            x2 = (-b - math.sqrt(n))/(2*a)
            return x1,x2
        elif n == 0:
            x = -b/(2*a)
            return x
        else:
            return '无解'
```

---
### 函数的参数
- 定义函数的时候，我们把参数的名字和位置确定下来，函数的接口定义就完成了。对于函数的调用者来说，只需要知道如何传递正确的参数，以及函数将返回什么样的值就够了，函数内部的复杂逻辑被封装起来，调用者无需了解。
- Python的函数定义非常简单，但灵活度却非常大。除了正常定义的必选参数外，还可以使用默认参数、可变参数和关键字参数，使得函数定义出来的接口，不但能处理复杂的参数，还可以简化调用者的代码。
- `默认参数`的作用是降低函数的调用难度。

```python
def power(x, n=2):
    s = 1
    while n > 0:
        n = n - 1
        s = s * x
    return s
```

- `n=2`即为默认参数。

```python
def add_end(L=[]):
    L.append('END')
    return L
```
- 反复调用会末尾加上若干个END，造成问题。
- `默认参数`（小心掉坑里）必须指向不变对象。譬如：


```python
def add_end(L=None):
    if L is None:
        L = []
    L.append('END')
    return L
```
- 假如没有默认参数`L=None` ，就会在每个list后加上END，当已有END时就会报错！

---

#### `可变参数`
- `可变参数`就是传入的参数个数是可变的。使用list or tuple传入若干个参数。
- python中可以定义可变参数，比如：

```python
def calc(numbers):
    sum = 0
    for n in numbers:
        sum = sum + n * n
    return sum
```
```python
>>> cale([1,2,3]) #输入需要为list or tuple
```

- 输入时需要组装数据为list或者tuple。而添加改动，改为可变参数后：

```python
def calc(*numbers):
    sum = 0
    for n in numbers:
        sum = sum + n * n
    return sum
```
```python
>>> calc(1,2) #输入简化了
```

- 定义可变参数和定义一个list或tuple参数相比，仅仅在参数前面加了一个*号。在函数内部，参数numbers接收到的是一个tuple，因此，函数代码完全不变。但是，调用该函数时，可以传入任意个参数，包括0个参数。
- `*nums`表示把`nums`这个list的所有元素作为可变参数传进去。这种写法相当有用，而且很常见。

---

#### `关键字参数`
- 可变参数允许你传入0个或任意个参数，这些可变参数在函数调用时自动组装为一个tuple。而关键字参数允许你传入0个或任意个含参数名的参数，这些关键字参数在函数内部自动组装为一个dict。

```python
def person(name,age,**kw):
    print('name:',name,'age:',age,'other:',kw)
```
- 传入任意参数：

```python
>>> person('Adam', 45, gender='M', job='Engineer')
name: Adam age: 45 other: {'gender': 'M', 'job': 'Engineer'}
```

- 关键字参数有什么用？它可以扩展函数的功能。比如，在person函数里，我们保证能接收到name和age这两个参数，但是，如果调用者愿意提供更多的参数，我们也能收到。试想你正在做一个用户注册的功能，除了用户名和年龄是必填项外，其他都是可选项，利用关键字参数来定义这个函数就能满足注册的需求。
- 和可变参数类似，也可以先组装出一个dict，然后，把该dict转换为关键字参数传进去：

```python
>>> extra = {'city': 'Beijing', 'job': 'Engineer'}
>>> person('Jack', 24, city=extra['city'], job=extra['job'])
name: Jack age: 24 other: {'city': 'Beijing', 'job': 'Engineer'}
```
- 当然，上面复杂的调用可以用简化的写法：

```python
>>> extra = {'city': 'Beijing', 'job': 'Engineer'}
>>> person('Jack', 24, **extra)
name: Jack age: 24 other: {'city': 'Beijing', 'job': 'Engineer'}
```
- 对于关键字参数，`**extra`表示把`extra`这个dict的所有key-value用关键字参数传入到函数的`**kw`参数，`kw`将获得一个dict，注意`kw`获得的`dict`是extra的一份拷贝，对kw的改动不会影响到函数外的extra。

---

#### `命名关键字参数`
- 对于关键字参数，函数的调用者可以传入任意不受限制的关键字参数。至于到底传入了哪些，就需要在函数内部通过`kw`检查。
- 如果要限制关键字参数的名字，就可以用命名关键字参数，例如，只接受city和job作为关键字参数：

```python
def person(name,age,*,city,job):
    print(name,age,city,job)
```
- 调用时必须传入参数名，这和位置参数不同，如果没有参数名就会报错：

```python
>>> person('Jack',24,city='Beijing',job='Engineer')
Jack 24 Beijing Engineer
```
- 如果函数定义中已经有了一个可变参数，后面跟着的命名关键字参数就不再需要一个特殊的分隔符`*`了：

```python
def person(name,age,*age,city,job):
    print(name,age,args,city,job)
```
- 命名关键字参数可以有缺醒值，从而简化调用：

```python
def person(name,age,*,city='Beijing',job):
    print(name,age,city,job)
```
- 使用命名关键字参数时，要特别注意，如果没有可变参数，就必须加一个*作为特殊分隔符。如果缺少*，Python解释器将无法识别位置参数和命名关键字参数。

---

#### `参数组合`
- 在Python中定义函数，可以用必选参数、默认参数、可变参数、关键字参数和命名关键字参数，这5种参数都可以组合使用。但是请注意，参数定义的顺序必须是：必选参数、默认参数、可变参数、命名关键字参数和关键字参数。

---

### 递归函数
- 在函数内部可以调用其他函数。如果一个函数在内部调用自身本身，这个函数就是递归函数。
- 递归函数的优点是定义简单，逻辑清晰。理论上，所有的递归函数都可以写成循环的方式，但循环的逻辑不如递归清晰。

```python
def fact(n):
    if n==1:
        return 1
    return n * fact(n - 1)
```

```python
===> fact(5) #阶乘
===> 5 * fact(4)
===> 5 * (4 * fact(3))
===> 5 * (4 * (3 * fact(2)))
===> 5 * (4 * (3 * (2 * fact(1))))
===> 5 * (4 * (3 * (2 * 1)))
===> 5 * (4 * (3 * 2))
===> 5 * (4 * 6)
===> 5 * 24
===> 120
```
- 使用递归函数需要注意防止栈溢出。在计算机中，函数调用时通过栈(stack)这种数据结构来实现的。进入函数调用，栈就会增加一个栈帧，函数返回就会减一层栈帧。由于栈的大小是无限的。所以，递归调用次数过多，回导致溢出。
- 解决栈溢出的方法是`尾递归`优化，事实上尾递归和循环的效果是一样的。
- 尾递归是指：在函数返回时，调用自身本身，并且，return语句不能包含表达式。这样编译器或者解释器可以把尾递归做优化，使递归本身无论调用多少次，都只占用一个栈帧。不会出现溢出的情况。

```python
def fact(n):
    return fact_iter(n, 1)

def fact_iter(num, product):
    if num == 1:
        return product
    return fact_iter(num - 1, num * product)
```
- 可以看到，`return fact_iter(num - 1, num * product)`仅返回递归函数本身，`num - 1`和`num * product`在函数调用前就会被计算，不影响函数调用。
- 遗憾的是，大多数编程语言没有针对尾递归做优化，Python解释器也没有做优化，所以，即使把上面的fact(n)函数改成尾递归方式，也会导致栈溢出。

---

## 高级特性
### 切片
- 取指定索引范围的操作，用循环十分繁琐，因此，Python提供了切片（`Slice`）操作符，能大大简化这种操作。
- L[0:3]表示，从索引0开始取，直到索引3为止，但不包括索引3。即索引0，1，2，正好是3个元素。如果第一个索引是0，还可以省略L[:3]，同时支持倒数切片。
- 前10个数，每两个取一个：

```python
>>> L[:10:2]
[0, 2, 4, 6, 8]
```
- 所有数，每5个取一个：

```python
>>> L[::5]
[0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95]
```
- 甚至什么都不写，只写[:]就可以原样复制一个list：

```python
>>> L[:]
[0, 1, 2, 3, ..., 99]
```
- tuple和字符串也可以进行切片操作，结果仍是tuple与字符串。

---

### 迭代
- 在python中，迭代是通过`for ... in ... :`实现的，循环的抽象程度较高，只要作用于一个可迭代的对象，for就可以正常运行，通过`collection`模块的`Iterable`类型判断对象是否可以迭代：

```python
>>> from collection import Iterable
>>> isinstance('abc',Iterable)
True
```
- 因为dict的存储不是按照list的方式顺序排列，所以，迭代出的结果顺序很可能不一样。默认情况下，dict迭代的是key。如果要迭代value，可以用`for value in d.values()`，如果要同时迭代key和value，可以用`for k, v in d.items()`。
- 最后一个小问题，如果要对list实现类似Java那样的下标循环怎么办？Python内置的`enumerate`函数可以把一个list变成索引-元素对，这样就可以在for循环中同时迭代索引和元素本身：

```python
>>> for i, value in enumerate(['A', 'B', 'C']):
...     print(i, value)
...
0 A
1 B
2 C
```
- 上面的for循环里，同时引用了两个变量，在Python里是很常见的，比如下面的代码：

```python
>>> for x, y in [(1, 1), (2, 4), (3, 9)]:
...     print(x, y)
...
1 1
2 4
3 9
```

---

### 列表生成器
- 列表生成式即`List Comprehensions`，是python内置的非常将蛋却强大的可以用来创建list的生成式。
- 生成[1x1,2x2,...,10x10]首先可以用循环的方式，但是列表生成式可以用一句话进行代替：

```python
>>>[x*x for x in range(1,11)]
[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
```
- 写的时候将`x*x`放到最前面，后面跟for循环，后面还可以跟if判断进行筛选
- 还可以使用两层循环，生成全排列：

```python
>>> [m+n for m in 'ABC' for n in 'XYZ']:
['AX', 'AY', 'AZ', 'BX', 'BY', 'BZ', 'CX', 'CY', 'CZ']
```
- 运用列表生成式，可以写出非常简洁的代码。例如，列出当前目录下的文件和目录名：

```python
>>> import os # 导入os模块
>>> [d for d in os.listdir('.')] # os.listdir可以列出文件和目录
['.emacs.d', '.ssh', '.Trash', 'Adlm', 'Applications', 'Desktop', 'Documents', 'Downloads', 'Library', 'Movies', 'Music', 'Pictures', 'Public', 'VirtualBox VMs', 'Workspace', 'XCode']
```
- 列表生成式也可以使用两个变量来生成list：

```python
>>> d = {'x': 'A', 'y': 'B', 'z': 'C' }
>>> [k + '=' + v for k, v in d.items()]
['y=B', 'x=A', 'z=C']
```
- 最后把一个list中所有的字符串变成小写：

```python
>>> L = ['Hello', 'World', 'IBM', 'Apple']
>>> [s.lower() for s in L]
['hello', 'world', 'ibm', 'apple']
```

```python
>>>> L1 = ['Hello', 'World', 18, 'Apple', None]
>>>> L2 = [ x.lower() for x in L1 if isinstance(x,str)]
>>>>    print(L2)
['hello', 'world', 'apple']
```
- 使用内建的`isinstance`判断是否为字符串，`lower()`调用数字报错。

---

### 生成器
- 由于内存有限，列表生成式生成列表的容量有限，创建过大的列表占用存储空间并且假如访问需求不大就会造成浪费。所以，如果列表元素可以按照算法推算出来，就不必创建完整的list，从而可以节省大量的空间。在python中，一边循环一边计算的机制称为生成器：`generator`。
- 要创建一个generator，有很多种方法。`第一种`方法很简单，只要把一个列表生成式的[]改成()，就创建了一个generator：

```python
>>> L = [x * x for x in range(10)]
>>> L
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
>>> G = (x * x for x in range(10))
>>> G
<generator object <genexpr> at 0x10af5c0a0>
```
- list可以直接打印出来，generator可以通过next()函数获得下一个的返回值。这种方法不直观，for循环调用更为简单。
- `Fibonacci`的函数实现：

```python
def fib(max):
    n, a, b = 0, 0, 1
    while n < max:
        print(b)
        a, b = b, a + b
        n = n + 1
    return 'done'
```
- 赋值语句`a,b = b,a+b` 相当于:

```python
t = (b,a+b) #t是一个tuple
a = t[0]
b = t[1]
```
- 仔细观察发现，fib函数定义了Fibonacci数列的推算规则，逻辑与generator十分类似。要把fib函数变为generator只需将`print(b)`改为`yield b`就可以了。

```python
def fib(max):
    n, a, b = 0, 0, 1
    while n < max:
        yield b
        a, b = b, a + b
        n = n + 1
    return 'done'
```
- 这就是定义generator的`另一种`方法。如果一个函数定义中包含yield关键字，那么这个函数就不再是一个普通函数而是一个generator
- 举个简单的例子，定义一个generator，依次返回数字1，3，5：

```python
def odd():
    print('step 1')
    yield 1
    print('step 2')
    yield(3)
    print('step 3')
    yield(5)
```
- 调用该generator时，首先要生成一个generator对象，然后用next()函数不断获得下一个返回值：

```python
>>> o = odd()
>>> next(o)
step 1
1
>>> next(o)
step 2
3
>>> next(o)
step 3
5
>>> next(o)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
StopIteration
```
- 可以看出odd不是普通函数而是generator，执行过程中遇到yield就不断中断，下次又继续执行。
- 杨辉三角代码：

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#杨辉三角
def triangles(max):
    L = [1]
    while len(L)<=max:
        yield L
        L.append(0)
        L = [L[i - 1] + L[i] for i in range(len(L))]
n = input('please input the max num : ')
for x in triangles(int(n)):
    print(x)
```

- 未完待续






