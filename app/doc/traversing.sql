/*
Navicat MySQL Data Transfer

Source Server         : travers
Source Server Version : 50617
Source Host           : 192.168.10.179:3306
Source Database       : traversing_3

Target Server Type    : MYSQL
Target Server Version : 50617
File Encoding         : 65001

Date: 2014-07-08 17:52:36
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `tb_character_equipment_chip`
-- ----------------------------
DROP TABLE IF EXISTS `tb_character_equipment_chip`;
CREATE TABLE `tb_character_equipment_chip` (
  `id` bigint(20) NOT NULL,
  `chips` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_character_equipment_chip
-- ----------------------------

-- ----------------------------
-- Table structure for `tb_character_equipments`
-- ----------------------------
DROP TABLE IF EXISTS `tb_character_equipments`;
CREATE TABLE `tb_character_equipments` (
  `id` bigint(20) NOT NULL,
  `equipments` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_character_equipments
-- ----------------------------

-- ----------------------------
-- Table structure for `tb_character_hero`
-- ----------------------------
DROP TABLE IF EXISTS `tb_character_hero`;
CREATE TABLE `tb_character_hero` (
  `id` varchar(50) NOT NULL,
  `character_id` bigint(20) NOT NULL,
  `property` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_character_hero
-- ----------------------------

-- ----------------------------
-- Table structure for `tb_character_hero_chip`
-- ----------------------------
DROP TABLE IF EXISTS `tb_character_hero_chip`;
CREATE TABLE `tb_character_hero_chip` (
  `id` varchar(50) NOT NULL,
  `hero_chips` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_character_hero_chip
-- ----------------------------

-- ----------------------------
-- Table structure for `tb_character_heros`
-- ----------------------------
DROP TABLE IF EXISTS `tb_character_heros`;
CREATE TABLE `tb_character_heros` (
  `id` varchar(50) NOT NULL DEFAULT '',
  `hero_ids` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_character_heros
-- ----------------------------

-- ----------------------------
-- Table structure for `tb_character_info`
-- ----------------------------
DROP TABLE IF EXISTS `tb_character_info`;
CREATE TABLE `tb_character_info` (
  `id` bigint(20) NOT NULL,
  `nickname` varchar(128) DEFAULT '',
  `coin` bigint(20) NOT NULL DEFAULT '0',
  `gold` bigint(20) NOT NULL DEFAULT '0',
  `hero_soul` bigint(20) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_character_info
-- ----------------------------

-- ----------------------------
-- Table structure for `tb_character_item_package`
-- ----------------------------
DROP TABLE IF EXISTS `tb_character_item_package`;
CREATE TABLE `tb_character_item_package` (
  `id` bigint(10) NOT NULL,
  `items` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_character_item_package
-- ----------------------------

-- ----------------------------
-- Table structure for `tb_character_line_up`
-- ----------------------------
DROP TABLE IF EXISTS `tb_character_line_up`;
CREATE TABLE `tb_character_line_up` (
  `id` bigint(20) NOT NULL,
  `line_up` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_character_line_up
-- ----------------------------

-- ----------------------------
-- Table structure for `tb_equipment_info`
-- ----------------------------
DROP TABLE IF EXISTS `tb_equipment_info`;
CREATE TABLE `tb_equipment_info` (
  `id` varchar(32) NOT NULL,
  `character_id` bigint(20) NOT NULL,
  `equipment_info` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_equipment_info
-- ----------------------------

-- ----------------------------
-- Table structure for `tb_nickname_mapping`
-- ----------------------------
DROP TABLE IF EXISTS `tb_nickname_mapping`;
CREATE TABLE `tb_nickname_mapping` (
  `nickname` varchar(128) NOT NULL DEFAULT '',
  `uid` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`nickname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_nickname_mapping
-- ----------------------------

-- ----------------------------
-- Table structure for `tb_test`
-- ----------------------------
DROP TABLE IF EXISTS `tb_test`;
CREATE TABLE `tb_test` (
  `uid` int(11) NOT NULL,
  `items` mediumblob,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of tb_test
-- ----------------------------
