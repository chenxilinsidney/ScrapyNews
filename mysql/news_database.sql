DROP TABLE IF EXISTS source_name;
CREATE TABLE IF NOT EXISTS source_name(
    name_id TINYINT(2) NOT NULL AUTO_INCREMENT COMMENT '新闻源名称id',
    ts TIMESTAMP NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp COMMENT '最后一次操作时间戳',
    name VARCHAR(256) NOT NULL DEFAULT '' COMMENT '新闻源名称',
    PRIMARY KEY(name_id),
    UNIQUE KEY idx_name(name)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=UTF8 COMMENT '新闻源名称表';

DROP TABLE IF EXISTS source_sitetype;
CREATE TABLE IF NOT EXISTS source_sitetype(
    sitetype_id TINYINT(2) NOT NULL AUTO_INCREMENT COMMENT '新闻源网站类型id',
    ts TIMESTAMP NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp COMMENT '最后一次操作时间戳',
    sitetype VARCHAR(256) NOT NULL COMMENT '新闻源网站类型',
    PRIMARY KEY(sitetype_id),
    UNIQUE KEY idx_sitetype(sitetype)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=UTF8 COMMENT '新闻源网站类型表';

DROP TABLE IF EXISTS news_category;
CREATE TABLE IF NOT EXISTS news_category(
    category_id TINYINT(2) NOT NULL AUTO_INCREMENT COMMENT '新闻内容类型id',
    ts TIMESTAMP NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp COMMENT '最后一次操作时间戳',
    category VARCHAR(256) NOT NULL COMMENT '新闻内容类型',
    PRIMARY KEY(category_id),
    UNIQUE KEY idx_category(category)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=UTF8 COMMENT '新闻内容类型表';

DROP TABLE IF EXISTS news_source;
CREATE TABLE IF NOT EXISTS news_source(
    source_id BIGINT(20) NOT NULL auto_increment COMMENT '新闻源id',
    ts TIMESTAMP NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp COMMENT '最后一次操作时间戳',
    name_id TINYINT(20) NOT NULL COMMENT '新闻源名称id',
    sitetype_id TINYINT(20) NOT NULL COMMENT '新闻源名称id',
    category_id TINYINT(20) NOT NULL COMMENT '新闻内容类型id',
    weight TINYINT(2) unsigned NOT NULL COMMENT '新闻抓取权重',
    url VARCHAR(1024) NOT NULL COMMENT '新闻源地址',
    white_url VARCHAR(1024) NOT NULL DEFAULT '' COMMENT '新闻源新闻URL白名单地址',
    black_url VARCHAR(1024) NOT NULL DEFAULT '' COMMENT '新闻源新闻URL黑名单地址',
    property  TEXT NOT NULL COMMENT '新闻源自定义属性',
    PRIMARY KEY(source_id),
    FOREIGN KEY fk_sitetype_id(sitetype_id) REFERENCES source_sitetype(sitetype_id),
    FOREIGN KEY fk_category_id(category_id) REFERENCES news_category(category_id),
    FOREIGN KEY fk_name_id(name_id) REFERENCES source_name(name_id),
    UNIQUE KEY idx_url(url) using btree
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=UTF8 COMMENT '新闻源数据表';

drop table if exists news_list;
create table if not exists news_list(
    news_id BIGINT(20) NOT NULL auto_increment COMMENT '新闻id',
    ts timestamp NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp COMMENT '最后一次操作时间戳',
    url VARCHAR(1024) NOT NULL COMMENT '新闻地址',
    redirect_url VARCHAR(1024) NOT NULL DEFAULT '' COMMENT '新闻重定向后地址',
    source_id BIGINT(20) NOT NULL DEFAULT 0 COMMENT '来自新闻源id',
    spider_time timestamp NOT NULL DEFAULT current_timestamp COMMENT '新闻抓取时间',
    title VARCHAR(1024) NOT NULL DEFAULT '' COMMENT '新闻标题',
    time VARCHAR(256) NOT NULL DEFAULT '' COMMENT '新闻发布时间',
    editor VARCHAR(256) NOT NULL DEFAULT '' COMMENT '新闻作者', 
    description TEXT NOT NULL COMMENT '新闻描述',
    page LONGTEXT NOT NULL COMMENT '新闻url内容',
    property TEXT NOT NULL COMMENT '新闻自定义属性',
    PRIMARY KEY(news_id),
    FOREIGN KEY fk_source_id(source_id) REFERENCES news_source(source_id),
    UNIQUE KEY idx_url(url) using btree
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=UTF8 COMMENT '新闻数据表';
