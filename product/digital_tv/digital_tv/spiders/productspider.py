# -*- coding: utf-8 -*-
import time
import re
from scrapy.selector import Selector
from scrapy.contrib.spiders import CrawlSpider,Rule
from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor
from digital_tv.items import Digital_tvItem


class ProductSpider(CrawlSpider):
    name="digital_tv"
    allowed_domains=["detail.zol.com.cn"]
    start_urls=["http://detail.zol.com.cn/digital_tv/1.html",            
                ]
    rules=[
        Rule(SgmlLinkExtractor(allow=(r'http://detail.zol.com.cn/digital_tv/\d+\.html'))),
        Rule(SgmlLinkExtractor(allow=(r'http://detail.zol.com.cn/digital_tv/index\d+\.shtml',
                                      )),follow=True,callback="parse_item"),      
    ]

    def parse_item(self,response):
        sel=Selector(response)
        item=Digital_tvItem()
        item['name']=sel.xpath('//div[@class="breadcrumb"]/span/text()').extract()#
        item['reprice']=sel.xpath('//div[@class="product-price"]/div/div/span/b[2]/text()').extract()#
        #item['minprice']=sel.xpath('//div[@class="hide clearfix"]/span/text()').re(r'(\d+)')#
        #item['maxprice'] = sel.xpath('//*[@id="totalPoint"]/ul/li[1]/span[2]/text()').re(r'(\d+)')#
        item['score']=sel.xpath('//div[@class="product-comment"]/div/span[2]/text()').extract()#
        item['battery']=sel.xpath('//div[@class="clearfix"]/ul[1]/li[1]/span[2]/text()').extract()
        item['screen']=sel.xpath('//div[@class="clearfix"]/ul[1]/li[2]/span[2]/text()').extract()
        item['design']=sel.xpath('//div[@class="clearfix"]/ul[1]/li[3]/span[2]/text()').extract()
        item['fun']=sel.xpath('//div[@class="clearfix"]/ul[1]/li[4]/span[2]/text()').extract()
        item['run']=sel.xpath('//div[@class="clearfix"]/ul[1]/li[5]/span[2]/text()').extract()
        item['cp']=sel.xpath('//div[@class="clearfix"]/ul[1]/li[6]/span[2]/text()').extract()#
        item['category']=sel.xpath('//div[@class="breadcrumb"]/a[3]/text()').extract()#
        item['image'] = sel.xpath('//div[@class="bigpic"]/a/img/@src').extract()
        
        return item

