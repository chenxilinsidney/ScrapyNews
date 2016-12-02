-- MySQL dump 10.13  Distrib 5.7.13, for osx10.11 (x86_64)
--
-- Host: localhost    Database: news_data
-- ------------------------------------------------------
-- Server version	5.7.13

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `news_data`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `news_data` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `news_data`;

--
-- Table structure for table `news_category`
--

DROP TABLE IF EXISTS `news_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news_category` (
  `category_id` tinyint(2) NOT NULL AUTO_INCREMENT COMMENT '新闻内容类型id',
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次操作时间戳',
  `category` varchar(256) NOT NULL COMMENT '新闻内容类型',
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `idx_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='新闻内容类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `news_list`
--

DROP TABLE IF EXISTS `news_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news_list` (
  `news_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '新闻id',
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次操作时间戳',
  `url` varchar(1024) NOT NULL COMMENT '新闻地址',
  `redirect_url` varchar(1024) NOT NULL DEFAULT '' COMMENT '新闻重定向后地址',
  `source_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '来自新闻源id',
  `spider_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '新闻抓取时间',
  `title` varchar(1024) NOT NULL DEFAULT '' COMMENT '新闻标题',
  `time` varchar(256) NOT NULL DEFAULT '' COMMENT '新闻发布时间',
  `editor` varchar(256) NOT NULL DEFAULT '' COMMENT '新闻作者',
  `description` text NOT NULL COMMENT '新闻描述',
  `page` longtext NOT NULL COMMENT '新闻url内容',
  `property` text NOT NULL COMMENT '新闻自定义属性',
  PRIMARY KEY (`news_id`),
  UNIQUE KEY `idx_url` (`url`) USING BTREE,
  KEY `fk_source_id` (`source_id`),
  CONSTRAINT `news_list_ibfk_1` FOREIGN KEY (`source_id`) REFERENCES `news_source` (`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='新闻数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `news_source`
--

DROP TABLE IF EXISTS `news_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `news_source` (
  `source_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '新闻源id',
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次操作时间戳',
  `name_id` tinyint(20) NOT NULL COMMENT '新闻源名称id',
  `sitetype_id` tinyint(20) NOT NULL COMMENT '新闻源名称id',
  `category_id` tinyint(20) NOT NULL COMMENT '新闻内容类型id',
  `weight` tinyint(2) unsigned NOT NULL COMMENT '新闻抓取权重',
  `url` varchar(1024) NOT NULL COMMENT '新闻源地址',
  `white_url` varchar(1024) NOT NULL DEFAULT '' COMMENT '新闻源新闻URL白名单地址',
  `black_url` varchar(1024) NOT NULL DEFAULT '' COMMENT '新闻源新闻URL黑名单地址',
  `property` text NOT NULL COMMENT '新闻源自定义属性',
  PRIMARY KEY (`source_id`),
  UNIQUE KEY `idx_url` (`url`) USING BTREE,
  KEY `fk_sitetype_id` (`sitetype_id`),
  KEY `fk_category_id` (`category_id`),
  KEY `fk_name_id` (`name_id`),
  CONSTRAINT `news_source_ibfk_1` FOREIGN KEY (`sitetype_id`) REFERENCES `source_sitetype` (`sitetype_id`),
  CONSTRAINT `news_source_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `news_category` (`category_id`),
  CONSTRAINT `news_source_ibfk_3` FOREIGN KEY (`name_id`) REFERENCES `source_name` (`name_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='新闻源数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `source_name`
--

DROP TABLE IF EXISTS `source_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `source_name` (
  `name_id` tinyint(2) NOT NULL AUTO_INCREMENT COMMENT '新闻源名称id',
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次操作时间戳',
  `name` varchar(256) NOT NULL DEFAULT '' COMMENT '新闻源名称',
  PRIMARY KEY (`name_id`),
  UNIQUE KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='新闻源名称表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `source_sitetype`
--

DROP TABLE IF EXISTS `source_sitetype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `source_sitetype` (
  `sitetype_id` tinyint(2) NOT NULL AUTO_INCREMENT COMMENT '新闻源网站类型id',
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次操作时间戳',
  `sitetype` varchar(256) NOT NULL COMMENT '新闻源网站类型',
  PRIMARY KEY (`sitetype_id`),
  UNIQUE KEY `idx_sitetype` (`sitetype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='新闻源网站类型表';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-12-03  1:16:49
