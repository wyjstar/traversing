/*
Navicat MySQL Data Transfer

Source Server         : travers
Source Server Version : 50617
Source Host           : 192.168.10.179:3306
Source Database       : traversing_4

Target Server Type    : MYSQL
Target Server Version : 50617
File Encoding         : 65001

Date: 2014-07-08 11:23:55
*/

SET FOREIGN_KEY_CHECKS=0;
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
