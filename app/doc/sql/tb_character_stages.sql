/*
Navicat MySQL Data Transfer

Source Server         : travers
Source Server Version : 50617
Source Host           : 192.168.10.179:3306
Source Database       : traversing_1

Target Server Type    : MYSQL
Target Server Version : 50617
File Encoding         : 65001

Date: 2014-07-17 17:33:12
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `tb_character_stages`
-- ----------------------------
DROP TABLE IF EXISTS `tb_character_stages`;
CREATE TABLE `tb_character_stages` (
  `id` bigint(20) NOT NULL,
  `complete` mediumblob,
  `open` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_character_stages
-- ----------------------------
