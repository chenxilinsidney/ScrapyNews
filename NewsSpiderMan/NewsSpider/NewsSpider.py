#!/usr/bin/env python
# -*-encoding:UTF-8-*-

from NewsSpiderMan.items import NewsItem
from scrapy.spiders import CrawlSpider, Rule
from scrapy import log
from scrapy.linkextractors import LinkExtractor


class NewsSpider(CrawlSpider):
    name = "news163spider"
    allowed_domains = ["tech.163.com"]
    start_urls = ["http://tech.163.com"]

    def parse_news(response):
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
                log.msg("item %s value %s" % (key, data))
        return item

    rules = [
        Rule(LinkExtractor(allow='tech.163.com/16/082[0-9]/.*\.html'),
             follow=False, callback=parse_news)
    ]

    # def parse_start_url(self, response):
    #    log.start()
    #    log.msg(str(response.xpath('//a/@href')))
    #    return response.xpath('//a/@href')
