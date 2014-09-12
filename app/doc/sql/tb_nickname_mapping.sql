/*
Navicat MySQL Data Transfer

Source Server         : traversing
Source Server Version : 50617
Source Host           : 192.168.10.170:3306
Source Database       : account_0

Target Server Type    : MYSQL
Target Server Version : 50617
File Encoding         : 65001

Date: 2014-06-25 11:03:31
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for tb_nickname_mapping
-- ----------------------------
DROP TABLE IF EXISTS `tb_nickname_mapping`;
CREATE TABLE `tb_nickname_mapping` (
  `id` int(11) NOT NULL,
  `nickname` char(20) DEFAULT NULL,
  PRIMARY KEY (`nickname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
