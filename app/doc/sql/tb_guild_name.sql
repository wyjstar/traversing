/*
Navicat MySQL Data Transfer

Source Server         : travers
Source Server Version : 50617
Source Host           : 192.168.10.179:3306
Source Database       : traversing_1

Target Server Type    : MYSQL
Target Server Version : 50617
File Encoding         : 65001

Date: 2014-07-11 13:43:19
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `tb_guild_info`
-- ----------------------------
DROP TABLE IF EXISTS `tb_guild_name`;
CREATE TABLE `tb_guild_name` (
  `g_name` varchar(32) NOT NULL,
  `g_id` varchar(32) NOT NULL,
  PRIMARY KEY (`g_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_guild_info
-- ----------------------------