-- MySQL dump 10.13  Distrib 5.6.21, for osx10.8 (x86_64)
--
-- Host: localhost    Database: traversing_1
-- ------------------------------------------------------
-- Server version	5.6.21


--
-- Table structure for table `tb_character_activity`
--

DROP TABLE IF EXISTS `tb_character_activity`;
CREATE TABLE `tb_character_activity` (
  `id` bigint(20) NOT NULL,
  `sign_in` blob,
  `online_gift` blob,
  `level_gift` blob,
  `feast` int(11) DEFAULT '0',
  `login_gift` blob,
  `world_boss` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_character_equipment_chip`
--

DROP TABLE IF EXISTS `tb_character_equipment_chip`;
CREATE TABLE `tb_character_equipment_chip` (
  `id` bigint(20) NOT NULL,
  `chips` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_character_friend`
--

DROP TABLE IF EXISTS `tb_character_friend`;
CREATE TABLE `tb_character_friend` (
  `id` bigint(20) NOT NULL,
  `friends` mediumblob,
  `blacklist` mediumblob,
  `applicants_list` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_character_guild`
--

DROP TABLE IF EXISTS `tb_character_guild`;
CREATE TABLE `tb_character_guild` (
  `id` varchar(32) NOT NULL,
  `info` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_character_hero`
--

DROP TABLE IF EXISTS `tb_character_hero`;
CREATE TABLE `tb_character_hero` (
  `id` varchar(50) NOT NULL,
  `character_id` bigint(20) NOT NULL,
  `property` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_character_hero_chip`
--

DROP TABLE IF EXISTS `tb_character_hero_chip`;
CREATE TABLE `tb_character_hero_chip` (
  `id` varchar(50) NOT NULL,
  `hero_chips` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_character_info`
--

DROP TABLE IF EXISTS `tb_character_info`;
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
  `stamina` blob NOT NULL,
  `soul_shop` blob NOT NULL,
  `pvp_times` int(11) DEFAULT NULL,
  `get_stamina_times` int(11) NOT NULL DEFAULT '0',
  `last_login_time` int(11) DEFAULT NULL,
  `vip_level` int(11) NOT NULL DEFAULT '0',
  `create_time` int(11) NOT NULL DEFAULT '0',
  `pvp_count` bigint(20) NOT NULL DEFAULT '0',
  `pvp_score` bigint(20) NOT NULL DEFAULT '0',
  `arena_shop` blob,
  PRIMARY KEY (`id`),
  KEY `nickname` (`nickname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_character_item_package`
--

DROP TABLE IF EXISTS `tb_character_item_package`;
CREATE TABLE `tb_character_item_package` (
  `id` bigint(10) NOT NULL,
  `items` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_character_line_up`
--

DROP TABLE IF EXISTS `tb_character_line_up`;
CREATE TABLE `tb_character_line_up` (
  `id` bigint(20) NOT NULL,
  `line_up_slots` mediumblob,
  `sub_slots` mediumblob,
  `line_up_order` mediumblob,
  `unpar` int(20),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_character_lord`
--

DROP TABLE IF EXISTS `tb_character_lord`;
CREATE TABLE `tb_character_lord` (
  `id` bigint(20) NOT NULL,
  `attr_info` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_character_stages`
--

DROP TABLE IF EXISTS `tb_character_stages`;
CREATE TABLE `tb_character_stages` (
  `id` bigint(20) NOT NULL,
  `stage_info` mediumblob,
  `award_info` mediumblob,
  `elite_stage` mediumblob,
  `act_stage` mediumblob,
  `sweep_times` mediumblob NOT NULL,
  `stage_up_time` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_equipment_info`
--

DROP TABLE IF EXISTS `tb_equipment_info`;
CREATE TABLE `tb_equipment_info` (
  `id` varchar(32) NOT NULL,
  `character_id` bigint(20) NOT NULL,
  `equipment_info` mediumblob,
  `enhance_info` mediumblob,
  `nobbing_effect` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_guild_info`
--

DROP TABLE IF EXISTS `tb_guild_info`;
CREATE TABLE `tb_guild_info` (
  `id` varchar(32) NOT NULL,
  `info` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_guild_name`
--

DROP TABLE IF EXISTS `tb_guild_name`;
CREATE TABLE `tb_guild_name` (
  `g_name` varchar(32) NOT NULL,
  `g_id` varchar(32) NOT NULL,
  PRIMARY KEY (`g_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_mail_info`
--

DROP TABLE IF EXISTS `tb_mail_info`;
CREATE TABLE `tb_mail_info` (
  `id` varchar(50) NOT NULL,
  `character_id` bigint(20) NOT NULL,
  `property` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_pvp_rank`
--

DROP TABLE IF EXISTS `tb_pvp_rank`;
CREATE TABLE `tb_pvp_rank` (
  `id` bigint(20) NOT NULL,
  `character_id` bigint(20) NOT NULL,
  `nickname` varchar(128) DEFAULT '',
  `level` int(11) NOT NULL DEFAULT '1',
  `ap` int(11) NOT NULL,
  `best_skill` int(11) NOT NULL,
  `units` blob NOT NULL,
  `slots` blob NOT NULL,
  `hero_ids` tinyblob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `tb_character_brew`;
CREATE TABLE `tb_character_brew` (
  `id` bigint(20) NOT NULL,
  `brew` mediumblob,
  `hero_refine` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `tb_character_lively`;
CREATE TABLE `tb_character_lively` (
  `id` bigint(20) NOT NULL,
  `lively` int(11) NOT NULL,
  `tasks` mediumblob,
  `event_map` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- Dump completed on 2014-11-06 21:29:40
