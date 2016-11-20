# -*- coding: utf-8 -*-

# Scrapy settings for phone project
#
# For simplicity, this file contains only the most important settings by
# default. All the other settings are documented here:
#
#     http://doc.scrapy.org/en/latest/topics/settings.html
#

BOT_NAME = 'phone'

SPIDER_MODULES = ['phone.spiders']
NEWSPIDER_MODULE = 'phone.spiders'
ITEM_PIPELINES={
    'phone.pipelines.PhonePipeline'
}
LOG_LEVEL='DEBUG'

DOWNLOAD_DELAY = 2
RANDOMIZE_DOWNLOAD_DELAY = True
USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.54 Safari/536.5'
COOKIES_ENABLED = True
MySQL_SERVER = 'localhost'
MySQL_PORT = 3306

# Crawl responsibly by identifying yourself (and your website) on the user-agent
#USER_AGENT = 'phone (+http://www.yourdomain.com)'
