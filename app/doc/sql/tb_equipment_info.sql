/*
Navicat MySQL Data Transfer

Source Server         : travers
Source Server Version : 50617
Source Host           : 192.168.10.179:3306
Source Database       : traversing_4

Target Server Type    : MYSQL
Target Server Version : 50617
File Encoding         : 65001

Date: 2014-07-08 11:24:08
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `tb_equipment_info`
-- ----------------------------
DROP TABLE IF EXISTS `tb_equipment_info`;
CREATE TABLE `tb_equipment_info` (
  `id` varchar(32) NOT NULL,
  `character_id` bigint(20) NOT NULL,
  `equipment_info` mediumblob,
  PRIMARY KEY (`equipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_equipment_info
-- ----------------------------
