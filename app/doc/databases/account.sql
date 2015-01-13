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
  `uuid` varchar(32) NOT NULL,
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
  `account_name` varchar(20) DEFAULT NULL,
  `account_password` varchar(32) DEFAULT NULL,
  `last_login` int(11) NOT NULL,
  `create_time` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_name` (`account_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `tb_pvp_rank`;
CREATE TABLE `tb_pvp_rank` (
  `id` bigint(20) NOT NULL,
  `character_id` bigint(20) NOT NULL,
  `nickname` varchar(128) DEFAULT '',
  `level` int(11) NOT NULL DEFAULT '1',
  `ap` int(11) NOT NULL,
  `best_skill` int(11) NOT NULL,
  `unpar_skill` int(11) NOT NULL,
  `unpar_skill_level` int(11) NOT NULL,
  `units` blob NOT NULL,
  `slots` blob NOT NULL,
  `hero_ids` tinyblob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump completed on 2014-09-29 15:45:49
