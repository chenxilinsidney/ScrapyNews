#!/usr/bin/env python
# -*-encoding:UTF-8-*-

from NewsSpiderMan.items import NewsItem
from scrapy.spiders import CrawlSpider, Rule
from scrapy.linkextractors import LinkExtractor
import re


class NewsSpider(CrawlSpider):
    """
    spider for tech news.
    """
    # spider name
    name = "technewsspider"

    # An optional list of strings containing domains that this spider is allowed
    # to crawl.
    allowed_domains = ["tech.163.com",
                       "tech.qq.com",
                       "tech.sina.com.cn",
                       "tech.ifeng.com",
                       "it.sohu.com"]

    # The subsequent URLs will be generated successively from data contained in
    # the start URLs.
    start_urls = ["http://tech.163.com",
                  "http://tech.qq.com",
                  "http://tech.sina.com.cn",
                  "http://tech.ifeng.com",
                  "http://it.sohu.com"]

    #  If multiple rules match the same link, the first one will be used,
    #  according to the order they’re defined in this attribute.
    rules = [
        Rule(LinkExtractor(allow='tech.163.com/\d{2}/\d{4}/\d{2}/.*\.html'),
             follow=False, callback='parse_item'),
        Rule(LinkExtractor(allow='tech.qq.com/a/\d{8}/.*\.htm'),
             follow=False, callback='parse_item'),
        Rule(LinkExtractor(
            allow='tech.sina.com.cn/.*/\d{4}-\d{2}-\d{2}/.*\.shtml'),
            follow=False, callback='parse_item'),
        Rule(LinkExtractor(allow='tech.ifeng.com/a/\d{8}/.*\.shtml'),
             follow=False, callback='parse_item'),
        Rule(LinkExtractor(allow='it.sohu.com/\d{8}/.*\.shtml'),
             follow=False, callback='parse_item'),
    ]

    def parse_item(self, response):
        """
        parse News item from response.
        """
        item = NewsItem()
        self.logger.debug("start to parse url: %s" % response.url)
        print response.url
        item['url'] = [response.url]
        if re.search(r"tech.163.com") is not None:
            return self.parse_item_163(self,  response)
        if re.search(r"tech.qq.com") is not None:
            return self.parse_item_qq(self,  response)
        if re.search(r"tech.sina.com.cn") is not None:
            return self.parse_item_sina(self,  response)
        if re.search(r"tech.ifeng.com") is not None:
            return self.parse_item_ifeng(self,  response)
        if re.search(r"it.sohu.com") is not None:
            return self.parse_item_sohu(self,  response)
        return item

    def parse_item_163(self, response):
        """
        parse 163 News item from response.
        """
        self.logger.debug("parse func: %s" % sys._getframe().f_code.co_name)
        print sys._getframe().f_code.co_name
        item = NewsItem()
        item['url'] = [response.url]
        item['source'] =\
            response.xpath('//a[@id="ne_article_source"]/text()').\
            extract()
        item['title'] =\
            response.xpath('//div[@class="post_content_main"]/h1/text()').\
            extract()
        item['editor'] =\
            response.xpath('//span[@class="ep-editor"]/text()').\
            extract()
        item['time'] =\
            response.xpath('//div[@class="post_time_source"]/text()').\
            extract()
        item['content'] =\
            response.xpath('//div[@class="post_text"]/p/text()').\
            extract()
        for key in item:
            for data in item[key]:
                self.logger.debug("item %s value %s" % (key, data))
        return item

    def parse_item_qq(self, response):
        self.logger.debug("parse func: %s" % sys._getframe().f_code.co_name)
        print sys._getframe().f_code.co_name
        return NewsItem()

    def parse_item_sina(self, response):
        self.logger.debug("parse func: %s" % sys._getframe().f_code.co_name)
        print sys._getframe().f_code.co_name
        return NewsItem()

    def parse_item_sohu(self, response):
        self.logger.debug("parse func: %s" % sys._getframe().f_code.co_name)
        print sys._getframe().f_code.co_name
        return NewsItem()

    def parse_item_ifeng(self, response):
        self.logger.debug("parse func: %s" % sys._getframe().f_code.co_name)
        print sys._getframe().f_code.co_name
        return NewsItem()

    def parse_start_url(self, response):
        """
        parse start url responses.
        It allows to parse the initial responses.
        """
        self.logger.debug("do not parse start url")
        return NewsItem()
