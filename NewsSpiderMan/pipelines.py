# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html

import MySQLdb


class News2FileFor163Pipeline(object):
    """
    pipeline: process items given by spider
    """

    def __init__(self, filepath, filename):
        """
        init for the pipeline class
        """
        self.fullname = filepath + '/' + filename
        self.id = 0
        return

    def process_item(self, item, spider):
        """
        process each items from the spider.
        example: check if item is ok or raise DropItem exception.
        example: do some process before writing into database.
        example: check if item is exist and drop.
        """
        for element in ("url", "source", "title", "editor", "time", "content"):
            if item[element] is None:
                raise DropItem("invalid items url: %s" % str(item["url"]))
        self.fs.write("news id: %s" % self.id)
        self.fs.write("\n")
        self.id += 1
        self.fs.write("url: %s" % item["url"][0].strip().encode('UTF-8'))
        self.fs.write("\n")
        self.fs.write("source: %s" % item["source"][0].strip().encode('UTF-8'))
        self.fs.write("\n")
        self.fs.write("title: %s" % item["title"][0].strip().encode('UTF-8'))
        self.fs.write("\n")
        self.fs.write("editor: %s" % item["editor"][0].strip().
                      encode('UTF-8').split('：')[1])
        self.fs.write("\n")
        time_string = item["time"][0].strip().split()
        datetime = time_string[0] + ' ' + time_string[1]
        self.fs.write("time: %s" % datetime.encode('UTF-8'))
        self.fs.write("\n")
        content = ""
        for para in item["content"]:
            content += para.strip().replace('\n', '').replace('\t', '')
        self.fs.write("content: %s" % content.encode('UTF-8'))
        self.fs.write("\n")
        return item

    def open_spider(self, spider):
        """
        called when spider is opened.
        do something before pipeline is processing items.
        example: do settings or create connection to the database.
        """
        self.fs = open(self.fullname, 'w+')
        return

    def close_spider(self, spider):
        """
        called when spider is closed.
        do something after pipeline processing all items.
        example: close the database.
        """
        self.fs.flush()
        self.fs.close()
        return

    @classmethod
    def from_crawler(cls, crawler):
        """
        return an pipeline instance.
        example: initialize pipeline object by crawler's setting and components.
        """
        return cls(crawler.settings.get('ITEM_FILE_PATH'),
                   crawler.settings.get('ITEM_FILE_NAME'))


class News2MySQLPipeline(object):
    """
    save news item to mysql pipeline.
    """
    mysql_table = 'news'

    def __init__(self, ip, port, mysql_user, mysql_password, mysql_database):
        """
        set database information.
        """
        self.mysql_ip = ip
        self.mysql_port = int(port)
        self.mysql_user = mysql_user
        self.mysql_password = mysql_password
        self.mysql_database = mysql_database

    def process_item(self, item, spider):
        """
        process each items from the spider.
        example: check if item is ok or raise DropItem exception.
        example: do some process before writing into database.
        example: check if item is exist and drop.
        """
        spider.logger.debug("parsing item before write mysql")
        if item["url"] is None:
            raise DropItem("invalid items url: %s" % str(item["url"]))
        url = item["url"][0].strip().encode('UTF-8')
        try:
            source = item["source"][0].strip().encode('UTF-8')
        except:
            source = ""
        try:
            title = item["title"][0].strip().encode('UTF-8')
        except:
            title = ""
        try:
            editor = item["editor"][0].strip().encode('UTF-8')
        except:
            editor = ""
        try:
            time = item["time"][0].encode('UTF-8')
        except:
            time = ""
        try:
            content = ""
            for para in item["content"]:
                content += para.strip().replace('\n', '').replace('\t', '')
            content = content.encode('UTF-8')
        except:
            content = ""
        cursor = self.db.cursor()
        spider.logger.debug("trying to write mysql")
        sql = "INSERT INTO %s (URL, SOURCE, TITLE, EDITOR,\
            TIME, CONTENT) \
            VALUES ('%s', '%s', '%s', '%s', '%s' ,'%s')" % \
            (self.mysql_table, url, source, title, editor, time, content)
        try:
            cursor.execute(sql)
            self.db.commit()
        except:
            spider.logger.error("failed to write mysql")
            self.db.rollback()
        spider.logger.error("sucess to write mysql")
        return item

    def open_spider(self, spider):
        """
        called when spider is opened.
        do something before pipeline is processing items.
        example: do settings or create connection to the database.
        """
        try:
            spider.logger.debug("trying to connect mysql")
            self.db = MySQLdb.connect(host=self.mysql_ip, port=self.mysql_port,
                                      user=self.mysql_user,
                                      passwd=self.mysql_password,
                                      db=self.mysql_database)
        except MySQLdb.DatabaseError:
            spider.logger.error("can not connect mysql")
            raise MySQLdb.DatabaseError
        return

    def close_spider(self, spider):
        """
        called when spider is closed.
        do something after pipeline processing all items.
        example: close the database.
        """
        spider.logger.debug("close mysql")
        self.db.close()
        return

    @classmethod
    def from_crawler(cls, crawler):
        """
        return an pipeline instance.
        example: initialize pipeline object by crawler's setting and components.
        """
        return cls(crawler.settings.get('MYSQL_IP'),
                   crawler.settings.get('MYSQL_PORT'),
                   crawler.settings.get('MYSQL_NAME'),
                   crawler.settings.get('MYSQL_PASSWORD'),
                   crawler.settings.get('MYSQL_DATABASE'))
