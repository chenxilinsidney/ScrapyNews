#!/usr/bin/env python
# -*- coding: utf-8 -*-
import MySQLdb

if __name__ == "__main__":
    db = MySQLdb.connect(host='127.0.0.1', port=3306,
                         user='spider', passwd='spider',
                         db='news_data')
    db.close()
