# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

from scrapy.item import Item, Field


class PhoneItem(Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    name=Field(serializer=str)#产品名称1
    reprice=Field(serializer=str)#产品参考价格2
    #minprice=Field(serializer=str)#产品最低3
    #maxprice=Field(serializer=str)#产品最高价4
    #sprice=Field(serializer=str)#二手价5
    score=Field(serializer=str)#评分6
    battery=Field(serializer=str)#屏幕效果7
    screen=Field(serializer=str)#电池续航8
    design=Field(serializer=str)#拍照效果9/运行速度
    fun=Field(serializer=str)#娱乐10
    run=Field(serializer=str)#外观设计效果11
    cp=Field(serializer=str)#性价比12
    category=Field(serializer=str)#产品类别
    image = Field(serializer=str)#抓取图片的地址
    pass
