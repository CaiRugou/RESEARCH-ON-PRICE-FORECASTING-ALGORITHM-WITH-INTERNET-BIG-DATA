# RESEARCH ON PRICE FORECASTING ALGORITHM WITH INTERNET BIG DATA 
**系统分为四个模块：第一，数据采集处理；第二，信息可信判别以及情感倾向因素计算；第三，情感倾向因素预测模型的建立及预测；第四，基于研究算法的Android应用软件**
## 实验环境

- [x] 操作系统：Windows、Linux
- [x] 语言环境：Python、MATLAB、java
- [x] 实验工具：NLTK、sklearn、MATLAB2015b、Pycharm
- [x] 服务器：  tomcat

## 用开源框架Scrapy分析Xpath路径抓取中关村报价网站
**上述文件中product文件夹是定制好抓取电子产品价格的数据采集器，MySQL建立数据库见文件**
应用scrapy[详细教程可见](https://scrapy-chs.readthedocs.io/zh_CN/0.24/intro/tutorial.html)爬虫框架，定制爬虫抓取中关村报价产品的价格数据并且存储于MySQL数据库中

1.其中的过程是分析网页的Xpath路径，根据要获取的数据的路径定位到价格数据（可以分析不同的网站数据抓取）

2.存储数据打MySQL数据库中，主要是方便操作和使用
```bash
scrapy startproject tutorial
```

![NO1](http://o84hyclg0.bkt.clouddn.com/bs0.png)


爬虫名字可以随意设定，同时设定采集器在服务器上能够定时采集数据这里定制bat文件。
锁定域名范围为：**zol.com**
分析`URL`中正则表达式如下：
http://detail.zol.com.cn/cell_phone/index****.shtml
最后将采集到的数据存储到MySQL数据库中如下图：
![NO2](http://o84hyclg0.bkt.clouddn.com/bs1.png)

如果是在Linux服务器上做该定时任务只需要按照需要编写crontab即可。
## 爬虫定制方法以及网页分析
这里为了处理抓取新闻数据时候需要处理动态页面的信息采用了beautifulsoup，通过调用相关接口处理JS页面。
为保证数据的全面性而选取了百度新闻，同样需要分析页面源码的Xpath路径，为了剔除网页的标签，需要同上的路径分析。
最后可以通过用户提供的关键词获取新闻数据，效果如下图所示：

![NO3](http://o84hyclg0.bkt.clouddn.com/bs2.png)


获得的新闻数据如下：


![NO4](http://o84hyclg0.bkt.clouddn.com/bs3.png)

## 文本分析
- [1]  为了

## 基于情感因素预测模型

## 基于研究算法Android应用软件

