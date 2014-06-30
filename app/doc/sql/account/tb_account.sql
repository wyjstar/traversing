/*
Navicat MySQL Data Transfer

Source Server         : travers
Source Server Version : 50617
Source Host           : 192.168.10.179:3306
Source Database       : account_7

Target Server Type    : MYSQL
Target Server Version : 50617
File Encoding         : 65001

Date: 2014-06-30 12:15:34
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `tb_account`
-- ----------------------------
DROP TABLE IF EXISTS `tb_account`;
CREATE TABLE `tb_account` (
  `id` bigint(20) unsigned NOT NULL,
  `uuid` varchar(32) NOT NULL,
  `account_name` varchar(20) DEFAULT NULL,
  `account_password` varchar(32) DEFAULT NULL,
  `last_login` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_account
-- ----------------------------

-- ----------------------------
-- Table structure for `tb_account_mapping`
-- ----------------------------
DROP TABLE IF EXISTS `tb_account_mapping`;
CREATE TABLE `tb_account_mapping` (
  `id` bigint(20) unsigned NOT NULL,
  `account_token` varchar(32) NOT NULL,
  PRIMARY KEY (`account_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_account_mapping
-- ----------------------------

-- ----------------------------
-- Table structure for `tb_name_mapping`
-- ----------------------------
DROP TABLE IF EXISTS `tb_name_mapping`;
CREATE TABLE `tb_name_mapping` (
  `account_name` varchar(20) NOT NULL,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`account_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tb_name_mapping
-- ----------------------------
