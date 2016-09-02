#!/usr/bin/env python
# -*-encoding:UTF-8-*-

from NewsSpiderMan.items import NewsItem
from scrapy.spiders import CrawlSpider, Rule
from scrapy.linkextractors import LinkExtractor


class NewsSpider(CrawlSpider):
    name = "newsspider"
    allowed_domains = ["tech.163.com"]
    start_urls = ["http://tech.163.com"]

    rules = [
        Rule(LinkExtractor(allow='tech.163.com/16/.*\.html'),
             follow=True, callback='parse_item')
    ]

    def parse_item(self, response):
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

    # def parse_start_url(self, response):
    #    log.start()
    #    log.msg(str(response.xpath('//a/@href')))
    #    return response.xpath('//a/@href')
