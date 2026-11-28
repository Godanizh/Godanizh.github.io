---
title: "2026 盘古石杯初赛 · 手机取证"
published: 2026-11-26
description: "2026 盘古石杯初赛手机取证部分复盘：14 道题的解题思路、关键取证路径与截图。"
tags: ["电子取证", "手机取证", "盘古石杯", "火眼"]
category: "电子取证"
draft: false
lang: ""
---
## 手机取证
### 0x01 分析黄志远phone.E01检材，黄志远手机总共安装了多少款短视频应用？[答案格式：1]
**答案：4**

打开火眼 app 分析

![](/images/yuque/2026-pangu-cup-preliminary/001.png)

看到下载了两个抖音和快手，所以总计是 4 个短视频应用。

### 0x02 分析黄志远phone.E01检材，黄志远手机安装的龙虾应用的包名是什么？[答案格式：com.xxx.ui]
**答案：gptos.intelligence.assistant**

app 列表里有龙虾的信息

![](/images/yuque/2026-pangu-cup-preliminary/002.png)

可以在旁边看到包名

### 0x03 接上题，首次打开应用的时间是？[答案格式：2021-01-11-01:11:44]
**答案：2026-04-17-11:53:18**

首次打开应用，需要在 data 文件夹里找到信息，先搜索包名进行寻找

![](/images/yuque/2026-pangu-cup-preliminary/003.png)

找到之后打开 shared_prefs 这个文件夹，这个文件夹一般存储应用的基本信息数据，其中就有包括首次打开时间戳

![](/images/yuque/2026-pangu-cup-preliminary/004.png)

![](/images/yuque/2026-pangu-cup-preliminary/005.png)

opentime 旁边跟的就是首次打开的时间戳，换算一下，时间就是 2026-04-17-11:53:18

### 0x04 分析黄志远phone.E01检材，黄志远使用此应用攻击过多少台主机？[答案格式：1]
**答案：0**

对这个文件夹里的文件进行分析，发现好像并没有找到攻击的痕迹，因此是 0

![](/images/yuque/2026-pangu-cup-preliminary/006.png)

### 0x05 分析黄志远phone.E01检材，黄志远使用哪款应用控制了其PC的agent工具[答案格式：wechat]
**答案：discord**

看到黄的手机里有 discord，上网搜索一下，确实有接入 agent 的功能。排除了其他应用，那就是这个应用了

![](/images/yuque/2026-pangu-cup-preliminary/007.png)

### 0x06 分析黄志远phone.E01检材，黄志远使用这款应用的版本是多少？[答案格式：111.1]
**答案：311.2**

打开 app 分析，看到 discord 的版本信息  _#这里要省略掉后面的 0_

![](/images/yuque/2026-pangu-cup-preliminary/008.png)

### 0x07 分析黄志远phone.E01检材，接上题，登录的用户名是什么？[答案格式：wwww1234]
**答案：test901234**

在 data 中打开 discord ，在 share_prefs 文件夹里找到相关文件，可以看到里面的用户名 username

![](/images/yuque/2026-pangu-cup-preliminary/009.png)

### 0x08 分析黄志远phone.E01检材，该应用与pc端agent的配对码是什么？[答案格式：ABC456]
**答案：3EXEQ5R8**

在同个文件夹下，打开 files 文件夹，打开其中的 kv-storage 文件夹，里面有用户的相关信息

![](/images/yuque/2026-pangu-cup-preliminary/010.png)

导出这个数据库，在 DB 工具里分析一下，搜索"code"找到了三个结果，都复制下来进行分析，发现符合题目条件的 code 信息

![](/images/yuque/2026-pangu-cup-preliminary/011.png)

### 0x09 分析黄志远phone.E01检材，该应用共对几个ip进行扫描？[答案格式：5]
**答案：1**

仍然是在这个数据库中，搜索 ip，得到了三个 ip 信息，但是实际上只扫描了一个

![](/images/yuque/2026-pangu-cup-preliminary/012.png)

### 0x10 分析黄志远phone.E01检材，该应用总共调用了几个暴力破解工具？[答案格式：1]
### 0x11 分析黄志远phone.E01检材，黄志远使用其内部通联工具进行沟通，其账号的登陆密码是多少？[答案格式：123456]
### 0x12 分析黄志远phone.E01检材，黄志远一共发送过几个文件给代号军师的嫌疑人？[答案格式：1]
**答案：2**

在 data 中打开通讯文件的 database 文件夹，看到了 social_chat.db 这个数据库，但是上密码了，需要先找到密码

![](/images/yuque/2026-pangu-cup-preliminary/013.png)

在 shared_prefs 文件夹中，可以看到相关的密码信息

![](/images/yuque/2026-pangu-cup-preliminary/014.png)

但是用这个密码打开是错的，有点坑的一点，这里就需要去别人的手机检材里看，可知标准格式的密码是：s-dbw1776839203359Goo

用这个密码打开数据库，看到传输了两个数据

![](/images/yuque/2026-pangu-cup-preliminary/015.png)

### 0x13 分析方俊朗phone.E01检材，方俊郎手机总共安装了多少款理财应用？[答案格式：1]
**答案：4**

打开 app 分析，看到了四个理财应用

![](/images/yuque/2026-pangu-cup-preliminary/016.png)

### 0x14 分析方俊朗phone.E01检材，方俊朗使用筛选优质客户的应用包名是什么？[答案格式：com.xxx.ui]
**答案：com.example.predictor**

在同个界面可以看到这个应用

![](/images/yuque/2026-pangu-cup-preliminary/017.png)
