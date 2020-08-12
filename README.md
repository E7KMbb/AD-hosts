# AD hosts
### 依然的爱
*替换hosts文件屏蔽广告*

## 本项目永远免费,且开源
如果你看到以任何收费形式内置本hosts的ROM/模块,请告诉我

### 介绍
> 替换hosts屏蔽广告。由于hosts工作机制有部分的广告无法通过hosts来进行屏蔽,以优酷为例,优酷的视频广告和视频内容一起放在同一个域名里如果屏蔽该域名那么视频也会无法观看。

### 安装模式区别
- systemless模式:使用Magisk目录不修改系统文件，卸载还原原文件，重启生效重启前的文件。

- system模式:使用系统目录直接修改原文件，模块刷入时备份系统hosts至/sdcard/Android/ADhosts，卸载还原备份，文件实时应用。

### 注意
本模块会在/sdcard/Android生成ADhosts文件夹，内有更新日志与，动更新脚本，系统hosts备份。
使用时请关闭其它的hosts模块，请关闭systemless hosts模块(如果有)。

### 链接
* [GitHub](https://github.com/E7KMbb/AD-hosts)

* [Gitee 镜像](https://gitee.com/e7kmbb/AD-hosts)

* [Coding 镜像](https://aisauce.coding.net/public/ad-hosts/ad-hosts/git/files)

* [订阅源直链 GitHub](https://raw.githubusercontent.com/E7KMbb/AD-hosts/master/system/etc/hosts)

* [订阅源直链 Coding](https://aisauce.coding.net/p/ad-hosts/d/ad-hosts/git/raw/master/system/etc/hosts)

* [捐赠](https://docs.qq.com/doc/DWVJKWVVDWURQZUZK?disableReturnList=1&_from=1)

### 黑名单
[无法再用hosts屏蔽广告的名单](https://github.com/E7KMbb/AD-hosts/blob/master/black.md)
