-- MySQL dump 10.13  Distrib 5.6.21, for osx10.8 (x86_64)
--
-- Host: localhost    Database: traversing_1
-- ------------------------------------------------------
-- Server version	5.6.21

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
-- Table structure for table `tb_character_info`
--

DROP TABLE IF EXISTS `tb_character_info`;
CREATE TABLE `tb_character_info` (
  `id` bigint(20) NOT NULL,
  `nickname` varchar(128) DEFAULT '',
  `level` int(11) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `fine_hero_last_pick_time` int(11) NOT NULL DEFAULT '0',
  `excellent_hero_last_pick_time` int(11) NOT NULL DEFAULT '0',
  `fine_equipment_last_pick_time` int(11) NOT NULL DEFAULT '0',
  `excellent_equipment_last_pick_time` int(11) NOT NULL DEFAULT '0',
  `pvp_times` int(11) DEFAULT 0,
  `pvp_refresh_time` int(11) DEFAULT 0,
  `get_stamina_times` int(11) NOT NULL DEFAULT '0',
  `pvp_refresh_count` int(11) DEFAULT 0,
  `last_login_time` int(11) DEFAULT NULL,
  `vip_level` int(11) NOT NULL DEFAULT '0',
  `create_time` int(11) NOT NULL DEFAULT '0',
  `newbee_guide_id` int(11) NOT NULL DEFAULT '0',
  `finances` tinyblob,
  `stamina` blob NOT NULL,
  `brew` blob,
  `friends` blob,
  `blacklist` blob,
  `applicants_list` blob,
  `freward` blob,
  `shop` blob,
  `lord_attr_info` blob,

  `m_runt` blob,
  `stone1` int(11),
  `stone2` int(11),
  `refresh_runt` blob,
  `refresh_times` blob,

  `g_id` varchar(32),
  `position` int(11),
  `contribution` int(11),
  `all_contribution` int(11),
  `k_num` int(11),
  `worship` int(11),
  `worship_time` int(11),
  `exit_time` int(11),

  `online_gift` blob,
  `sign_in` blob,
  `level_gift` blob,
  `feast` int(11) DEFAULT '0',
  `login_gift` blob,
  `world_boss` blob,
  `equipment_chips` blob,
  `hero_chips` blob,

  `travel` blob,
  `travel_item` blob,
  `shoes` blob,
  `fight_cache` blob,
  `chest_time` bigint(20),
  `auto` blob,

  `heads` blob,
  `rebate` blob,
  `month_buy` int(11),
  `last_time` int(11),
  `mail_id` int(11),

  PRIMARY KEY (`id`),
  KEY `nickname` (`nickname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--
-- Table structure for table `tb_character_item_package`
--

DROP TABLE IF EXISTS `tb_character_item_package`;
CREATE TABLE `tb_character_item_package` (
  `id` bigint(10) NOT NULL,
  `items` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_character_line_up`
--

DROP TABLE IF EXISTS `tb_character_line_up`;
CREATE TABLE `tb_character_line_up` (
  `id` bigint(20) NOT NULL,
  `line_up_slots` blob,
  `sub_slots` blob,
  `line_up_order` blob,
  `unpars` tinyblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_character_stages`
--

DROP TABLE IF EXISTS `tb_character_stages`;
CREATE TABLE `tb_character_stages` (
  `id` bigint(20) NOT NULL,
  `stage_info` blob,
  `award_info` blob,
  `elite_stage` blob,
  `act_stage` blob,
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
  `equipment_info` blob,
  `enhance_info` blob,
  `nobbing_effect` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `tb_guild_info`
--

DROP TABLE IF EXISTS `tb_guild_info`;
CREATE TABLE `tb_guild_info` (
  `id` varchar(32) NOT NULL,
  `info` blob,
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
  `unpar_skill` int(11) NOT NULL,
  `unpar_skill_level` int(11) NOT NULL,
  `units` blob NOT NULL,
  `slots` blob NOT NULL,
  `hero_ids` tinyblob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `tb_character_lively`;
CREATE TABLE `tb_character_lively` (
  `id` bigint(20) NOT NULL,
  `lively` int(11) NOT NULL,
  `tasks` blob,
  `event_map` blob,
  `last_day` varchar(8),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `tb_character_stone`;
CREATE TABLE `tb_character_stone` (
  `id` bigint(20) NOT NULL,
  `stones` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `tb_character_mine`;
CREATE TABLE `tb_character_mine` (
  `id` bigint(20) NOT NULL,
  `reset_day` varchar(8) NOT NULL,
  `reset_times` int(11) NOT NULL,
  `day_before` varchar(8) NOT NULL,
  `lively` int(11) NOT NULL,
  `mine` blob,
  `guard` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
