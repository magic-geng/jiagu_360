# jiagu_360
Encapsulate 360 android hardening commands through ruby and shell

### 环境：默认ruby 2.6.3版本

### 背景：面对工信部的要求，由于mac兼容问题，临时封装一下360加固以及重签名命令。也可以直接用360加固工具，这里封装的目的是，使用起来更灵活，比如切换账号、修改重签名v1-v4的方式。

## V1.0
### 1、下载360助手
https://jiagu.360.cn/#/global/download
将java、jiagu.jar、login 复制到360jiagu文件夹中

### 2、将android的签名文件复制到360jiagu文件夹中，名称改为“sign.keystore”

### 3、将要加固的apk放到oapk文件夹中
#### 注意这里apk分为3个环境 debug、emulation、release
apk的命名需要包含“-debug”或者“-emulation”或者“-release”
例如 xx-debug.apk 、xx-emulation.apk 、xx-release.apk 

### 4、运行main.rb，会在build文件中输出加固并签名之后的apk
