create table news(
    ID bigint(20) not null auto_increment comment '主键ID',
    TS timestamp not null default current_timestamp on update current_timestamp comment '最后一次操作时间戳',
    url varchar(1024) not null default '' comment '新闻源地址',
    source varchar(1024) not null default '' comment '新闻源名称',
    title varchar(1024) not null default '' comment '新闻标题',
    editor varchar(256) not null default '' comment '新闻作者', 
    time varchar(256) not null default '' comment '新闻发布时间',
    content text not null comment '新闻内容',
    primary key(id),
    unique key idx_url(url) using btree
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 comment '新闻爬虫数据表';
