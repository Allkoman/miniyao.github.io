---
title: MediaWiki
toc: 1
date: 2017-03-24 17:00:48
tags:
- 工作日常
categories:
- mediawiki
permalink:
---
**原因**：2017年3月24日 星期五 随笔记录。
**说明**：记录配置MediaWiki安装过程。

<!-- more -->

## 简介
- MediaWiki很厉害。

---

### OVA_Info
- 使用虚拟机为VirtualBox安装64位`Debian 8 LAMP`系统
- 网络类型为`桥街网络`。
- 内网可从FTP直接下载使用，下载地址为`ftp://219.217.228.164 -p22123`，账户密码请联系我获取。具体文件为`ftp/mediawiki/TURNKEY LAMP.ova`
- 使用说明及配置介绍同样在`/mediawiki`目录下
- 虚拟机登录用户密码为：root ； xygene@2017
- WebUI登录用户密码为：xygenomics ； xygene@2017
- WebUi登录URL为：`ip/mediawiki-1.28.0/`
- mysql password : xygene@2017
- 已部署mediawiki 及googletranslate、html2wiki插件。
- 虚拟机中mediawiki的位置: `/var/www/mediawiki-1.28.0/`
- 虚拟机中apache2的解析目录: `/var/www`
- 部署虚拟机后修改ip地址： `vi /var/www/mediawiki-1.28.0/LocalSettings.php `将其中的`$WgServer = "http://192.168.0.148"`修改为你的ip地址即可。

---

## 配置过程
### MediaWiki
- 下载MediaWiki: ` wget https://releases.wikimedia.org/mediawiki/1.28/mediawiki-1.28.0.tar.gz`
- 解压下载好的MediaWiki：

```
cd DownLoads
tar -xvzf mediawiki-1.28.0.tar.gz
```
- 将解压好的mediawiki-1.28.0移动到`/var/www/`,为默认apache解析路径。
- 进入解析路径，链接mediawiki-1.28.0文件夹到解析路径。随后重启apache服务。

```
cd /var/www/
ln -s /mediawiki-1.28.0 mediawiki
```
- 浏览器内输入ip/mediawiki后出现下图所示。进行设置：

![MediaWiki](http://okj8snz5g.bkt.clouddn.com/blog/mediawikilocalhost.png)
- 根据自己的需求设置后，网页会自动下载LocalSetting.php文件，将这一文件拷贝到mediawiki目录下，重新进入即可登录查看mediawiki。

---

### Html2Wiki

- 下载[Html2Wiki](https://www.mediawiki.org/wiki/Special:ExtensionDistributor/Html2Wiki)：
- 将下载后的插件解压到mediawiki源码文件夹中的extensions文件夹下，我这里路径是`/Project/mediawiki-1.28.0/extensions`。

```
tar -xzf Html2Wiki-REL1_28-a494d06.tar.gz -C /Project/mediawiki-1.28.0/extensions
```
- 在MediaWiki的配置文件`LocalSettings.php`末尾插入：

```
require_once "$IP/extensions/Html2Wiki/Html2Wiki.php";
$wgNamespacesWithSubpages[NS_MAIN] = true; # has to be defined BEFORE the require_once!
```
- Html2Wiki下局部安装php包管理器`composer.phar`，

```
cd /mediawiki-1.28.0/extensions/Html2Wiki
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer //这一步为改为全局，可选
chmod +x /usr/local/bin/composer //全局给予权限
php composer.phar install
composer install //这一步为全局安装composer.phar的操作
```

- 重启apache2，进入`ip/mediawiki-1.28.0/index.php`，点击左侧Tools的Speical pages：

![](http://okj8snz5g.bkt.clouddn.com/blog/beforehtmll.png)
![](http://okj8snz5g.bkt.clouddn.com/blog/afterhtml.png)
- 对比前后多处import HTML content功能。

---

### Google Translator
- [Google Translator](https://www.mediawiki.org/wiki/Extension:Google_Translator)内有详细的介绍。
- 这里介绍我的安装及China本地网络设置。
- 首先在`/var/www/mediawiki-1.28.0/extensions/`下新建文件夹GoogleTranslator:

```
cd /var/www/mediawiki-1.28.0/extensions
mkdir GoogleTranslator
```
- 添加参数到mediawiki默认设置`/var/www/mediawiki-1.28.0/LocalSettings.php`

```
require_once( "$IP/extensions/GoogleTranslator/GoogleTranslator.php" );
```
- 在`/var/www/mediawiki-1.28.0/extensions/GoogleTranslator`文件夹下新建文件：`GoogleTranslator.php`,`GoogleTranslator.class.php`,`GoogleTranslator.css`,`GoogleTranslator.i18n.php`。
- GoogleTranslator.php :

```
<?php
if( !defined( 'MEDIAWIKI' ) ) {
    echo( "This file is an extension to the MediaWiki software and cannot be used standalone.\n" );
    die( 1 );
}
$wgGoogleTranslatorOriginal  = $wgLanguageCode; // Original languages of the page that needs translation
$wgGoogleTranslatorLanguages  = 'fr,de';        // Languages included in the translating box
$wgExtensionCredits['other'][] = array(
    'name'           => 'Google Translator',
    'version'        => '0.2',
    'author'         => 'Joachim De Schrijver',
    'description'    => 'Adds [https://translate.google.com Google Translator] to the sidebar',
    'descriptionmsg' => 'googletranslator-desc',
    'url'            => 'https://www.mediawiki.org/wiki/Extension:Google_Translator',
);
// Register class and localisations
$dir = dirname(__FILE__) . '/';
$wgAutoloadClasses['GoogleTranslator'] = $dir . 'GoogleTranslator.class.php';
$wgExtensionMessagesFiles['GoogleTranslator'] = $dir . 'GoogleTranslator.i18n.php';
// Hook to modify the sidebar
$wgHooks['SkinBuildSidebar'][] = 'GoogleTranslator::GoogleTranslatorInSidebar';
```
- 其中`$wgGoogleTranslatorOriginal  = $wgLanguageCode;`与
`$wgGoogleTranslatorLanguages  = 'fr,de';`为语言选项，可将第二句中的`fr,de`都删掉，则默认为可翻译为任意语言，但会影响加载速度，这里我填写的是`zh-CN`;
- GoogleTranslator.class.php：
```
<?php
if (!defined('MEDIAWIKI')) die();
class GoogleTranslator {
    static function GoogleTranslatorInSidebar( $skin, &$bar ) {
        global $wgGoogleTranslatorOriginal,$wgGoogleTranslatorLanguages;

        $bar['googletranslator'] = "<div id=\"google_translate_element\"></div><script>
                    function googleTranslateElementInit() {
                      new google.translate.TranslateElement({
                        pageLanguage: '".$wgGoogleTranslatorOriginal."',
                        includedLanguages: '".$wgGoogleTranslatorLanguages."'
                      }, 'google_translate_element');
                    }
                    </script><script src=\"//translate.google.cn/translate_a/element.js?cb=googleTranslateElementInit\"></script>";
                return $bar;
        return true;
    }
}
?>
```
- GoogleTranslator.css:

```
#p-googleatranslator .pBody {
    padding-top: 5px;
    text-align:  center;
}
```
- GoogleTranslator.i18n.php：

```
<?php
/**
 * Internationalisation file for extension GoogleTranslator
 *
 * @addtogroup Extensions
 * @license LGPL
 */
$messages = array();
$messages['en'] = array(
    'googletranslator'      => 'Translate', # do not translate or duplicate this message to other languages
    'googletranslator-desc' => 'Adds [https://www.google.com/translate Google Translator] to the sidebar',
);
$messages['qqq'] = array(
    'googletranslator-desc' => 'Short description of this extension, shown on [[Special:Version]]. Do not translate or change links.',
);
$messages['de'] = array(
    'googletranslator-desc' => 'Ermöglicht das Nutzen von [https://www.google.com/translate Google Translator] in der Seitenleiste',
);
$messages['fr'] = array(
    'googletranslator-desc' => 'Ajoute [https://www.google.com/translate Google Traduction] dans la bare latérale',
);
$messages['ru'] = array(
    'googletranslator-desc' => 'Добавляет [https://www.google.com/translate Google Переводчик] в блок навигации.',
);
```
- 重启apache2，打开浏览器后查看如下图：

![](http://okj8snz5g.bkt.clouddn.com/blog/transen.png)
![](http://okj8snz5g.bkt.clouddn.com/blog/transcn.png)

---
### Semantic-mediawiki
- [Semantic-mediawiki](https://www.semantic-mediawiki.org/wiki/Semantic_MediaWiki) (SMW) is a free, open-source extension to MediaWiki – the wiki software that powers Wikipedia – that lets you store and query data within the wiki's pages.Semantic MediaWiki is also a full-fledged framework, in conjunction with many spinoff extensions, that can turn a wiki into a powerful and flexible knowledge management system. All data created within SMW can easily be published via the Semantic Web, allowing other systems to use this data seamlessly.
- [安装网址](https://www.semantic-mediawiki.org/wiki/Help:Installation/Using_Composer_with_MediaWiki_1.25%2B)，通过mediawiki-specialpage中的version版本信息与官网进行比对，进行插件版本的选择以及安装。我这里安装的mediawiki版本为1.28，插件版本为2.5
- Semantic-mediawiki的composer安装方式，由于上文Html2Wiki部分全局安装了composer，这里只需直接使用即可。在LocalSettings.php所在根目录执行：

```
composer require mediawiki/semantic-media-wiki "~2.5" --update-no-dev
```
- 这一步将插件的版本信息导入到composer.json里，随后运行

```
composer update
```
- 这时`mediawiki/extensions`下就会被composer安装出`SemanticMediaWiki`的文件夹，进入该文件夹，输入`composer update`，更新安装依赖包文件。
- 在根目录运行：

```
php maintenance/update.php //可能会提示需要composer update，
```
- 此时进入`extensions/SemanticMediaWiki/maintenance`文件夹，输入`php SMW_setup.php`用于将插件需要的数据库更新到本地数据库。
- 此时回到mediawiki根目录，修改LocalSettins.php。添加一句：`enableSemantics( 'example.org',true);`。
- 打开浏览器进入mediawiki，打开specialPage。发现如下图多出一项`Semantic Statistic`：
![](http://okj8snz5g.bkt.clouddn.com/blog/sem.png)，在这一步我遇到了打开浏览器后cache报错问题，解决办法是运行`mediawiki/maintenance/ rebuildLocalisationCache.php`。
- 如果打开页面不显示错误，仅仅是无法加载，请在LocalSettings.php后添加下述代码。
```
$wgShowExceptionDetails = true;
$wgShowDBErrorBacktrace = true; 
```
- 点开该项无报错即可（我也就遇到过数据库报错，别的报错没有遇到过，如果遇到了并无援助能力）

---
- 下面进行Semantic的额外插件安装，用于多语言link，[网址](https://github.com/SemanticMediaWiki/SemanticInterlanguageLinks/blob/master/README.md)
- 安装方式简单粗暴，在根目录的`composer.json`内的`require`中添加一句:

```
{
    "require": {
        "mediawiki/semantic-interlanguage-links": "~1.3"
    }
}
```
- 随后运行`composer update`即可。
- 使用方式如下图：
![](http://okj8snz5g.bkt.clouddn.com/blog/450195e0-4b75-11e5-9cd4-61e2672eb8fa.png)

---
