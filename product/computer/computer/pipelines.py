# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html
from scrapy import log
from twisted.enterprise import adbapi
from scrapy.http import Request

import MySQLdb
import MySQLdb.cursors

class ComputerPipeline(object):
    def __init__(self):
        self.dbpool = adbapi.ConnectionPool('MySQLdb',
                db = 'product',
                user = 'root',
                passwd = '123456',
                cursorclass = MySQLdb.cursors.DictCursor,
                charset = 'utf8',
                use_unicode = False
        )
    
    def process_item(self, item, spider):
        query = self.dbpool.runInteraction(self._conditional_insert, item)
        query.addErrback(self.handle_error)
        return item
    def _conditional_insert(self,tx,item):
        tx.execute("select * from computer87 where m_name= %s",(item['name'][0]))
        result=tx.fetchone()
        log.msg(result,level=log.DEBUG)
        print result
        if result:
            log.msg("Item already stored in db:%s" % item,level=log.DEBUG)
        else:
            tx.execute(\
                "insert into computer77 (m_name,re_price,m_score,m_battery,m_screen,m_design,m_fun,m_run,m_cp,m_category,m_image) values (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",\
                (item['name'][0],item['reprice'][0],item['score'][0],item['battery'][0],item['screen'][0],item['design'][0],item['fun'][0],item['run'][0],item['cp'][0],item['category'][0],item['image'][0]))
            log.msg("Item stored in db: %s" % item, level=log.DEBUG)

    def handle_error(self, e):
        log.err(e)
    
