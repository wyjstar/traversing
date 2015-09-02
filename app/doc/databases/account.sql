-- MySQL dump 10.13  Distrib 5.6.19, for osx10.7 (x86_64)
--
-- Host: localhost    Database: account_0
-- ------------------------------------------------------
-- Server version	5.6.19


--
-- Table structure for table `tb_account`
--

DROP TABLE IF EXISTS `tb_account`;
CREATE TABLE `tb_account` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(64) NOT NULL,
  `last_login` int(11) NOT NULL,
  `create_time` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=10000 DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_user`
--

DROP TABLE IF EXISTS `tb_user`;
CREATE TABLE `tb_user` (
  `id` varchar(32) NOT NULL,
  `account_name` varchar(32) DEFAULT NULL,
  `account_password` varchar(32) DEFAULT NULL,
  `device_id` varchar(32) DEFAULT NULL,
  `last_login` int(11) NOT NULL,
  `create_time` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_name` (`account_name`),
  INDEX `device_id` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `tb_character_info`;
CREATE TABLE `tb_character_info` (
  `id` bigint(20) NOT NULL,
  `base_info` mediumblob,
  `mails` mediumblob,
  `heroes` mediumblob,
  `equipments` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Dump completed on 2014-09-29 15:45:49
