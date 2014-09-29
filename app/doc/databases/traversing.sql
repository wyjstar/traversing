-- MySQL dump 10.13  Distrib 5.6.19, for osx10.7 (x86_64)
--
-- Host: localhost    Database: traversing_1
-- ------------------------------------------------------
-- Server version	5.6.19

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
-- Table structure for table `tb_character_activity`
--

DROP TABLE IF EXISTS `tb_character_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_activity` (
  `id` bigint(20) NOT NULL,
  `sign_in` blob,
  `online_gift` blob,
  `level_gift` blob,
  `feast` int(11) DEFAULT '0',
  `login_gift` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_equipment_chip`
--

DROP TABLE IF EXISTS `tb_character_equipment_chip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_equipment_chip` (
  `id` bigint(20) NOT NULL,
  `chips` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_equipments`
--

DROP TABLE IF EXISTS `tb_character_equipments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_equipments` (
  `id` bigint(20) NOT NULL,
  `equipments` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_friend`
--

DROP TABLE IF EXISTS `tb_character_friend`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_friend` (
  `id` bigint(20) NOT NULL,
  `friends` mediumblob,
  `blacklist` mediumblob,
  `applicants_list` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_guild`
--

DROP TABLE IF EXISTS `tb_character_guild`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_guild` (
  `id` varchar(32) NOT NULL,
  `info` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_hero`
--

DROP TABLE IF EXISTS `tb_character_hero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_hero` (
  `id` varchar(50) NOT NULL,
  `character_id` bigint(20) NOT NULL,
  `property` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_hero_chip`
--

DROP TABLE IF EXISTS `tb_character_hero_chip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_hero_chip` (
  `id` varchar(50) NOT NULL,
  `hero_chips` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_heros`
--

DROP TABLE IF EXISTS `tb_character_heros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_heros` (
  `id` varchar(50) NOT NULL DEFAULT '',
  `hero_ids` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_info`
--

DROP TABLE IF EXISTS `tb_character_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_info` (
  `id` bigint(20) NOT NULL,
  `nickname` varchar(128) DEFAULT '',
  `coin` bigint(20) NOT NULL DEFAULT '0',
  `gold` bigint(20) NOT NULL DEFAULT '0',
  `hero_soul` bigint(20) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `junior_stone` int(11) NOT NULL DEFAULT '0',
  `middle_stone` int(11) NOT NULL DEFAULT '0',
  `high_stone` int(11) NOT NULL DEFAULT '0',
  `fine_hero_last_pick_time` int(11) NOT NULL DEFAULT '0',
  `excellent_hero_last_pick_time` int(11) NOT NULL DEFAULT '0',
  `fine_equipment_last_pick_time` int(11) NOT NULL DEFAULT '0',
  `excellent_equipment_last_pick_time` int(11) NOT NULL DEFAULT '0',
  `stamina` int(11) DEFAULT NULL,
  `pvp_times` int(11) DEFAULT NULL,
  `get_stamina_times` int(11) NOT NULL DEFAULT '0',
  `last_login_time` int(11) DEFAULT NULL,
  `vip_level` int(11) NOT NULL DEFAULT '0',
  `create_time` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_item_package`
--

DROP TABLE IF EXISTS `tb_character_item_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_item_package` (
  `id` bigint(10) NOT NULL,
  `items` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_line_up`
--

DROP TABLE IF EXISTS `tb_character_line_up`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_line_up` (
  `id` bigint(20) NOT NULL,
  `line_up_slots` mediumblob,
  `sub_slots` mediumblob,
  `line_up_order` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_lord`
--

DROP TABLE IF EXISTS `tb_character_lord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_lord` (
  `id` bigint(20) NOT NULL,
  `attr_info` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_mails`
--

DROP TABLE IF EXISTS `tb_character_mails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_mails` (
  `id` varchar(50) NOT NULL DEFAULT '',
  `mail_ids` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_stages`
--

DROP TABLE IF EXISTS `tb_character_stages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_stages` (
  `id` bigint(20) NOT NULL,
  `stage_info` mediumblob,
  `award_info` mediumblob,
  `elite_stage` mediumblob,
  `act_stage` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_equipment_info`
--

DROP TABLE IF EXISTS `tb_equipment_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_equipment_info` (
  `id` varchar(32) NOT NULL,
  `character_id` bigint(20) NOT NULL,
  `equipment_info` mediumblob,
  `enhance_info` mediumblob,
  `nobbing_effect` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_guild_info`
--

DROP TABLE IF EXISTS `tb_guild_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_guild_info` (
  `id` varchar(32) NOT NULL,
  `info` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_guild_name`
--

DROP TABLE IF EXISTS `tb_guild_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_guild_name` (
  `id` int(11) NOT NULL,
  `info` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_mail_info`
--

DROP TABLE IF EXISTS `tb_mail_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_mail_info` (
  `id` varchar(50) NOT NULL,
  `character_id` bigint(20) NOT NULL,
  `property` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_nickname_mapping`
--

DROP TABLE IF EXISTS `tb_nickname_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_nickname_mapping` (
  `id` int(11) NOT NULL,
  `nickname` char(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`nickname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-09-29 15:45:13
