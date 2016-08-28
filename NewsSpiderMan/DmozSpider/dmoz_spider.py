import scrapy
from NewsSpiderMan.items import DmozItem


class DmozSpider(scrapy.spiders.Spider):
    name = "dmoz"
    allowed_domains = ["dmoz.org"]
    start_urls = [
        "http://www.dmoz.org/Computers/Programming/Languages/Python/Books/",
        "http://www.dmoz.org/Computers/Programming/Languages/Python/Resources/"
    ]

    def parse(self, response):
        for sel in response.xpath('//div[@class="site-item "]'):
            item = DmozItem()
            item['title'] = sel.xpath('div[@class="title-and-desc"]/a/div/text()').extract()
            item['link'] = sel.xpath('div[@class="title-and-desc"]/a/@href').extract()
            item['desc'] = sel.xpath('div[@class="title-and-desc"]/div[@class="site-descr "]/text()').extract()
            item['desc'] = list(item['desc'][0].strip())
            yield item
