-- MySQL dump 10.13  Distrib 5.6.17, for Linux (x86_64)
--
-- Host: localhost    Database: 
-- ------------------------------------------------------
-- Server version	5.6.17

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
-- Current Database: `account_0`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `account_0` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `account_0`;

--
-- Table structure for table `tb_account`
--

DROP TABLE IF EXISTS `tb_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_account` (
  `id` bigint(20) unsigned NOT NULL,
  `uuid` varchar(32) NOT NULL,
  `account_name` varchar(20) DEFAULT NULL,
  `account_password` varchar(32) DEFAULT NULL,
  `last_login` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_account_mapping`
--

DROP TABLE IF EXISTS `tb_account_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_account_mapping` (
  `account_token` varchar(32) NOT NULL,
  `id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`account_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `account_1`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `account_1` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `account_1`;

--
-- Table structure for table `tb_account`
--

DROP TABLE IF EXISTS `tb_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_account` (
  `id` bigint(20) unsigned NOT NULL,
  `uuid` varchar(32) NOT NULL,
  `account_name` varchar(20) DEFAULT NULL,
  `account_password` varchar(32) DEFAULT NULL,
  `last_login` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_account_mapping`
--

DROP TABLE IF EXISTS `tb_account_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_account_mapping` (
  `account_token` varchar(32) NOT NULL,
  `id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`account_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `account_2`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `account_2` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `account_2`;

--
-- Table structure for table `tb_account`
--

DROP TABLE IF EXISTS `tb_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_account` (
  `id` bigint(20) unsigned NOT NULL,
  `uuid` varchar(32) NOT NULL,
  `account_name` varchar(20) DEFAULT NULL,
  `account_password` varchar(32) DEFAULT NULL,
  `last_login` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_account_mapping`
--

DROP TABLE IF EXISTS `tb_account_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_account_mapping` (
  `account_token` varchar(32) NOT NULL,
  `id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`account_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `account_3`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `account_3` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `account_3`;

--
-- Table structure for table `tb_account`
--

DROP TABLE IF EXISTS `tb_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_account` (
  `id` bigint(20) unsigned NOT NULL,
  `uuid` varchar(32) NOT NULL,
  `account_name` varchar(20) DEFAULT NULL,
  `account_password` varchar(32) DEFAULT NULL,
  `last_login` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_account_mapping`
--

DROP TABLE IF EXISTS `tb_account_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_account_mapping` (
  `account_token` varchar(32) NOT NULL,
  `id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`account_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `account_4`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `account_4` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `account_4`;

--
-- Table structure for table `tb_account`
--

DROP TABLE IF EXISTS `tb_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_account` (
  `id` bigint(20) unsigned NOT NULL,
  `uuid` varchar(32) NOT NULL,
  `account_name` varchar(20) DEFAULT NULL,
  `account_password` varchar(32) DEFAULT NULL,
  `last_login` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_account_mapping`
--

DROP TABLE IF EXISTS `tb_account_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_account_mapping` (
  `account_token` varchar(32) NOT NULL,
  `id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`account_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `account_5`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `account_5` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `account_5`;

--
-- Table structure for table `tb_account`
--

DROP TABLE IF EXISTS `tb_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_account` (
  `id` bigint(20) unsigned NOT NULL,
  `uuid` varchar(32) NOT NULL,
  `account_name` varchar(20) DEFAULT NULL,
  `account_password` varchar(32) DEFAULT NULL,
  `last_login` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_account_mapping`
--

DROP TABLE IF EXISTS `tb_account_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_account_mapping` (
  `account_token` varchar(32) NOT NULL,
  `id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`account_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `account_6`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `account_6` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `account_6`;

--
-- Table structure for table `tb_account`
--

DROP TABLE IF EXISTS `tb_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_account` (
  `id` bigint(20) unsigned NOT NULL,
  `uuid` varchar(32) NOT NULL,
  `account_name` varchar(20) DEFAULT NULL,
  `account_password` varchar(32) DEFAULT NULL,
  `last_login` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_account_mapping`
--

DROP TABLE IF EXISTS `tb_account_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_account_mapping` (
  `account_token` varchar(32) NOT NULL,
  `id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`account_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `account_7`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `account_7` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `account_7`;

--
-- Table structure for table `tb_account`
--

DROP TABLE IF EXISTS `tb_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_account` (
  `id` bigint(20) unsigned NOT NULL,
  `uuid` varchar(32) NOT NULL,
  `account_name` varchar(20) DEFAULT NULL,
  `account_password` varchar(32) DEFAULT NULL,
  `last_login` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_account_mapping`
--

DROP TABLE IF EXISTS `tb_account_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_account_mapping` (
  `id` bigint(20) unsigned NOT NULL,
  `account_token` varchar(32) NOT NULL,
  PRIMARY KEY (`account_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `anheisg`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `anheisg` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */;

USE `anheisg`;

--
-- Table structure for table `tb_active`
--

DROP TABLE IF EXISTS `tb_active`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_active` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `active_no` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '激活码',
  `key_type` int(10) NOT NULL DEFAULT '0' COMMENT '激活码类型',
  `user_id` int(10) NOT NULL DEFAULT '0' COMMENT '用户id',
  `character_id` int(10) NOT NULL DEFAULT '0' COMMENT '角色的id',
  `used` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否被使用',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_aptitude`
--

DROP TABLE IF EXISTS `tb_aptitude`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_aptitude` (
  `qlevel` int(3) NOT NULL DEFAULT '1' COMMENT '装备强化等级',
  `wq` int(3) DEFAULT '1' COMMENT '武器强化几率-实际',
  `fj` int(3) DEFAULT '1' COMMENT '防具强化概率-实际',
  `sp` int(3) DEFAULT '1' COMMENT '饰品强化概率-实际',
  PRIMARY KEY (`qlevel`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_aptitude_gain`
--

DROP TABLE IF EXISTS `tb_aptitude_gain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_aptitude_gain` (
  `qlevel` int(5) NOT NULL DEFAULT '1' COMMENT '强化收益表中强化等级',
  `wq` int(5) NOT NULL DEFAULT '1' COMMENT '武器收益百分比',
  `fj` int(5) NOT NULL DEFAULT '1' COMMENT '防具收益百分比',
  `sp` int(5) NOT NULL DEFAULT '1' COMMENT '饰品收益百分比',
  `color` int(5) NOT NULL DEFAULT '1' COMMENT '物品品质 1灰 2白 3绿 4蓝 5紫 6橙 7红'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_arena`
--

DROP TABLE IF EXISTS `tb_arena`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_arena` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `characterId` int(10) NOT NULL COMMENT '角色的ID',
  `score` int(10) NOT NULL DEFAULT '0' COMMENT '角色的竞技场积分',
  `ranking` int(10) NOT NULL DEFAULT '0' COMMENT '竞技场排名',
  `liansheng` int(10) NOT NULL DEFAULT '0' COMMENT '角色的连胜次数',
  `lastresult` int(10) NOT NULL DEFAULT '0' COMMENT '上次战斗结果',
  `lasttime` datetime NOT NULL DEFAULT '2012-06-20 12:00:00' COMMENT '上次战斗的时间',
  `surplustimes` int(10) NOT NULL DEFAULT '15' COMMENT '剩余次数',
  `buytimes` int(10) NOT NULL DEFAULT '0' COMMENT '已经购买的次数',
  `receive` int(10) NOT NULL DEFAULT '0' COMMENT '是否已经领取过奖励 0否 1是',
  `recorddate` date NOT NULL COMMENT '记录的日期',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=244 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_arena_log`
--

DROP TABLE IF EXISTS `tb_arena_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_arena_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '记录的序号',
  `tiaozhan` int(10) NOT NULL COMMENT '挑战方的ID',
  `yingzhan` int(10) NOT NULL COMMENT '应战者的ID',
  `tiaozhanname` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '挑战者的名称',
  `yingzhanname` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '应战者的名称',
  `success` int(10) DEFAULT '0' COMMENT '挑战成功或失败',
  `rankingChange` int(10) NOT NULL DEFAULT '0' COMMENT '排名变化',
  `recordtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=108 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_bill`
--

DROP TABLE IF EXISTS `tb_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_bill` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `characterId` int(10) NOT NULL COMMENT '角色的ID',
  `spendType` int(10) NOT NULL COMMENT '消费类型',
  `spendGold` int(10) NOT NULL COMMENT '消费钻的数量',
  `itemId` int(10) NOT NULL COMMENT '关联的物品的ID',
  `spendDetails` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '消费明细',
  `recordDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '消费时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=443 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_buff_buff`
--

DROP TABLE IF EXISTS `tb_buff_buff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_buff_buff` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '记录的ID',
  `buffId` int(10) NOT NULL DEFAULT '0' COMMENT 'buff的ID',
  `tbuffId` int(10) NOT NULL DEFAULT '0' COMMENT '能与之产生效果的buff的ID',
  `nbuffId` int(10) NOT NULL DEFAULT '0' COMMENT '新产生的buff的ID',
  `nstack` int(10) NOT NULL DEFAULT '1' COMMENT '新产生的buff的层叠数',
  `effect` varchar(500) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '产生效果后生产的效果',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6003 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_buff_effect`
--

DROP TABLE IF EXISTS `tb_buff_effect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_buff_effect` (
  `buffEffectID` int(10) NOT NULL COMMENT 'buff的特效id',
  `attributeType` int(10) NOT NULL DEFAULT '0' COMMENT 'buff属性 1物理 2魔法',
  `effectTriggerCondition` varchar(255) NOT NULL DEFAULT '' COMMENT 'buff触发条件',
  `triggerEffectFormula` varchar(255) DEFAULT '' COMMENT '被动触发的buff或debuff效果计算公式',
  `triggerDotHotFormula` varchar(255) DEFAULT '' COMMENT '被动触发的Dot或hot效果计算公式',
  `effectFormula` varchar(255) NOT NULL DEFAULT '' COMMENT 'buff或debuff的效果计算公式',
  `dotHotFormula` varchar(255) DEFAULT '' COMMENT 'Dot或hot效果公式',
  `effectDropFormula` varchar(255) NOT NULL DEFAULT '' COMMENT '技能消失时的效果（技能效果添加的逆运算）',
  `addBuffId` int(20) NOT NULL DEFAULT '0' COMMENT 'buff触发buff的ID',
  PRIMARY KEY (`buffEffectID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_buff_info`
--

DROP TABLE IF EXISTS `tb_buff_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_buff_info` (
  `buffId` int(10) NOT NULL DEFAULT '0' COMMENT 'buff的ID',
  `buffName` varchar(50) NOT NULL DEFAULT '' COMMENT 'buff的名称',
  `buffDes` varchar(255) DEFAULT '这是个灰常NB的buff' COMMENT 'buff的描述',
  `traceCD` int(10) NOT NULL DEFAULT '1' COMMENT 'buff的持续回合数',
  `replaceBuff` varchar(50) NOT NULL DEFAULT '' COMMENT '可替换的buff的id',
  `buffType` int(10) NOT NULL DEFAULT '0' COMMENT 'buff的类型',
  `maxStack` int(10) NOT NULL DEFAULT '1' COMMENT 'buff的最大堆叠层数',
  `buffEffectID` int(10) NOT NULL DEFAULT '0' COMMENT 'buff的效果的id',
  `buffEffectResource` int(10) NOT NULL DEFAULT '0' COMMENT 'buff的资源id',
  `buffIcon` int(10) NOT NULL DEFAULT '0' COMMENT 'buff的图标ID',
  PRIMARY KEY (`buffId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_buff_skill`
--

DROP TABLE IF EXISTS `tb_buff_skill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_buff_skill` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '记录的ID',
  `buffId` int(10) NOT NULL DEFAULT '0' COMMENT 'buff的ID',
  `skillId` int(10) NOT NULL DEFAULT '0' COMMENT 'buff的ID',
  `addition` float NOT NULL DEFAULT '0' COMMENT '效果的加成',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=100031 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character`
--

DROP TABLE IF EXISTS `tb_character`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '角色的id号',
  `viptype` tinyint(4) DEFAULT '0' COMMENT '角色的类型（0普通 1 VIP1  2 vip2）',
  `nickname` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '角色的昵称',
  `profession` tinyint(4) unsigned zerofill NOT NULL DEFAULT '0000' COMMENT '角色的职业 （0 新手 1战士 2 法师 3 游侠 4 牧师）',
  `figure` tinyint(4) DEFAULT '0' COMMENT '角色的形象',
  `sex` tinyint(4) DEFAULT '1' COMMENT '1男 2女',
  `camp` tinyint(4) DEFAULT '0' COMMENT '所属阵营 0无 1魏 2蜀 3 吴',
  `level` int(10) DEFAULT '1' COMMENT '角色的等级 初始为1',
  `friendCount` int(10) DEFAULT '50' COMMENT '好友上限',
  `coin` int(20) DEFAULT '99999999' COMMENT '玩家的游戏币(金币) 初始为 10000',
  `gold` int(20) DEFAULT '99999999' COMMENT '魔钻 玩家充值购买的商城货币',
  `vipexp` int(20) DEFAULT '0' COMMENT 'vip经验值',
  `town` int(10) DEFAULT '1000' COMMENT '角色所在的场景的ID',
  `position_x` int(10) DEFAULT '500' COMMENT '角色的x坐标',
  `position_y` int(10) DEFAULT '500' COMMENT '角色的y坐标',
  `energy` int(10) DEFAULT '200' COMMENT '角色的活力值',
  `exp` int(20) DEFAULT '0' COMMENT '角色的经验值',
  `hp` int(20) DEFAULT '500' COMMENT '角色的当前血量',
  `mp` int(20) DEFAULT '100' COMMENT '角色的当前魔力值',
  `baseStr` int(20) DEFAULT '5' COMMENT '系统根据职业赋予的基础力量点',
  `baseVit` int(20) DEFAULT '5' COMMENT '系统根据职业赋予的基础体质点',
  `baseDex` int(20) DEFAULT '5' COMMENT '系统根据职业赋予的基础灵巧点（敏捷）',
  `baseWis` int(20) DEFAULT '5' COMMENT '系统根据职业赋予的基础智力点',
  `baseSpi` int(20) DEFAULT '5' COMMENT '系统根据职业赋予的基础精神点',
  `LastonlineTime` datetime DEFAULT '2007-05-06 00:00:00' COMMENT '最后在线时间',
  `contribution` int(20) DEFAULT '0' COMMENT '角色在行会的贡献度',
  `glory` int(20) DEFAULT '0' COMMENT '角色的荣耀值，影响角色的军衔',
  `rank` int(20) DEFAULT '0' COMMENT '角色的军衔',
  `appellation` int(20) DEFAULT '0' COMMENT '角色的称号',
  `packageSize` int(10) DEFAULT '24' COMMENT '包裹的大小，初始为24格',
  `famPackSize` int(10) DEFAULT '6' COMMENT '殖民包裹的大小',
  `outtime` datetime DEFAULT '2007-05-06 00:00:00' COMMENT '角色下线时间',
  `spirit` varchar(500) COLLATE utf8_unicode_ci DEFAULT '这家伙很懒，什么都么有写' COMMENT '角色心情',
  `nowmatrix` int(10) DEFAULT '100001' COMMENT '当前阵法',
  `novicestep` int(10) DEFAULT '1' COMMENT '新手奖励步骤',
  `dayawardtime` datetime DEFAULT '2007-05-06 00:00:00' COMMENT '每日奖励的领取时间',
  `isOnline` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否在线',
  `createtime` datetime NOT NULL COMMENT '创建日期',
  `donttalk` int(2) DEFAULT '0' COMMENT '0不禁言  1禁言',
  `prestige` int(20) DEFAULT '0' COMMENT '当前威望值',
  `NobilityLevel` int(20) DEFAULT '1' COMMENT '当前爵位等级',
  `morale` int(20) DEFAULT '0' COMMENT '当前斗气值',
  `leavetime` datetime DEFAULT '2007-05-06 00:00:00' COMMENT '离开军团的时间',
  `guanqia` int(20) DEFAULT '1000' COMMENT '角色当前的关卡ID',
  `skill` int(20) DEFAULT '100006' COMMENT '角色的技能',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1000060 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_collect`
--

DROP TABLE IF EXISTS `tb_character_collect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_collect` (
  `characterId` int(10) NOT NULL COMMENT '角色的ID',
  `collect` varchar(1024) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '已经收集到的宠物',
  PRIMARY KEY (`characterId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_daily`
--

DROP TABLE IF EXISTS `tb_character_daily`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_daily` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `characterId` int(11) NOT NULL COMMENT '角色的id',
  `dailyId` int(11) NOT NULL COMMENT '每日目标的ID',
  `current` int(10) NOT NULL DEFAULT '0' COMMENT '当前完成程度',
  `received` int(10) NOT NULL DEFAULT '0' COMMENT '奖励是否已领取',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3865 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_effect`
--

DROP TABLE IF EXISTS `tb_character_effect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_effect` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '角色携带buff的记录id',
  `characterID` int(20) NOT NULL COMMENT '角色的id',
  `effectID` int(20) NOT NULL COMMENT '效果的id',
  `startTime` datetime NOT NULL COMMENT '效果开始的时间',
  `surplus` int(20) NOT NULL DEFAULT '0' COMMENT '剩余的数值',
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1034 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_fate`
--

DROP TABLE IF EXISTS `tb_character_fate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_fate` (
  `characterId` int(10) NOT NULL DEFAULT '0' COMMENT '角色的ID',
  `freedate` date NOT NULL DEFAULT '2012-06-06' COMMENT '上次使用免费的日期',
  `freetimes` int(10) NOT NULL DEFAULT '0' COMMENT '已经使用免费的次数',
  `score` int(10) NOT NULL DEFAULT '0' COMMENT '命格积分',
  `fateLevel` int(10) NOT NULL DEFAULT '1' COMMENT '当前可使用的高等级占星等级',
  PRIMARY KEY (`characterId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_godhead`
--

DROP TABLE IF EXISTS `tb_character_godhead`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_godhead` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) NOT NULL COMMENT '角色的id',
  `godheadId` int(11) NOT NULL COMMENT '神格的ID',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=796 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_guild`
--

DROP TABLE IF EXISTS `tb_character_guild`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_guild` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `characterId` int(10) unsigned NOT NULL COMMENT '角色ID',
  `guildId` int(10) unsigned NOT NULL COMMENT '行会ID',
  `duty` int(10) unsigned NOT NULL DEFAULT '7' COMMENT '1：会长，2：左参谋，3：右参谋，4：左队长，5：右队长，6：中队长，7普通成员',
  `contribution` int(10) NOT NULL DEFAULT '0' COMMENT '角色行会贡献度',
  `joinTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '入会时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='玩家与行会关系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_matrix`
--

DROP TABLE IF EXISTS `tb_character_matrix`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_matrix` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `characterId` int(10) NOT NULL DEFAULT '0' COMMENT '角色的id',
  `matrixId` int(10) NOT NULL DEFAULT '0' COMMENT '阵法的id',
  `eyes_1` int(10) NOT NULL DEFAULT '-1' COMMENT '阵法1的战斗单元ID，0表示角色自身',
  `eyes_2` int(10) DEFAULT '-1',
  `eyes_3` int(10) DEFAULT '-1',
  `eyes_4` int(10) DEFAULT '-1',
  `eyes_5` int(10) DEFAULT '-1',
  `eyes_6` int(10) DEFAULT '-1',
  `eyes_7` int(10) DEFAULT '-1',
  `eyes_8` int(10) DEFAULT '-1',
  `eyes_9` int(10) DEFAULT '-1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8530 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_shop`
--

DROP TABLE IF EXISTS `tb_character_shop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_shop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shopId` int(11) DEFAULT NULL COMMENT '商店id',
  `characterId` int(11) NOT NULL COMMENT '玩家id',
  `enterTime` datetime NOT NULL COMMENT '进入时间',
  `seed` varchar(255) DEFAULT NULL COMMENT '产生物品列表的种子',
  PRIMARY KEY (`id`,`characterId`,`enterTime`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_skill`
--

DROP TABLE IF EXISTS `tb_character_skill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_skill` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `characterId` int(20) NOT NULL COMMENT '角色的id',
  `skillId` int(11) NOT NULL COMMENT '技能的id',
  `skillLevel` int(11) DEFAULT '1' COMMENT '技能的等级',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=221 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_skillsetting`
--

DROP TABLE IF EXISTS `tb_character_skillsetting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_skillsetting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) NOT NULL COMMENT '用户ID',
  `ActiveSkill_1` int(11) DEFAULT '0' COMMENT '第一主动技能ID（-1 未开启 0 开启）',
  `ActiveSkill_2` int(11) DEFAULT '-1' COMMENT '第二主动技能ID（-1 未开启 0 开启）',
  `ActiveSkill_3` int(11) DEFAULT '-1' COMMENT '第三主动技能ID（-1 未开启 0 开启）',
  `PassiveSkill_1` int(11) DEFAULT '-1' COMMENT '第一被动技能（-1 未开启 0 开启）',
  `PassiveSkill_2` int(11) DEFAULT '-1' COMMENT '第二被动技能（-1 未开启 0 开启）',
  `skillPoint` int(11) DEFAULT '0' COMMENT '角色的技能点数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1737 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_character_top`
--

DROP TABLE IF EXISTS `tb_character_top`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_character_top` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '角色排行表主键id',
  `characterid` int(20) NOT NULL COMMENT '角色id',
  `battle` int(20) NOT NULL COMMENT '战斗力数值',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=229326 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_chat_astrict`
--

DROP TABLE IF EXISTS `tb_chat_astrict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_chat_astrict` (
  `characterid` int(20) NOT NULL COMMENT '角色id',
  `team` int(2) DEFAULT '1' COMMENT '是否接受队伍频道信息 1表示接受 小于1表示屏蔽',
  `ts` int(2) DEFAULT '1' COMMENT '是否接受提示信息 >=1表示接受  <1表示屏蔽',
  `alls` int(2) DEFAULT '1' COMMENT '是否接受全部信息 >=1表示接受 <1表示屏蔽',
  `jt` int(2) DEFAULT '1' COMMENT '是否接受军团信息',
  `sl` int(2) DEFAULT '1' COMMENT '是否接受私聊信息',
  `xt` int(2) DEFAULT '1' COMMENT '是否接受系统信息',
  PRIMARY KEY (`characterid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_chat_log`
--

DROP TABLE IF EXISTS `tb_chat_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_chat_log` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '聊天记录表主键',
  `fromplayerid` int(11) NOT NULL COMMENT '发消息的角色id characterid',
  `toplayerid` int(11) NOT NULL COMMENT '接收消息的角色id characterid',
  `context` varchar(500) NOT NULL COMMENT '聊天内容',
  `times` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '信息产生时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_compose`
--

DROP TABLE IF EXISTS `tb_compose`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_compose` (
  `goal` int(20) NOT NULL COMMENT '目标物品模板id （合成之后产出的物品）',
  `templateid` int(20) DEFAULT NULL COMMENT '组成部分的模板id',
  `count` int(20) DEFAULT NULL COMMENT '需要多少个templateid才能合成一个物品',
  `gold` int(10) DEFAULT NULL COMMENT '多少魔钻一个',
  PRIMARY KEY (`goal`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_dailygoal`
--

DROP TABLE IF EXISTS `tb_dailygoal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_dailygoal` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '每日目标的id',
  `dailyname` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '目标名称',
  `dailydesc` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '目标描述',
  `dailytype` int(11) NOT NULL DEFAULT '1' COMMENT '目标类型',
  `associatedId` int(11) NOT NULL DEFAULT '0' COMMENT '关联的目标ID',
  `goal` int(11) NOT NULL DEFAULT '1' COMMENT '目标数量',
  `expbound` int(11) NOT NULL DEFAULT '0' COMMENT '经验奖励',
  `coinbound` int(11) NOT NULL DEFAULT '0' COMMENT '金币奖励',
  `goldbound` int(11) NOT NULL DEFAULT '0' COMMENT '魔钻奖励',
  `itembound` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '物品奖励 格式见任务',
  `titlebound` int(11) NOT NULL DEFAULT '0' COMMENT '称号奖励',
  `dateindex` int(4) DEFAULT '1' COMMENT '日期序号',
  `dailydate` date NOT NULL COMMENT '目标要求的日期',
  `icon` int(10) NOT NULL DEFAULT '0' COMMENT '图标',
  `type` int(10) NOT NULL DEFAULT '0' COMMENT '图标类型',
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10000037 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_defeated_fail_log`
--

DROP TABLE IF EXISTS `tb_defeated_fail_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_defeated_fail_log` (
  `id` int(30) NOT NULL AUTO_INCREMENT COMMENT '保卫失败表主键id',
  `defeatedid` int(20) DEFAULT NULL COMMENT '挑战失败者的角色id',
  `defeatedname` varchar(100) DEFAULT NULL COMMENT '挑战失败者的角色名称',
  `defeatedlogid` int(200) DEFAULT NULL COMMENT 'tb_instance_colonize表外键',
  `firstid` int(20) DEFAULT NULL COMMENT '副本组中一个副本的id',
  `times` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后一次攻打时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=84 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_defeated_fail_log1`
--

DROP TABLE IF EXISTS `tb_defeated_fail_log1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_defeated_fail_log1` (
  `id` int(30) NOT NULL AUTO_INCREMENT COMMENT '保卫失败表主键id',
  `defeatedid` int(20) DEFAULT NULL COMMENT '挑战失败者的角色id',
  `defeatedname` varchar(100) DEFAULT NULL COMMENT '挑战失败者的角色名称',
  `defeatedlogid` int(200) DEFAULT NULL COMMENT 'tb_instance_colonize表外键',
  `firstid` int(20) DEFAULT NULL COMMENT '副本组中一个副本的id',
  `times` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后一次攻打时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=84 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_defence_bonus`
--

DROP TABLE IF EXISTS `tb_defence_bonus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_defence_bonus` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '殖民奖金表；主键id',
  `name` varchar(200) DEFAULT NULL COMMENT '城镇或者副本名称',
  `type` int(2) DEFAULT NULL COMMENT '0副本 1城镇',
  `price` int(20) DEFAULT '0' COMMENT '单次通关奖励',
  `defencecount` int(20) DEFAULT '0' COMMENT '入侵次数',
  `clearancecount` int(20) DEFAULT '0' COMMENT '通关次数',
  `pid` int(20) DEFAULT NULL COMMENT '角色id',
  `ismax` int(2) DEFAULT '0' COMMENT '0没有达到最大值  1达到最大值（通关奖励的金币数量）',
  `reward` int(20) DEFAULT NULL COMMENT '奖励金币数量',
  `tid` int(20) DEFAULT '0' COMMENT '副本或者城市id',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1441 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_defence_log`
--

DROP TABLE IF EXISTS `tb_defence_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_defence_log` (
  `id` int(200) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `firstid` int(20) DEFAULT NULL COMMENT '副本保卫表；副本组中第一个副本id(最简单的那个副本的id)',
  `succeedid` int(20) DEFAULT '0' COMMENT '成功占领副本的角色id',
  `succeedname` varchar(100) DEFAULT '无' COMMENT '成功占领副本的角色名称',
  `laird` int(20) DEFAULT NULL COMMENT '领主角色id',
  `enable` int(2) DEFAULT '1' COMMENT '0表示没有启用  1表示启用',
  `typeid` int(2) DEFAULT '0' COMMENT '0表示副本殖民  1表示城镇殖民',
  `cityname` varchar(200) DEFAULT '无' COMMENT '城镇名称或副本名称',
  `clearancecount` int(20) DEFAULT '0' COMMENT '其他人通关次数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_defence_scene_bonus`
--

DROP TABLE IF EXISTS `tb_defence_scene_bonus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_defence_scene_bonus` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '城镇殖民奖励表；主键id',
  `sid` int(20) NOT NULL COMMENT '城镇场景id',
  `bonus` int(20) NOT NULL COMMENT '获得的奖励数量',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_door`
--

DROP TABLE IF EXISTS `tb_door`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_door` (
  `id` int(10) NOT NULL COMMENT '传送门的ID',
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT '传送门的名称',
  `functionType` tinyint(4) NOT NULL DEFAULT '2' COMMENT '功能类型  1场景跳转 2副本选择',
  `level` int(10) NOT NULL COMMENT '触发的等级',
  `mapid` int(10) NOT NULL COMMENT '传送阵所在的地图的ID',
  `famID` int(10) NOT NULL COMMENT '关联副本的ID',
  `nextmap` int(10) NOT NULL COMMENT '下一个地图的ID',
  `position_x` int(10) NOT NULL COMMENT '传送阵所在的地图的X坐标',
  `position_y` int(10) NOT NULL COMMENT '传送阵所在的地图的Y坐标',
  `init_x` int(10) NOT NULL COMMENT '角色出现在下一张场景的x坐标',
  `init_y` int(10) NOT NULL COMMENT '角色出现在下一张场景的y坐标',
  `resourceId` int(10) NOT NULL COMMENT '传送阵的资源ID',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_dropout`
--

DROP TABLE IF EXISTS `tb_dropout`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_dropout` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '掉落主键Id',
  `itemid` varchar(500) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '掉落物品id级概率 概率基数为十万[物品id,数量,50000] 表示该物品掉落记录为50%  掉落多个用,隔开[物品id,数量,几率],[物品id,几率],[物品id,几率]',
  `upper` int(20) NOT NULL DEFAULT '0' COMMENT '游戏币掉落上限',
  `lower` int(20) NOT NULL DEFAULT '0' COMMENT '游戏币掉落下限',
  `coupon` varchar(200) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '掉落绑定钻 绑定钻的数量，绑定钻的几率      1,1 表示有100W分之一的几率掉落1个绑定钻',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=276 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_effect`
--

DROP TABLE IF EXISTS `tb_effect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_effect` (
  `id` int(20) NOT NULL COMMENT '效果的ID',
  `name` varchar(20) NOT NULL COMMENT '效果的名称',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '效果的描述',
  `type` int(20) NOT NULL DEFAULT '0' COMMENT '图标的类型（判断路径）',
  `icon` int(20) NOT NULL DEFAULT '0' COMMENT '效果的图标',
  `effectType` tinyint(4) NOT NULL DEFAULT '1' COMMENT '效果的类型 1血气 2能量 3buff 4经验加成 5属性',
  `triggerType` tinyint(4) NOT NULL DEFAULT '1' COMMENT '效果的触发类型 1buff 2hot',
  `continuedType` tinyint(4) NOT NULL DEFAULT '1' COMMENT '效果持续类型 1时间 2剩余值',
  `effectScript` varchar(500) NOT NULL DEFAULT '' COMMENT '效果脚本',
  `totaltime` int(20) NOT NULL DEFAULT '0' COMMENT '效果持续时间',
  `surplus` int(20) NOT NULL DEFAULT '-1' COMMENT '效果剩余数值',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_equipment`
--

DROP TABLE IF EXISTS `tb_equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_equipment` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `characterId` int(20) DEFAULT '-1' COMMENT '玩家id',
  `header` int(20) DEFAULT '-1' COMMENT '装备槽头部的物品id，-1为没有',
  `body` int(20) DEFAULT '-1' COMMENT '身体（上衣）',
  `belt` int(20) DEFAULT '-1' COMMENT '腰带部位',
  `trousers` int(20) DEFAULT '-1' COMMENT '下装部位',
  `shoes` int(20) DEFAULT '-1' COMMENT '鞋子部位',
  `bracer` int(20) DEFAULT '-1' COMMENT '护腕部位',
  `cloak` int(20) DEFAULT '-1' COMMENT '披风部位',
  `necklace` int(20) DEFAULT '-1' COMMENT '项链部位',
  `waist` int(20) DEFAULT '-1' COMMENT '腰饰部位',
  `weapon` int(20) DEFAULT '-1' COMMENT '武器部位',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1808 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_equipmentset`
--

DROP TABLE IF EXISTS `tb_equipmentset`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_equipmentset` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '套装的ID',
  `setname` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '套装名称',
  `setdesc` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '套装描述',
  `effect` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '套装效果',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1000020 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_experience`
--

DROP TABLE IF EXISTS `tb_experience`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_experience` (
  `level` int(10) NOT NULL AUTO_INCREMENT,
  `ExpRequired` bigint(40) DEFAULT '0' COMMENT '等级升级所需经验',
  `ExpSecProduce` int(20) DEFAULT '0' COMMENT '等级经验秒产',
  PRIMARY KEY (`level`)
) ENGINE=MyISAM AUTO_INCREMENT=101 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_fate`
--

DROP TABLE IF EXISTS `tb_fate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_fate` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '命格的实例ID',
  `tempalteId` int(10) NOT NULL DEFAULT '0' COMMENT '命格的实例ID',
  `level` int(10) NOT NULL DEFAULT '1' COMMENT '命格的等级',
  `exp` int(10) NOT NULL DEFAULT '0' COMMENT '命格的当前经验',
  `characterId` int(10) NOT NULL DEFAULT '0' COMMENT '命格所属角色',
  `position` int(10) NOT NULL DEFAULT '-1' COMMENT '命格所在的位置 -1表示未拾取  其他表示在命格包裹中的位置 ',
  `equip` int(10) NOT NULL DEFAULT '-2' COMMENT '-2表示未拾取 -1表示未装备 0表示角色装备中 其他表示宠物装备中',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2632 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_fate_template`
--

DROP TABLE IF EXISTS `tb_fate_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_fate_template` (
  `id` int(10) NOT NULL COMMENT '命格的ID',
  `name` varchar(50) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '命格的名称',
  `desc` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '命格的描述',
  `icon` int(10) NOT NULL DEFAULT '0' COMMENT '命格的图标',
  `type` int(10) NOT NULL DEFAULT '0' COMMENT '命格的图标类型',
  `quality` int(10) NOT NULL DEFAULT '1' COMMENT '命格的品质',
  `attrtype` int(10) NOT NULL DEFAULT '1' COMMENT '命格的属性类型',
  `effectstr` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '{}' COMMENT '命格的效果公式',
  `score` int(10) NOT NULL DEFAULT '0' COMMENT '兑换所需积分',
  `price` int(10) NOT NULL DEFAULT '10' COMMENT '金币价格',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_fightfail`
--

DROP TABLE IF EXISTS `tb_fightfail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_fightfail` (
  `sceneId` int(10) NOT NULL COMMENT '副本场景的ID',
  `failtype` int(11) NOT NULL COMMENT '失败后的弹窗类型',
  `tishiStr` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '提示描述',
  `contentStr` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '内容描述',
  `caozuoStr` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '操作描述',
  PRIMARY KEY (`sceneId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_figure_config`
--

DROP TABLE IF EXISTS `tb_figure_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_figure_config` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `figure` int(10) NOT NULL DEFAULT '0' COMMENT '角色的形象',
  `source` int(10) NOT NULL DEFAULT '0' COMMENT '对应的4位数的资源ID 小于5000',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=67 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_fortress`
--

DROP TABLE IF EXISTS `tb_fortress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_fortress` (
  `id` int(10) NOT NULL DEFAULT '0' COMMENT '城镇要塞的ID',
  `sceneId` int(10) NOT NULL DEFAULT '0' COMMENT '城镇的ID',
  `name` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '城镇要塞的名称',
  `kimori` int(10) DEFAULT '0' COMMENT '城镇防守方的ID',
  `siege` int(10) DEFAULT '0' COMMENT '城镇攻击方的ID',
  `isOccupied` int(10) DEFAULT '0' COMMENT '城镇是否被占领',
  `applyTime` datetime DEFAULT '2007-05-06 00:00:00' COMMENT '军团战申请的时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_fortress_log`
--

DROP TABLE IF EXISTS `tb_fortress_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_fortress_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '日志的记录ID',
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '日志的内容',
  `recordTime` datetime DEFAULT NULL COMMENT '日志的日期',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_friend`
--

DROP TABLE IF EXISTS `tb_friend`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_friend` (
  `friendId` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) NOT NULL COMMENT '家玩id',
  `playerId` int(11) NOT NULL DEFAULT '-1' COMMENT '联关玩家id',
  `friendType` int(11) DEFAULT '1' COMMENT '关系类型  1.好友  2.黑名单 4仇敌',
  `isSheildedMail` int(11) DEFAULT '0' COMMENT '是否屏蔽邮件 0.不屏蔽邮件 1.屏蔽',
  `makeTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '关系建立的时间',
  `goodwill` int(20) DEFAULT '0' COMMENT '好感度',
  `guyong` int(11) DEFAULT '0' COMMENT '是否被雇佣 0否 1是',
  `clue` int(2) DEFAULT '0' COMMENT '是否上线提示 0不提示   1提示',
  PRIMARY KEY (`friendId`)
) ENGINE=MyISAM AUTO_INCREMENT=95 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_friend_chat`
--

DROP TABLE IF EXISTS `tb_friend_chat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_friend_chat` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '角色最近联系人表的主键id',
  `characterid` int(20) NOT NULL COMMENT '当前角色id',
  `friendsid` varchar(500) NOT NULL DEFAULT '[]' COMMENT '最近聊天好友角色id [1,3,5,6]',
  `reader` varchar(500) NOT NULL DEFAULT '[]' COMMENT '未读信息所属的角色id列表[2,1,5,6]',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_friend_chat_log`
--

DROP TABLE IF EXISTS `tb_friend_chat_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_friend_chat_log` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '角色聊天记录主键id',
  `fromid` int(20) NOT NULL COMMENT '聊天发起人id',
  `toid` int(20) NOT NULL COMMENT '聊天接受人id',
  `context` varchar(500) NOT NULL DEFAULT '' COMMENT '聊天内容',
  `times` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '聊天时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_friend_record`
--

DROP TABLE IF EXISTS `tb_friend_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_friend_record` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '记录好友祝福次数表主键id',
  `characterid` int(20) NOT NULL COMMENT '当前好友角色id',
  `count` int(10) NOT NULL COMMENT '当天祝福次数，每天晚上12点服务器自动修改count=0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_gmbug`
--

DROP TABLE IF EXISTS `tb_gmbug`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_gmbug` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'bug记录ID',
  `characterName` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '提交的角色的名称',
  `recorddate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '提交的时间',
  `desc` text COLLATE utf8_bin NOT NULL COMMENT 'bug的内容',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_godhead`
--

DROP TABLE IF EXISTS `tb_godhead`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_godhead` (
  `id` int(11) NOT NULL COMMENT '神格的ID',
  `name` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '神格的名称',
  `desc` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '神格的描述',
  `headtype` int(11) NOT NULL DEFAULT '1' COMMENT '神格的类型',
  `consumption` int(11) NOT NULL DEFAULT '0' COMMENT '激活消耗值',
  `priorityID` int(11) NOT NULL DEFAULT '0' COMMENT '激活前置ID',
  `attributeEffect` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '{}' COMMENT '神格属性效果',
  `triggerEffect` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '神格激活触发效果',
  `levelrequired` int(3) NOT NULL DEFAULT '0' COMMENT '开启神格需求等级',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_godhead_type`
--

DROP TABLE IF EXISTS `tb_godhead_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_godhead_type` (
  `headtype` int(11) NOT NULL COMMENT '神格的类型',
  `typename` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '类型名称',
  `typedes` varchar(255) COLLATE utf8_bin DEFAULT '' COMMENT '类型描述',
  PRIMARY KEY (`headtype`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_gold_consignment`
--

DROP TABLE IF EXISTS `tb_gold_consignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_gold_consignment` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '物品在寄卖行的编号',
  `salemoney` int(20) NOT NULL DEFAULT '0' COMMENT '出售货币数量',
  `saletype` int(20) NOT NULL DEFAULT '0' COMMENT '出售货币类型 1魔钻  2金币',
  `buymoney` int(20) NOT NULL DEFAULT '0' COMMENT '购买货币数量',
  `buytype` int(20) NOT NULL DEFAULT '0' COMMENT '购买货币类型 1魔钻  2金币',
  `operationTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '寄售的时间',
  `adtime` int(10) NOT NULL DEFAULT '1' COMMENT '寄售小时数',
  `characterid` int(20) NOT NULL DEFAULT '0' COMMENT '寄卖者的id',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_gold_consignment_record`
--

DROP TABLE IF EXISTS `tb_gold_consignment_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_gold_consignment_record` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '记录id',
  `goldNum` int(20) NOT NULL DEFAULT '0' COMMENT '金币的数量',
  `characterId` int(20) NOT NULL COMMENT '寄卖人的id',
  `customerId` int(20) NOT NULL COMMENT '购买者的id',
  `coinPrice` int(20) DEFAULT '0' COMMENT '成交的总价',
  `recordData` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '成交的日期',
  `buytype` int(20) NOT NULL DEFAULT '1' COMMENT '1表示寄卖的是钻石  2表示及买的是游戏币',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_guild`
--

DROP TABLE IF EXISTS `tb_guild`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_guild` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '行会id',
  `name` varchar(45) NOT NULL DEFAULT '' COMMENT '行会名称',
  `bugle` varchar(45) DEFAULT '' COMMENT '军号',
  `camp` tinyint(4) NOT NULL DEFAULT '1' COMMENT '军团阵营',
  `guildtype` tinyint(4) NOT NULL DEFAULT '2' COMMENT '军团类型 1系统军团 2玩家创建军团',
  `announcement` varchar(45) DEFAULT '' COMMENT '行会公告',
  `level` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '行会等级',
  `exp` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '行会的经验',
  `emblemLevel` int(10) unsigned NOT NULL DEFAULT '1' COMMENT '军徽等级',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '行会介绍',
  `president` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '会长ID',
  `fundsCount` int(10) unsigned DEFAULT '0' COMMENT '行会资金',
  `materialsCount` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '行会物质数量',
  `memberCount` int(10) unsigned NOT NULL DEFAULT '20' COMMENT '成员人数',
  `createDate` date NOT NULL COMMENT '创建时间',
  `veterans` varchar(50) NOT NULL DEFAULT '' COMMENT '元老组成员（2位，id逗号分隔）',
  `staffOfficers` varchar(50) DEFAULT '' COMMENT '参谋组成员（6位，id逗号分隔）',
  `senators` varchar(255) DEFAULT '' COMMENT '议员组成员（10位，id逗号分隔）',
  `creator` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最初创建者ID',
  `lastmodified` datetime DEFAULT '2011-11-08 14:50:08' COMMENT '上次修改时间',
  `annmodified` datetime NOT NULL DEFAULT '2011-11-08 14:50:08' COMMENT '公告上次修改时间',
  `color` int(10) NOT NULL DEFAULT '13421721' COMMENT '代表颜色',
  `levelupTime` datetime NOT NULL DEFAULT '2011-11-08 14:50:08' COMMENT '军团最后升级的时间',
  `levelrequired` int(10) NOT NULL DEFAULT '0' COMMENT '军团加入所需等级限制',
  PRIMARY KEY (`id`,`annmodified`)
) ENGINE=MyISAM AUTO_INCREMENT=43 DEFAULT CHARSET=utf8 COMMENT='行会';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_guild_app`
--

DROP TABLE IF EXISTS `tb_guild_app`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_guild_app` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '记录的id',
  `guildID` int(20) NOT NULL COMMENT '军团的ID号',
  `applicant` int(20) NOT NULL COMMENT '申请人的ID',
  `appTime` date NOT NULL COMMENT '申请的时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_guild_battle`
--

DROP TABLE IF EXISTS `tb_guild_battle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_guild_battle` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `askCommunity` int(10) unsigned NOT NULL COMMENT '挑战行会ID',
  `answerCommunity` int(10) unsigned NOT NULL COMMENT '应战行会ID',
  `askTime` datetime DEFAULT NULL COMMENT '挑战时间',
  `confirmdTime` datetime DEFAULT NULL COMMENT '接受挑战时间',
  `battlefieldArea` int(10) NOT NULL DEFAULT '0' COMMENT '分配的战场的id',
  `result` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '0:未开始；1:进行中；2:胜利；3:失败',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='行会战';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_guild_character`
--

DROP TABLE IF EXISTS `tb_guild_character`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_guild_character` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `characterId` int(10) unsigned NOT NULL COMMENT '角色ID',
  `guildId` int(10) unsigned NOT NULL COMMENT '行会ID',
  `contribution` int(10) NOT NULL DEFAULT '0' COMMENT '角色行会贡献度',
  `post` int(10) NOT NULL DEFAULT '0' COMMENT '职务 0普通成员1议事2参谋3元老4军团长',
  `joinTime` date NOT NULL COMMENT '入会时间',
  `defaultDonate` int(20) NOT NULL DEFAULT '0' COMMENT '默认捐献的科技',
  `lastDonate` date NOT NULL DEFAULT '2011-11-01' COMMENT '上次捐献的时间',
  `donatetimes` int(10) NOT NULL DEFAULT '0' COMMENT '当日捐献次数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='玩家与行会关系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_guild_guild`
--

DROP TABLE IF EXISTS `tb_guild_guild`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_guild_guild` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `masterCommunity` int(10) unsigned NOT NULL COMMENT '殖民行会ID',
  `slaveCommunity` int(10) unsigned NOT NULL COMMENT '被殖民行会ID',
  `confirmTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '关系形成时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='行会殖民关系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_guild_technology`
--

DROP TABLE IF EXISTS `tb_guild_technology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_guild_technology` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '记录的id',
  `guildId` int(20) NOT NULL COMMENT '行会的id',
  `technology` int(10) NOT NULL DEFAULT '0' COMMENT '科技编号',
  `curSchedule` int(10) DEFAULT '0' COMMENT '科技进度',
  `technologyLevel` int(10) NOT NULL DEFAULT '1' COMMENT '科技等级',
  `updatedTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新的时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_guildlevel_technology`
--

DROP TABLE IF EXISTS `tb_guildlevel_technology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_guildlevel_technology` (
  `guildLevel` int(10) NOT NULL DEFAULT '1' COMMENT '军团的等级',
  `tech_800001` int(10) NOT NULL DEFAULT '0' COMMENT '科技-力量的等级',
  `tech_800002` int(10) NOT NULL DEFAULT '0' COMMENT '科技-敏捷的等级',
  `tech_800003` int(10) NOT NULL DEFAULT '0' COMMENT '科技-智力的等级',
  `tech_800004` int(10) NOT NULL DEFAULT '0' COMMENT '科技-精神的等级',
  `tech_800005` int(10) NOT NULL DEFAULT '0' COMMENT '科技-耐力的等级',
  `tech_800006` int(10) NOT NULL DEFAULT '0' COMMENT '科技-战斗技巧的等级',
  `tech_800007` int(10) NOT NULL DEFAULT '0' COMMENT '科技-魔力精通的等级',
  `tech_800008` int(10) NOT NULL DEFAULT '0' COMMENT '科技-困难挑战的等级',
  `tech_800009` int(10) NOT NULL DEFAULT '0' COMMENT '科技-英雄试炼的等级',
  `tech_800010` int(10) NOT NULL DEFAULT '0' COMMENT '科技-幸运强化的等级',
  PRIMARY KEY (`guildLevel`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_guyong_record`
--

DROP TABLE IF EXISTS `tb_guyong_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_guyong_record` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `characterId` int(20) DEFAULT NULL COMMENT '被雇佣者的ID',
  `chaname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '雇佣者的名称',
  `zyname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '攻打的关卡的名称',
  `zyid` int(20) DEFAULT NULL COMMENT '攻打的战役的ID',
  `battleresult` int(20) DEFAULT NULL COMMENT '战斗结果 1胜利 2失败',
  `coinbound` int(20) DEFAULT NULL COMMENT '银两奖励',
  `huoli` int(20) DEFAULT NULL COMMENT '活力奖励',
  `reocrddate` timestamp NULL DEFAULT NULL COMMENT '雇佣的时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_instance_activation`
--

DROP TABLE IF EXISTS `tb_instance_activation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_instance_activation` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '副本激活表主键Id',
  `characterlevel` int(20) NOT NULL DEFAULT '-1' COMMENT '角色等级限制',
  `guildlevel` int(20) NOT NULL DEFAULT '-1' COMMENT '行会等级限制',
  `successid` int(20) NOT NULL DEFAULT '-1' COMMENT '角色成就id',
  `instanceid` int(20) NOT NULL DEFAULT '-1' COMMENT '已通关的的副本Id',
  `accepttaskid` int(20) NOT NULL DEFAULT '-1' COMMENT '已接受的任务id',
  `finishtaskid` int(20) NOT NULL DEFAULT '-1' COMMENT '已完成的任务Id',
  `itemsid` int(20) NOT NULL DEFAULT '-1' COMMENT '已获得的物品Id',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_instance_close`
--

DROP TABLE IF EXISTS `tb_instance_close`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_instance_close` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '副本关闭条件主键id',
  `attackboss` int(20) NOT NULL DEFAULT '-1' COMMENT '击败指定boss的id',
  `taskid` int(20) NOT NULL DEFAULT '-1' COMMENT '完成特定任务的id',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_instance_colonize`
--

DROP TABLE IF EXISTS `tb_instance_colonize`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_instance_colonize` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '副本殖民信息表主键id',
  `instanceid` int(20) NOT NULL COMMENT '副本(难度最小的副本)id或者城镇id',
  `instancename` varchar(100) DEFAULT '无' COMMENT '城镇或者副本的名字',
  `typeid` int(2) DEFAULT '0' COMMENT '0表示副本殖民 1表示城镇殖民',
  `pid` int(20) DEFAULT '0' COMMENT '领主角色id',
  `pname` varchar(200) DEFAULT '无' COMMENT '领主角色名称',
  `gid` int(20) DEFAULT '0' COMMENT '角色所属军团id',
  `gname` varchar(200) DEFAULT '无' COMMENT '角色所属军团名称',
  `resist` int(20) DEFAULT '0' COMMENT '抵抗次数(成功的抵抗)',
  `days` int(10) DEFAULT '0' COMMENT '殖民天数',
  `suid` int(20) DEFAULT '0' COMMENT '成功占领副本的角色id',
  `suname` varchar(20) DEFAULT '无' COMMENT '成功占领副本的角色名称',
  `enable` int(2) DEFAULT '1' COMMENT '0表示没有启用  1表示启用',
  `clearancecount` int(20) DEFAULT '0' COMMENT '通关次数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=61 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_instance_colonize1`
--

DROP TABLE IF EXISTS `tb_instance_colonize1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_instance_colonize1` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '副本殖民信息表主键id',
  `instanceid` int(20) NOT NULL COMMENT '副本(难度最小的副本)id或者城镇id',
  `instancename` varchar(100) DEFAULT '无' COMMENT '城镇或者副本的名字',
  `typeid` int(2) DEFAULT '0' COMMENT '0表示副本殖民 1表示城镇殖民',
  `pid` int(20) DEFAULT '0' COMMENT '领主角色id',
  `pname` varchar(200) DEFAULT '无' COMMENT '领主角色名称',
  `gid` int(20) DEFAULT '0' COMMENT '角色所属军团id',
  `gname` varchar(200) DEFAULT '无' COMMENT '角色所属军团名称',
  `resist` int(20) DEFAULT '0' COMMENT '抵抗次数(成功的抵抗)',
  `days` int(10) DEFAULT '0' COMMENT '殖民天数',
  `suid` int(20) DEFAULT '0' COMMENT '成功占领副本的角色id',
  `suname` varchar(20) DEFAULT '无' COMMENT '成功占领副本的角色名称',
  `enable` int(2) DEFAULT '1' COMMENT '0表示没有启用  1表示启用',
  `clearancecount` int(20) DEFAULT '0' COMMENT '通关次数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_instance_colonize_challenge`
--

DROP TABLE IF EXISTS `tb_instance_colonize_challenge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_instance_colonize_challenge` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '副本殖民挑战表主键id',
  `instanceid` int(20) NOT NULL COMMENT '副本id',
  `mosterid` int(20) NOT NULL DEFAULT '15001' COMMENT '怪物id',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=350 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_instance_colonize_guerdon`
--

DROP TABLE IF EXISTS `tb_instance_colonize_guerdon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_instance_colonize_guerdon` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '副本殖民奖励表主键id',
  `cid` int(20) NOT NULL COMMENT '角色id',
  `coin` int(20) NOT NULL DEFAULT '0' COMMENT '获得的游戏币数量',
  `times` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '获得奖励时间',
  `typeid` int(20) NOT NULL DEFAULT '0' COMMENT '1副本卫冕奖励 2其他人通过副本时获得奖励',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_instance_colonize_title`
--

DROP TABLE IF EXISTS `tb_instance_colonize_title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_instance_colonize_title` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '殖民连胜称号表主键id',
  `nickname` varchar(100) DEFAULT '' COMMENT '头衔',
  `min` int(20) DEFAULT '0' COMMENT '副本最小连胜次数（包括）',
  `max` int(20) DEFAULT '0' COMMENT '副本最大连胜次数（包括）',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_instance_d`
--

DROP TABLE IF EXISTS `tb_instance_d`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_instance_d` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '副本组队信息表主键id',
  `instanceid` int(20) NOT NULL DEFAULT '0' COMMENT '副本id',
  `dropitem` varchar(300) NOT NULL DEFAULT '' COMMENT '12,34,55,57  掉落物品',
  `moster` varchar(300) NOT NULL DEFAULT '' COMMENT '234,2342,64  副本内存在的怪物',
  `instancename` varchar(200) NOT NULL DEFAULT '' COMMENT '副本名称',
  `context` varchar(500) NOT NULL DEFAULT '' COMMENT '副本内容描述',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=311 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_instance_group`
--

DROP TABLE IF EXISTS `tb_instance_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_instance_group` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '副本组id',
  `csz` int(20) NOT NULL DEFAULT '0' COMMENT '传送阵id',
  `levela` int(20) DEFAULT '-1' COMMENT 'a难度副本id',
  `levelb` int(20) DEFAULT '-1' COMMENT 'b难度副本id',
  `levelc` int(20) DEFAULT '-1' COMMENT 'c难度副本id',
  `price` int(20) NOT NULL DEFAULT '1' COMMENT '单次通关奖励',
  `maxcost` int(20) NOT NULL DEFAULT '100' COMMENT '最高奖励',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5114 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_instance_package`
--

DROP TABLE IF EXISTS `tb_instance_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_instance_package` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) NOT NULL COMMENT '玩家id',
  `itemId` int(11) NOT NULL COMMENT '对应玩家包裹栏中物品id',
  `position` int(11) NOT NULL COMMENT '当前位置',
  `stack` int(11) DEFAULT '1' COMMENT '当前叠加数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_instance_record`
--

DROP TABLE IF EXISTS `tb_instance_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_instance_record` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '副本通关记录主键id',
  `characterid` int(20) NOT NULL DEFAULT '-1' COMMENT '角色id',
  `instanceid` int(20) NOT NULL DEFAULT '-1' COMMENT '副本组id',
  `score` int(20) NOT NULL DEFAULT '-1' COMMENT '副本评分 -1为没有评分 1:一颗星  2两颗星   3三颗星',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1647 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_instance_record_id`
--

DROP TABLE IF EXISTS `tb_instance_record_id`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_instance_record_id` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '副本通关记录主键id',
  `characterid` int(20) NOT NULL DEFAULT '-1' COMMENT '角色id',
  `instanceid` int(20) NOT NULL DEFAULT '-1' COMMENT '副本id',
  `score` int(20) NOT NULL DEFAULT '-1' COMMENT '副本评分 -1为没有评分 1:一颗星  2两颗星   3三颗星',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=16917 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_instanceinfo`
--

DROP TABLE IF EXISTS `tb_instanceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_instanceinfo` (
  `id` int(20) NOT NULL DEFAULT '0' COMMENT '副本id',
  `name` varchar(200) NOT NULL DEFAULT '' COMMENT '副本名称',
  `typeid` int(20) NOT NULL DEFAULT '4' COMMENT '副本类型 1=行会区域  2=行会战区域  3=竞技场、战场 4=副本 5=私人区域',
  `hard` int(20) NOT NULL DEFAULT '1' COMMENT '副本难度 1=普通 2=精英 3=英雄',
  `sceneid` varchar(500) NOT NULL DEFAULT '-1' COMMENT '副本内的所有场景Id',
  `startime` time NOT NULL DEFAULT '00:00:00' COMMENT '副本开始时间',
  `endtime` time NOT NULL DEFAULT '00:00:00' COMMENT '副本结束时间',
  `uplevle` int(20) NOT NULL DEFAULT '-1' COMMENT '进入副本的角色的等级上限',
  `downlevle` int(20) NOT NULL DEFAULT '-1' COMMENT '进入副本的角色的等级下限',
  `props` varchar(200) NOT NULL DEFAULT '' COMMENT '进入副本所需要的特殊物品id',
  `astrictguild` int(20) NOT NULL DEFAULT '1' COMMENT '副本行会等级限制 -1表示没有行会限制 其他表示有行会限制并行会要达到相应等级',
  `pknum` int(20) NOT NULL DEFAULT '-1' COMMENT '副本pk值限制',
  `energy` int(20) NOT NULL DEFAULT '-1' COMMENT '副本活力值限制',
  `teamState` int(20) NOT NULL DEFAULT '1' COMMENT '组队进入限制  1=是否组队均可进入（默认）；2=组队状态方可进入 3=非组队状态方可进入',
  `teammax` int(20) NOT NULL DEFAULT '-1' COMMENT '队伍人数上限',
  `teammin` int(20) NOT NULL DEFAULT '-1' COMMENT '队伍人数下限',
  `carry` int(20) NOT NULL DEFAULT '1' COMMENT '传送进入副本限制 1=可以（默认）2=不可以',
  `closeid` int(20) NOT NULL DEFAULT '-1' COMMENT '触发副本关闭流程的条件',
  `achieveprop` varchar(200) NOT NULL DEFAULT '' COMMENT '在副本结算时出现的奖励道具列表',
  `teamastrict` int(20) NOT NULL DEFAULT '1' COMMENT '进入该地图后能否组队 1=可以（默认） 2=不可以',
  `noprop` varchar(200) NOT NULL DEFAULT '' COMMENT '副本道具限制 声明在副本中禁用的道具 (*,*)',
  `backCity` int(20) NOT NULL DEFAULT '1' COMMENT '回城限制 该地图中是否允许使用回城技能和道具 1=可以（默认） 2=不可以',
  `annal` int(20) NOT NULL DEFAULT '1' COMMENT '路点记录限制 该地图中是否允许使用路点记录道具 1=可以（默认） 2=不可以',
  `bargain` int(20) NOT NULL DEFAULT '1' COMMENT '该地图当中是否允许玩家之间进行交易 1=可以（默认） 2=不可以',
  `duel` int(20) NOT NULL DEFAULT '1' COMMENT '该地图当中是否允许玩家之间进行决斗 1=可以（默认） 2=不可以',
  `autoway` int(20) NOT NULL DEFAULT '1' COMMENT '该地图当中是否允许使用自动寻路功能 1=可以（默认） 2=不可以',
  `insceneid` int(20) NOT NULL DEFAULT '1000' COMMENT '玩家进入副本时所在的初始场景的ID',
  `outsceneid` int(20) NOT NULL DEFAULT '1000' COMMENT '玩家从副本登出后到达的地图的ID',
  `activateid` int(20) NOT NULL DEFAULT '-1' COMMENT '激活副本的条件Id',
  `numbers` int(20) NOT NULL DEFAULT '1' COMMENT '副本建议人数',
  `dropoutid` int(20) NOT NULL DEFAULT '-1' COMMENT '副本掉落主键id',
  `areasceneid` int(20) NOT NULL DEFAULT '-1' COMMENT '副本所在区域的场景id',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_item`
--

DROP TABLE IF EXISTS `tb_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_item` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `characterId` int(20) NOT NULL COMMENT '玩家id',
  `itemTemplateId` int(20) DEFAULT '-1' COMMENT '物品模版id',
  `isBound` int(4) DEFAULT '0' COMMENT '备装绑定状态:0:未绑定,1:已绑定',
  `accesstime` datetime DEFAULT NULL COMMENT '物品获取的时间',
  `durability` int(11) DEFAULT '-1' COMMENT '装备的耐久 -1 表示无耐久限制',
  `identification` tinyint(4) DEFAULT '1' COMMENT '是否已辨识  0:未辨识 1:辨识',
  `stack` tinyint(4) DEFAULT '1' COMMENT '物品的堆叠数',
  `strengthen` tinyint(3) NOT NULL DEFAULT '0' COMMENT '物品强化等级',
  `workout` tinyint(10) DEFAULT '0' COMMENT '装备祭炼值 也可以叫成长值',
  `slot_1` int(10) NOT NULL DEFAULT '0' COMMENT '插槽1',
  `slot_2` int(10) NOT NULL DEFAULT '0' COMMENT '插槽2',
  `slot_3` int(10) NOT NULL DEFAULT '0' COMMENT '插槽3',
  `slot_4` int(10) NOT NULL DEFAULT '0' COMMENT '插槽4',
  `exp` int(10) NOT NULL DEFAULT '0' COMMENT '物品当前的经验值',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9118 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_item_compound`
--

DROP TABLE IF EXISTS `tb_item_compound`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_item_compound` (
  `index` int(10) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `itemId` int(11) NOT NULL COMMENT '要合成物品的ID',
  `name` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '配方的名称',
  `type` tinyint(4) NOT NULL DEFAULT '1' COMMENT '合成的类型 1装备 2宝石',
  `level` int(11) NOT NULL DEFAULT '10' COMMENT '合成等级分类',
  `m1_item` int(11) NOT NULL COMMENT '材料1的ID',
  `m1_cnt` int(11) NOT NULL COMMENT '材料1的数量',
  `m2_item` int(11) NOT NULL COMMENT '材料2的ID',
  `m2_cnt` int(11) NOT NULL COMMENT '材料2的数量',
  `coinrequired` int(11) NOT NULL DEFAULT '0' COMMENT '合成需要消耗的金币数量',
  PRIMARY KEY (`index`,`itemId`)
) ENGINE=MyISAM AUTO_INCREMENT=392 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_item_consignment`
--

DROP TABLE IF EXISTS `tb_item_consignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_item_consignment` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '物品在寄卖行的编号',
  `itemId` int(20) NOT NULL DEFAULT '0' COMMENT '物品的id',
  `characterId` int(20) NOT NULL DEFAULT '0' COMMENT '寄卖者的id',
  `coinnum` int(20) NOT NULL DEFAULT '0' COMMENT '物品出售的货币数量',
  `cointype` int(20) NOT NULL DEFAULT '0' COMMENT '物品出售的货币类型 1魔钻  2金币',
  `operationTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '物品寄卖的时间',
  `addtime` int(10) NOT NULL DEFAULT '1' COMMENT '寄卖多少小时',
  `stack` int(11) DEFAULT '1' COMMENT '物品的层叠数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_item_gem`
--

DROP TABLE IF EXISTS `tb_item_gem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_item_gem` (
  `gemId` int(11) NOT NULL COMMENT '宝石的ID（与物品ID对应）',
  `effectdesc` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '效果描述',
  `effect` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '{}' COMMENT '效果公式',
  `level` int(11) NOT NULL DEFAULT '1' COMMENT '宝石的等级',
  `type` int(11) NOT NULL DEFAULT '1' COMMENT '宝石的类型'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_item_template`
--

DROP TABLE IF EXISTS `tb_item_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_item_template` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '物品的模板ID',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '物品的描述',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '物品的名称',
  `icon` int(20) NOT NULL DEFAULT '0' COMMENT '物品的图标',
  `type` int(20) NOT NULL DEFAULT '1' COMMENT '物品类型',
  `itemPage` int(20) NOT NULL DEFAULT '1' COMMENT '在包裹中的分页编号 1装备 2宝石 3道具',
  `levelRequire` tinyint(4) NOT NULL DEFAULT '1' COMMENT '物品的等级限制',
  `maxstack` tinyint(4) NOT NULL DEFAULT '1' COMMENT '最大堆叠数',
  `useType` tinyint(4) NOT NULL DEFAULT '1' COMMENT '使用类型 1可使用 2不可使用',
  `baseQuality` tinyint(4) NOT NULL DEFAULT '1' COMMENT '基础品质 1灰 2白 3绿 4蓝 5紫 6橙 7红 ',
  `script` varchar(1024) NOT NULL DEFAULT '' COMMENT '使用效果',
  `canInjection` tinyint(4) NOT NULL DEFAULT '1' COMMENT '可否注魂 1不可以 2可以',
  `baseAttack` int(20) NOT NULL DEFAULT '-1' COMMENT '基础攻击力',
  `attackType` tinyint(4) NOT NULL DEFAULT '-1' COMMENT '攻击类型 1物理攻击 2魔法攻击',
  `baseSpeed` int(10) NOT NULL DEFAULT '-1' COMMENT '武器速度',
  `baseStr` int(10) NOT NULL DEFAULT '-1' COMMENT '基础力量',
  `baseVit` int(10) NOT NULL DEFAULT '-1' COMMENT '基础耐力（体力）',
  `baseDex` int(10) NOT NULL DEFAULT '-1' COMMENT '基础敏捷',
  `baseWis` int(10) NOT NULL DEFAULT '-1' COMMENT '基础智力',
  `basePhysicalAttack` int(10) NOT NULL DEFAULT '-1' COMMENT '基础物理攻击',
  `baseMagicAttack` int(10) NOT NULL DEFAULT '-1' COMMENT '基础魔法攻击',
  `basePhysicalDefense` int(10) NOT NULL DEFAULT '-1' COMMENT '基础物理防御',
  `baseMagicDefense` int(10) NOT NULL DEFAULT '-1' COMMENT '基础魔法防御',
  `baseHpAdditional` int(10) NOT NULL DEFAULT '-1' COMMENT '基础hp追加',
  `baseMpAdditional` int(10) NOT NULL DEFAULT '-1' COMMENT '基础mp追加',
  `baseHitAdditional` int(10) NOT NULL DEFAULT '-1' COMMENT '基础命中追加',
  `baseCritAdditional` int(10) NOT NULL DEFAULT '-1' COMMENT '基础暴击追加',
  `baseBlockAdditional` int(10) NOT NULL DEFAULT '-1' COMMENT '基础抗暴追加',
  `baseDodgeAdditional` int(10) NOT NULL DEFAULT '-1' COMMENT '基础闪避追加',
  `baseSpeedAdditional` int(10) NOT NULL DEFAULT '-1' COMMENT '基础速度追加',
  `baseEffects` varchar(255) NOT NULL DEFAULT '' COMMENT '基础特效',
  `bodyType` tinyint(4) NOT NULL DEFAULT '-1' COMMENT '装备位置 0=衣服 1=裤子 2=头盔 3=手套 4=靴子 5=护肩 6=项链 7=戒指 8=主武器 9=副武器 10=双手',
  `buyingRateCoin` int(10) NOT NULL DEFAULT '0' COMMENT '铜币价格',
  `baseDefense` int(10) NOT NULL DEFAULT '-1' COMMENT '基础防御',
  `suiteId` int(10) NOT NULL DEFAULT '0' COMMENT '套装的ID',
  `compound` int(10) NOT NULL DEFAULT '10150001' COMMENT '可以合成的物品的ID',
  `comprice` int(10) NOT NULL DEFAULT '100' COMMENT '物品合成需要的价格',
  `ownerexp` int(10) NOT NULL DEFAULT '30' COMMENT '初始经验值',
  `maxexp` int(10) NOT NULL DEFAULT '100' COMMENT '成长所需的经验',
  `growTemp` int(10) NOT NULL DEFAULT '10150001' COMMENT '成长的物品的模版ID',
  `skill` int(10) DEFAULT '0' COMMENT '附加技能的ID',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=55000032 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_itemdorp_backup`
--

DROP TABLE IF EXISTS `tb_itemdorp_backup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_itemdorp_backup` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `characterId` int(20) NOT NULL COMMENT '玩家id',
  `itemTemplateId` int(20) DEFAULT '-1' COMMENT '物品模版id',
  `isBound` int(4) DEFAULT '0' COMMENT '备装绑定状态:0:未绑定,1:已绑定',
  `accesstime` datetime DEFAULT NULL COMMENT '物品获取的时间',
  `durability` int(11) DEFAULT '-1' COMMENT '装备的耐久 -1 表示无耐久限制',
  `identification` tinyint(4) DEFAULT '1' COMMENT '是否已辨识  0:未辨识 1:辨识',
  `stack` tinyint(4) DEFAULT '1' COMMENT '物品的堆叠数',
  `strengthen` int(4) DEFAULT '0',
  `workout` int(4) DEFAULT '0',
  `dropTime` timestamp NULL DEFAULT NULL COMMENT '物品删除的时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_language`
--

DROP TABLE IF EXISTS `tb_language`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_language` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '语言翻译表',
  `content` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '语言',
  `txt` varchar(500) COLLATE utf8_unicode_ci DEFAULT 's' COMMENT '中文',
  `typeid` int(20) DEFAULT '1' COMMENT '类型  tb_language_type表中的主键id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=689 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci CHECKSUM=1 DELAY_KEY_WRITE=1 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_language_login`
--

DROP TABLE IF EXISTS `tb_language_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_language_login` (
  `tag` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT '字符串的索引',
  `content` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '字符串内容',
  `desc` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '描述',
  PRIMARY KEY (`tag`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_language_type`
--

DROP TABLE IF EXISTS `tb_language_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_language_type` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `typename` varchar(20) DEFAULT NULL COMMENT '类型名称',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_levelmail`
--

DROP TABLE IF EXISTS `tb_levelmail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_levelmail` (
  `level` int(5) NOT NULL COMMENT '等级',
  `title` varchar(255) DEFAULT '' COMMENT '邮件标题',
  `content` varchar(255) NOT NULL DEFAULT '' COMMENT '邮件内容',
  PRIMARY KEY (`level`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_libao`
--

DROP TABLE IF EXISTS `tb_libao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_libao` (
  `id` int(10) unsigned NOT NULL COMMENT '礼包的ID',
  `name` int(10) NOT NULL COMMENT '礼包的名称',
  `coinbound` int(10) NOT NULL DEFAULT '0' COMMENT '金币奖励',
  `goldbound` int(10) NOT NULL DEFAULT '0' COMMENT '钻奖励',
  `energybound` int(10) NOT NULL DEFAULT '0' COMMENT '体力奖励',
  `itembound` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '物品奖励',
  `awarddes` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '奖励的描述'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_mail`
--

DROP TABLE IF EXISTS `tb_mail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_mail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT '' COMMENT '邮件标题',
  `senderId` int(11) DEFAULT '-1' COMMENT '发送邮件的角色ID  当为-1时,将认为是一封由系统产生的邮件,将由type字段提供支持 = -1',
  `sender` varchar(255) NOT NULL DEFAULT '' COMMENT '发送者的名称',
  `receiverId` int(11) DEFAULT NULL COMMENT '接受人id',
  `type` int(11) DEFAULT '1' COMMENT '邮件的类型（0.系统信函  1.玩家信函',
  `content` varchar(255) DEFAULT '' COMMENT '邮件的内容',
  `isReaded` tinyint(4) DEFAULT '0' COMMENT '是否已经读=0',
  `isSaved` tinyint(4) DEFAULT '0' COMMENT '是否保存',
  `sendTime` datetime NOT NULL DEFAULT '2011-08-10 14:57:49' COMMENT '发送时间',
  `coinContains` int(20) DEFAULT '0' COMMENT '包含的游戏币',
  `goldContains` int(20) DEFAULT '0' COMMENT '包含的金币',
  `couponContains` int(20) DEFAULT '0' COMMENT '邮件中包含的礼券',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2355 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_mail_package`
--

DROP TABLE IF EXISTS `tb_mail_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_mail_package` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `mailId` int(20) NOT NULL COMMENT '邮件的id',
  `itemId` int(20) DEFAULT NULL COMMENT '物品的id',
  `position` int(20) DEFAULT NULL COMMENT '物品在邮件包裹中的位置',
  `stack` tinyint(4) NOT NULL DEFAULT '1' COMMENT '物品的叠加层数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_mall_item`
--

DROP TABLE IF EXISTS `tb_mall_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_mall_item` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `tag` int(20) NOT NULL DEFAULT '0' COMMENT '标签类别 0其他 1强化  2宠物',
  `templateid` int(20) NOT NULL DEFAULT '0' COMMENT '商品模板id',
  `promotion` int(20) NOT NULL DEFAULT '0' COMMENT '是否是热卖商品 0普通商品  1热卖商品 ',
  `count` int(20) NOT NULL DEFAULT '1' COMMENT '堆叠的数量',
  `gold` int(20) NOT NULL DEFAULT '10' COMMENT '魔钻价格  商品的人民币价格 默认为0(无)',
  `coupon` int(20) NOT NULL DEFAULT '0' COMMENT '绑定魔钻价格  商品的礼券价格 默认为0(无)',
  `restrict` int(20) NOT NULL DEFAULT '200' COMMENT '购买上限(针对用户)',
  `cx` int(20) NOT NULL DEFAULT '0' COMMENT '商品的促销价格',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_mall_log`
--

DROP TABLE IF EXISTS `tb_mall_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_mall_log` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '主键Id 商城交易记录',
  `characterid` int(20) NOT NULL DEFAULT '-1' COMMENT '角色Id',
  `item_templateid` int(20) NOT NULL DEFAULT '-1' COMMENT '物品模板Id',
  `counts` int(20) NOT NULL DEFAULT '1' COMMENT '物品数量',
  `shopingtime` datetime NOT NULL DEFAULT '1000-01-01 01:00:00' COMMENT '购买时间',
  `gold` int(20) NOT NULL DEFAULT '-1' COMMENT '花费的魔钻',
  `coupon` int(20) NOT NULL DEFAULT '-1' COMMENT '花费的魔晶',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_mall_restrict`
--

DROP TABLE IF EXISTS `tb_mall_restrict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_mall_restrict` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '主键Id',
  `characterid` int(20) NOT NULL DEFAULT '-1' COMMENT '角色Id',
  `itemid` int(20) NOT NULL DEFAULT '-1' COMMENT '商城物品Id',
  `counts` int(20) NOT NULL DEFAULT '1' COMMENT '已经购买的数量',
  `firsttime` datetime NOT NULL COMMENT '第一次购买时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_map`
--

DROP TABLE IF EXISTS `tb_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_map` (
  `id` int(10) NOT NULL COMMENT '地图的id',
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT '地图的名称',
  `country` tinyint(4) NOT NULL DEFAULT '1' COMMENT '地图所属国家 1魏国 2蜀国 3吴国',
  `level` int(10) NOT NULL DEFAULT '1' COMMENT '进入的最低等级限制',
  `member_cnt` int(10) NOT NULL DEFAULT '500' COMMENT '场景最大人数限制',
  `height` int(10) NOT NULL DEFAULT '2000' COMMENT '地图的高度',
  `width` int(10) NOT NULL DEFAULT '2000' COMMENT '地图的宽度',
  `resourceid` int(10) NOT NULL DEFAULT '1000' COMMENT '地图的资源',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_map_monster`
--

DROP TABLE IF EXISTS `tb_map_monster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_map_monster` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `monster` int(10) DEFAULT NULL COMMENT '怪物的模型ID',
  `position_x` int(10) DEFAULT NULL COMMENT '怪物所在的X坐标',
  `position_y` int(10) DEFAULT NULL COMMENT '怪物所在的Y坐标',
  `map_id` int(10) DEFAULT NULL COMMENT '怪物所在的场景的ID',
  `rule` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '碰撞怪后战斗的怪物配置',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10018 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_matrix`
--

DROP TABLE IF EXISTS `tb_matrix`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_matrix` (
  `id` int(20) NOT NULL COMMENT '阵法的ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '阵法的名称',
  `levelrequired` int(10) NOT NULL DEFAULT '1' COMMENT '阵法开启的需求等级',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '阵法的描述',
  `frontEye_1` varchar(255) NOT NULL DEFAULT '' COMMENT '阵眼1的信息',
  `frontEye_2` varchar(255) NOT NULL DEFAULT '' COMMENT '阵眼2的信息',
  `frontEye_3` varchar(255) NOT NULL DEFAULT '' COMMENT '阵眼3的信息',
  `frontEye_4` varchar(255) NOT NULL DEFAULT '' COMMENT '阵眼4的信息',
  `frontEye_5` varchar(255) NOT NULL DEFAULT '' COMMENT '阵眼5的信息',
  `effect_1_consumeType` int(20) NOT NULL DEFAULT '0' COMMENT '效果1的消耗类型',
  `effect_1_consumeNum` int(20) NOT NULL DEFAULT '0' COMMENT '效果1的消耗数目',
  `effect_1_increasePercen` int(20) NOT NULL DEFAULT '0' COMMENT '效果1增强的百分比',
  `effect_2_consumeType` int(20) NOT NULL DEFAULT '0' COMMENT '效果2的消耗类型',
  `effect_2_consumeNum` int(20) NOT NULL DEFAULT '0' COMMENT '效果2的消耗数目',
  `effect_2_increasePercen` int(20) NOT NULL DEFAULT '0' COMMENT '效果2增强的百分比',
  `effect_3_consumeType` int(20) NOT NULL DEFAULT '0' COMMENT '效果3的消耗类型',
  `effect_3_consumeNum` int(20) NOT NULL DEFAULT '0' COMMENT '效果3的消耗数目',
  `effect_3_increasePercen` int(20) NOT NULL DEFAULT '0' COMMENT '效果3增强的百分比',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_mining`
--

DROP TABLE IF EXISTS `tb_mining`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_mining` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `characterId` int(10) NOT NULL DEFAULT '0' COMMENT '角色的ID',
  `miningType` int(10) NOT NULL DEFAULT '0' COMMENT '挖掘类型 1：8小时；2:12小时；3:16小时；4:24小时',
  `starttime` datetime NOT NULL COMMENT '开始时间',
  `miningmode` int(10) NOT NULL DEFAULT '1' COMMENT '挖掘模式',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=274 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_monster`
--

DROP TABLE IF EXISTS `tb_monster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_monster` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '怪物表id',
  `viptype` int(20) NOT NULL DEFAULT '1' COMMENT '怪物类型 10 = BOSS          1 = 人型             2 = 不死         3 = 精灵             4 = 龙族       5 = 恶魔              6 = 巨型       7 = 稀有       8 = 精英        9 = 其他 ',
  `nickname` varchar(50) NOT NULL DEFAULT '未知魔兽' COMMENT '怪物名称',
  `descript` varchar(255) DEFAULT '吼。。。',
  `difficulty` int(10) DEFAULT '1' COMMENT '怪物的难度',
  `icon` int(10) DEFAULT '0' COMMENT '怪物的图标',
  `type` int(10) DEFAULT '0' COMMENT '怪物的图标类型',
  `hp` int(20) NOT NULL DEFAULT '1' COMMENT '血量',
  `mp` int(20) NOT NULL DEFAULT '1' COMMENT '魔力值',
  `PhysicalAttack` int(20) NOT NULL DEFAULT '1' COMMENT '物理攻击',
  `MagicAttack` int(20) NOT NULL DEFAULT '1' COMMENT '魔法攻击',
  `PhysicalDefense` int(20) NOT NULL DEFAULT '1' COMMENT '物理防御',
  `MagicDefense` int(20) NOT NULL DEFAULT '1' COMMENT '魔法防御',
  `Hit` int(20) NOT NULL DEFAULT '1' COMMENT '命中',
  `Dodge` int(20) NOT NULL DEFAULT '1' COMMENT '闪避',
  `Speed` int(20) NOT NULL DEFAULT '1' COMMENT '速度',
  `Force` int(20) NOT NULL DEFAULT '1' COMMENT '暴击',
  `ordSkill` int(20) DEFAULT '610101' COMMENT '普通攻击',
  `skill` varchar(200) NOT NULL DEFAULT '1' COMMENT '技能id  1,3,5,6,7',
  `dropoutid` int(20) NOT NULL DEFAULT '1' COMMENT '掉落表主键id',
  `speak` int(20) NOT NULL DEFAULT '1' COMMENT '喊话id',
  `level` int(20) NOT NULL DEFAULT '1' COMMENT '怪物等级',
  `moveable` int(1) NOT NULL DEFAULT '1' COMMENT '怪物是否可移动 0 不可移动 1可移动',
  `resourceid` int(20) NOT NULL DEFAULT '1' COMMENT '怪物的资源',
  `expbound` int(10) NOT NULL DEFAULT '100' COMMENT '杀死怪物后的经验奖励',
  PRIMARY KEY (`id`,`dropoutid`)
) ENGINE=InnoDB AUTO_INCREMENT=731065 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_namepool`
--

DROP TABLE IF EXISTS `tb_namepool`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_namepool` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '随机名称的Id',
  `name` varchar(50) DEFAULT NULL COMMENT '随机的名称',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9762 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_nobility`
--

DROP TABLE IF EXISTS `tb_nobility`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_nobility` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '爵位表主键id',
  `levels` int(20) DEFAULT '1' COMMENT '爵位升级顺序',
  `names` varchar(200) DEFAULT NULL COMMENT '爵位名称',
  `prestige` int(20) DEFAULT NULL COMMENT '需要消耗X威望',
  `attribute` varchar(1000) DEFAULT NULL COMMENT '获得的收益 格式{''Str'':20,''Dex'':20}  (力量-Str 敏捷-Dex)',
  `petplayer` int(20) DEFAULT NULL COMMENT '宠物出战数量',
  `petcarry` int(20) DEFAULT NULL COMMENT '宠物携带数量',
  `f1` varchar(100) DEFAULT NULL COMMENT '贡献物品1[物品id,物品名称,物品数量，获得贡献值数量]',
  `f2` varchar(100) DEFAULT NULL COMMENT '贡献物品1',
  `f3` varchar(100) DEFAULT NULL COMMENT '贡献物品1',
  `f4` varchar(100) DEFAULT NULL COMMENT '贡献物品1',
  `f5` varchar(100) DEFAULT NULL COMMENT '贡献物品1',
  `f6` varchar(100) DEFAULT NULL COMMENT '贡献物品1',
  `coin` int(20) DEFAULT '0' COMMENT '通过俸禄获得的金币数量',
  `morale` int(20) DEFAULT '0' COMMENT '通过俸禄获得的斗气数量',
  `dengji` int(20) DEFAULT '1' COMMENT '激活官爵的限制等级',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_nobility_astrict`
--

DROP TABLE IF EXISTS `tb_nobility_astrict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_nobility_astrict` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '爵位领取俸禄记录 每天只能领取一次',
  `pid` int(20) DEFAULT NULL COMMENT '角色id',
  `istrue` int(2) DEFAULT '-1' COMMENT '今天是否可以领取俸禄 -1不可以领取   1可以领取',
  `isgx` varchar(30) DEFAULT '[]' COMMENT '上交的物品[1,3,5]代表 f1 f2 f3',
  `counts` int(20) DEFAULT '1' COMMENT '上交钻石次数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=288 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_nobility_contribution`
--

DROP TABLE IF EXISTS `tb_nobility_contribution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_nobility_contribution` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '爵位贡献钻次数记录',
  `pid` int(20) DEFAULT NULL COMMENT '角色id',
  `counts` int(10) DEFAULT NULL COMMENT '次数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_nobility_history`
--

DROP TABLE IF EXISTS `tb_nobility_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_nobility_history` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '封爵历史 nobility_history',
  `pid` int(20) DEFAULT NULL COMMENT '角色id',
  `context` varchar(500) DEFAULT NULL COMMENT '内容',
  `ctime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '时间',
  `levels` int(10) DEFAULT '0' COMMENT '爵位等级',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=138 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_novice_award`
--

DROP TABLE IF EXISTS `tb_novice_award`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_novice_award` (
  `step` int(10) NOT NULL DEFAULT '1' COMMENT '新手奖励步骤',
  `totaltime` int(10) NOT NULL DEFAULT '0' COMMENT '奖励等待时间',
  `item` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '奖励物品的id  格式 (物品ID,数量)，多个逗号分割',
  `coin` int(10) NOT NULL DEFAULT '0' COMMENT '奖励金币的数量',
  `gold` int(10) NOT NULL DEFAULT '0' COMMENT '奖励钻的数量',
  `energy` int(10) NOT NULL DEFAULT '0' COMMENT '奖励体力的数量',
  `rewardDes` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '奖励的描述',
  PRIMARY KEY (`step`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_npc`
--

DROP TABLE IF EXISTS `tb_npc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_npc` (
  `id` int(20) NOT NULL COMMENT 'npc的id',
  `name` varchar(100) NOT NULL DEFAULT '城管' COMMENT 'npc的名称',
  `dialog` varchar(255) NOT NULL DEFAULT '这是一个神奇的世界' COMMENT 'npc的对话',
  `resourceid` int(10) NOT NULL DEFAULT '100001' COMMENT 'npc的资源类型',
  `sceneId` int(10) NOT NULL DEFAULT '1000' COMMENT 'npc所在的场景',
  `position_X` int(10) NOT NULL DEFAULT '500' COMMENT '角色的X坐标',
  `position_Y` int(10) NOT NULL DEFAULT '800' COMMENT '角色的Y坐标',
  `featureType` int(10) NOT NULL DEFAULT '0' COMMENT '功能类型 0无功能',
  `task_related` varchar(100) NOT NULL DEFAULT '' COMMENT '任务相关',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_npc_shop`
--

DROP TABLE IF EXISTS `tb_npc_shop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_npc_shop` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '商店物品配置记录id',
  `item` int(20) NOT NULL COMMENT '商品的id',
  `coinPrice` int(20) NOT NULL COMMENT '商品的价格',
  `npcId` int(20) NOT NULL COMMENT '商店npc的id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20030114 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_online_min`
--

DROP TABLE IF EXISTS `tb_online_min`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_online_min` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `olinecnt` int(10) NOT NULL COMMENT '当前在线人数',
  `nowtime` datetime NOT NULL COMMENT '当前时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=56789 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_package`
--

DROP TABLE IF EXISTS `tb_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_package` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) NOT NULL COMMENT '玩家id',
  `itemId` int(11) NOT NULL COMMENT '对应玩家包裹栏中物品id',
  `position` int(11) NOT NULL COMMENT '当前位置',
  `stack` int(11) DEFAULT '1' COMMENT '当前叠加数',
  `category` tinyint(4) DEFAULT '1' COMMENT '分类在包裹中的分类 1道具分页 2任务分页',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=18010 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_pet`
--

DROP TABLE IF EXISTS `tb_pet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_pet` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '宠物的ID',
  `ownerID` int(10) NOT NULL DEFAULT '0' COMMENT '拥有者的ID，角色的ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '宠物的名称',
  `templateID` int(10) NOT NULL DEFAULT '0' COMMENT '宠物的模板ID即怪物的模板ID',
  `level` int(10) NOT NULL DEFAULT '1' COMMENT '宠物的当前等级',
  `exp` int(10) NOT NULL DEFAULT '0' COMMENT '宠物的当前经验',
  `hp` int(10) NOT NULL DEFAULT '100' COMMENT '宠物的当前血量',
  `StrGrowth` int(10) NOT NULL DEFAULT '0' COMMENT '宠物的力量成长',
  `WisGrowth` int(10) NOT NULL DEFAULT '0' COMMENT '宠物的智力成长',
  `VitGrowth` int(10) NOT NULL DEFAULT '0' COMMENT '宠物的耐力成长',
  `DexGrowth` int(10) NOT NULL DEFAULT '0' COMMENT '宠物的敏捷成长',
  `showed` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否展示',
  `chuancheng` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否传承过',
  `_chuancheng` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否被传承过',
  `energy` int(10) NOT NULL DEFAULT '0' COMMENT '宠物当前的能量',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3000023 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_pet_experience`
--

DROP TABLE IF EXISTS `tb_pet_experience`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_pet_experience` (
  `level` int(10) NOT NULL AUTO_INCREMENT,
  `ExpRequired` bigint(40) DEFAULT '0' COMMENT '等级升级所需经验',
  `ExpSecProduce` int(20) DEFAULT '0' COMMENT '等级经验秒产',
  PRIMARY KEY (`level`)
) ENGINE=MyISAM AUTO_INCREMENT=121 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_pet_growth`
--

DROP TABLE IF EXISTS `tb_pet_growth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_pet_growth` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '配置的ID',
  `pettype` int(10) NOT NULL DEFAULT '1' COMMENT '宠物的类型',
  `quality` int(10) NOT NULL DEFAULT '0' COMMENT '宠物的基础品质',
  `StrGrowth` int(10) NOT NULL DEFAULT '1000' COMMENT '宠物的力量成长上限',
  `WisGrowth` int(10) NOT NULL DEFAULT '1000' COMMENT '宠物的智力成长上限',
  `DexGrowth` int(10) NOT NULL DEFAULT '1000' COMMENT '宠物的敏捷成长上限',
  `VitGrowth` int(10) NOT NULL DEFAULT '1000' COMMENT '宠物的体力成长上限',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_pet_shop`
--

DROP TABLE IF EXISTS `tb_pet_shop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_pet_shop` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '宠物商店记录表',
  `pid` int(20) DEFAULT NULL COMMENT '角色id',
  `shop1` varchar(200) DEFAULT '[]' COMMENT '商店1中的4个宠物模板id列表',
  `shop2` varchar(200) DEFAULT '[]' COMMENT '商店2中的4个宠物模板id列表',
  `shop3` varchar(200) DEFAULT '[]' COMMENT '商店3中的4个宠物模板id列表',
  `ctime` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '冷却开始时间',
  `counts` int(20) DEFAULT NULL COMMENT '冷却持续时间',
  `ioption` int(2) DEFAULT NULL COMMENT '消费提示打开状态  1开启消费提示  -1 关闭消费提示',
  `xy` int(20) DEFAULT NULL COMMENT '幸运值',
  `cs` int(5) DEFAULT NULL COMMENT '剩余免费刷新次数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=481 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_pet_shop_configure`
--

DROP TABLE IF EXISTS `tb_pet_shop_configure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_pet_shop_configure` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '宠物商店宠物组合推荐表',
  `typeid` int(20) DEFAULT NULL COMMENT '类型id',
  `fashi` varchar(200) DEFAULT '[]' COMMENT '法师的四个宠物组合推荐[宠物模板id,宠物模板id,宠物模板id,宠物模板id]',
  `zhanshi` varchar(200) DEFAULT '[]' COMMENT '战士的四个宠物组合推荐[宠物模板id,宠物模板id,宠物模板id,宠物模板id]',
  `youxia` varchar(200) DEFAULT '[]' COMMENT '游侠的四个宠物组合推荐[宠物模板id,宠物模板id,宠物模板id,宠物模板id]',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_pet_template`
--

DROP TABLE IF EXISTS `tb_pet_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_pet_template` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '宠物的模板ID',
  `nickname` varchar(50) NOT NULL DEFAULT '未知魔兽' COMMENT '宠物的名称',
  `descript` varchar(255) NOT NULL DEFAULT '吼。。。' COMMENT '宠物的描述',
  `icon` int(10) NOT NULL DEFAULT '0' COMMENT '怪物的图标',
  `type` int(10) NOT NULL DEFAULT '0' COMMENT '怪物的图标类型',
  `resourceid` int(10) NOT NULL DEFAULT '0' COMMENT '怪物的资源',
  `attrType` int(10) NOT NULL DEFAULT '0' COMMENT '宠物属性类型',
  `ordSkill` int(10) NOT NULL DEFAULT '610101' COMMENT '普通攻击',
  `skill` int(10) NOT NULL DEFAULT '0' COMMENT '宠物的技能',
  `baseQuality` int(10) NOT NULL DEFAULT '0' COMMENT '宠物的基础资质等级  1=普通（绿）2=优秀（蓝）3=精良（紫） 4=史诗（金）5=传说（橙）6=逆天（红）',
  `StrGrowth` int(10) NOT NULL DEFAULT '0' COMMENT '宠物的力量成长',
  `WisGrowth` int(10) NOT NULL DEFAULT '0' COMMENT '宠物的智力成长',
  `VitGrowth` int(10) NOT NULL DEFAULT '0' COMMENT '宠物的耐力成长',
  `DexGrowth` int(10) NOT NULL DEFAULT '0' COMMENT '宠物的敏捷成长',
  `level` int(10) NOT NULL DEFAULT '1' COMMENT '宠物的能力等级 等级越高说明宠物越厉害',
  `coin` int(20) NOT NULL DEFAULT '0' COMMENT '雇佣的时候需要花费的金币数量',
  `xy` int(20) NOT NULL DEFAULT '0' COMMENT '雇佣的时候需要花费的幸运值',
  `soulrequired` int(10) NOT NULL DEFAULT '0' COMMENT '所需精魄的ID',
  `soulcount` int(10) NOT NULL DEFAULT '0' COMMENT '所需精魄的数量',
  `growpet` int(10) NOT NULL DEFAULT '15008' COMMENT '武将成长后的模版ID',
  `energy` int(10) NOT NULL DEFAULT '30' COMMENT '武将初始能提供的能量',
  `maxenergy` int(10) NOT NULL DEFAULT '150' COMMENT '武将成长所需的能量',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=15229 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_pet_training`
--

DROP TABLE IF EXISTS `tb_pet_training`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_pet_training` (
  `quality` int(10) NOT NULL AUTO_INCREMENT COMMENT '宠物的品质',
  `down_1` int(10) NOT NULL DEFAULT '0' COMMENT '培养增长下限',
  `up_1` int(10) NOT NULL DEFAULT '0' COMMENT '培养增长上限',
  `down_2` int(10) NOT NULL DEFAULT '0' COMMENT '培养增长下限',
  `up_2` int(10) NOT NULL DEFAULT '0' COMMENT '培养增长上限',
  `down_3` int(10) NOT NULL DEFAULT '0' COMMENT '培养增长下限',
  `up_3` int(10) NOT NULL DEFAULT '0' COMMENT '培养增长上限',
  `down_4` int(10) NOT NULL DEFAULT '0' COMMENT '培养增长下限',
  `up_4` int(10) NOT NULL DEFAULT '0' COMMENT '培养增长上限',
  PRIMARY KEY (`quality`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_ping`
--

DROP TABLE IF EXISTS `tb_ping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_ping` (
  `id` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_portals`
--

DROP TABLE IF EXISTS `tb_portals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_portals` (
  `id` int(10) NOT NULL COMMENT '传送阵的id',
  `name` varchar(50) NOT NULL DEFAULT '' COMMENT '传送阵的名称',
  `description` varchar(50) NOT NULL DEFAULT '' COMMENT '传送阵的描述',
  `resourceId` int(10) NOT NULL DEFAULT '1' COMMENT '传送阵的资源的id',
  `functionType` int(10) NOT NULL DEFAULT '1' COMMENT '功能类型 1副本选择 2场景跳转',
  `levelRequired` int(10) NOT NULL DEFAULT '1' COMMENT '传送门触发的等级需求',
  `sceneId` int(10) NOT NULL DEFAULT '0' COMMENT '所在场景的id',
  `position_x` int(10) NOT NULL DEFAULT '1000' COMMENT '传送门所在场景的x坐标',
  `position_y` int(10) NOT NULL DEFAULT '500' COMMENT '传送门所在场景的y坐标',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_profession`
--

DROP TABLE IF EXISTS `tb_profession`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_profession` (
  `preId` int(10) NOT NULL COMMENT '职业编号',
  `professionName` varchar(255) NOT NULL DEFAULT '' COMMENT '职业名称',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '职业描述',
  `perLevelStr` float NOT NULL DEFAULT '0' COMMENT '职业力量成长',
  `perLevelDex` float NOT NULL DEFAULT '0' COMMENT '职业敏捷成长',
  `perLevelVit` float NOT NULL DEFAULT '0' COMMENT '职业耐力成长',
  `perLevelWis` float NOT NULL DEFAULT '0' COMMENT '职业智力成长',
  `perHPVit` float NOT NULL DEFAULT '0' COMMENT '职业耐力对血量加成',
  `perPhyAttStr` float NOT NULL DEFAULT '0' COMMENT '职业力量对物攻加成',
  `perPhyDefStr` float NOT NULL DEFAULT '0' COMMENT '职业力量对物防加成',
  `perPhyDefVit` float DEFAULT '0' COMMENT '职业耐力对物防加成',
  `perMigAttWis` float NOT NULL DEFAULT '0' COMMENT '职业智力对魔攻加成',
  `perMigDefWis` float NOT NULL DEFAULT '0' COMMENT '职业智力对魔防加成',
  `perMigDefVit` float NOT NULL DEFAULT '0' COMMENT '职业耐力对魔防加成',
  `perSpeedDex` float NOT NULL DEFAULT '0' COMMENT '职业敏捷对速度加成',
  `ordSkill` int(11) NOT NULL DEFAULT '0' COMMENT '职业的普通攻击技能',
  PRIMARY KEY (`preId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_publicscene`
--

DROP TABLE IF EXISTS `tb_publicscene`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_publicscene` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '普通场景表id',
  `name` varchar(200) NOT NULL DEFAULT '' COMMENT '场景名称',
  `type` int(10) NOT NULL DEFAULT '1' COMMENT '场景的类型 1公共场景',
  `levelRequired` int(10) NOT NULL DEFAULT '1' COMMENT '等级需求',
  `memberRequired` int(10) NOT NULL DEFAULT '500' COMMENT '场景可容纳人数',
  `height` int(10) NOT NULL DEFAULT '500' COMMENT '场景高度',
  `width` int(10) NOT NULL DEFAULT '2000' COMMENT '场景宽度',
  `init_X` int(10) NOT NULL DEFAULT '200' COMMENT '人物进入场景后的横坐标',
  `init_Y` int(10) NOT NULL DEFAULT '400' COMMENT '人物进入场景后的纵坐标',
  `resourceid` int(10) NOT NULL DEFAULT '1000' COMMENT '场景的资源id',
  `portals` varchar(500) NOT NULL DEFAULT '' COMMENT '传送门列表',
  `npclist` varchar(500) NOT NULL DEFAULT '' COMMENT '场景中的npcId',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1801 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_punish`
--

DROP TABLE IF EXISTS `tb_punish`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_punish` (
  `qlevel` int(5) NOT NULL DEFAULT '1' COMMENT '强化等级 (强化失败惩罚表) 没有记录的说明该强化等级没有惩罚',
  `levela` int(5) NOT NULL DEFAULT '1' COMMENT '-1：强化等级降低1级 0：强化装备设置为0  1：强化装备设置为1',
  `del` tinyint(1) NOT NULL DEFAULT '0' COMMENT '装备是否删除 0:不删除  1：删除',
  `gold` int(5) NOT NULL DEFAULT '0' COMMENT '获得魔钻的数量',
  `gl` int(5) NOT NULL DEFAULT '0' COMMENT '获得魔钻的概率'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_recharge`
--

DROP TABLE IF EXISTS `tb_recharge`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_recharge` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '充值记录',
  `uid` varchar(20) DEFAULT '0' COMMENT 'uid',
  `rbm` int(20) DEFAULT '0' COMMENT '人民币',
  `zuan` int(20) DEFAULT '0' COMMENT '充值钻',
  `serviceid` varchar(20) DEFAULT '' COMMENT '服务器id',
  `lyid` int(20) DEFAULT '0' COMMENT '联运商id',
  `rtime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '充值时间',
  `orderid` varchar(50) DEFAULT '0' COMMENT '订单id',
  `boo` int(2) DEFAULT '-1' COMMENT '充值是否成功   1表示成功  -8活动奖励钻(游戏服务器专用)',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_register`
--

DROP TABLE IF EXISTS `tb_register`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_register` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '用户密码',
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '' COMMENT '用户注册邮箱',
  `characterId` int(10) DEFAULT '0' COMMENT '用户的角色ID',
  `pid` int(11) DEFAULT '-1' COMMENT '邀请人的角色id',
  `lastonline` datetime NOT NULL DEFAULT '2012-06-05 00:00:00' COMMENT '最后在线时间',
  `logintimes` int(11) NOT NULL DEFAULT '0' COMMENT '登陆次数',
  `enable` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否可以登录',
  PRIMARY KEY (`id`,`username`)
) ENGINE=MyISAM AUTO_INCREMENT=1918 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_report`
--

DROP TABLE IF EXISTS `tb_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_report` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '举报表id',
  `characterid` int(20) NOT NULL DEFAULT '0' COMMENT '当前角色id',
  `tocharacterid` int(20) NOT NULL DEFAULT '0' COMMENT '被举报的角色id,倒霉的人的id',
  `context` varchar(500) NOT NULL DEFAULT '' COMMENT '举报内容',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_repurchase`
--

DROP TABLE IF EXISTS `tb_repurchase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_repurchase` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '物品出售记录ID',
  `itemId` int(20) NOT NULL COMMENT '物品的ID',
  `characterId` int(20) NOT NULL COMMENT '角色的ID',
  `sellTime` datetime NOT NULL COMMENT '出售的时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1870 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_repurchase_gold`
--

DROP TABLE IF EXISTS `tb_repurchase_gold`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_repurchase_gold` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '序号',
  `characterId` int(20) NOT NULL COMMENT '角色的ID',
  `gold` int(10) NOT NULL COMMENT '充值的钻',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_scene`
--

DROP TABLE IF EXISTS `tb_scene`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_scene` (
  `id` int(20) NOT NULL DEFAULT '0' COMMENT '场景Id',
  `name` varchar(200) NOT NULL DEFAULT '' COMMENT '场景名称',
  `adjacencyId` varchar(200) NOT NULL DEFAULT '2' COMMENT '通过此场景可以到哪些场景中去例如 1，,3,5,6',
  `levelRequired` int(20) NOT NULL DEFAULT '-1' COMMENT '等级需求',
  `camp` int(20) NOT NULL DEFAULT '-1' COMMENT '阵营需求 此场景是否是几方pk',
  `memberRequired` int(20) NOT NULL DEFAULT '-1' COMMENT '场景可容纳人数',
  `areaHeight` int(20) NOT NULL DEFAULT '570' COMMENT '场景高度',
  `areaWidth` int(20) NOT NULL DEFAULT '2099' COMMENT '场景宽度',
  `monsters` varchar(500) NOT NULL DEFAULT '' COMMENT '场景中de怪物 id:(横坐标,纵坐标);',
  `npcs` varchar(200) NOT NULL DEFAULT '' COMMENT '场景中的NPC id:(横坐标,纵坐标);',
  `boss` int(20) NOT NULL DEFAULT '-1' COMMENT 'bossId,没有boss 填-1',
  `initPointX` int(20) NOT NULL DEFAULT '200' COMMENT '人物进入场景后的横坐标',
  `initPointY` int(20) NOT NULL DEFAULT '400' COMMENT '人物进入场景后的纵坐标',
  `areaid` int(20) NOT NULL DEFAULT '-1' COMMENT '场景所属区域Id',
  `resourceid` int(20) DEFAULT '1001' COMMENT '场景的资源id',
  `npclist` varchar(500) DEFAULT '' COMMENT 'npc列表',
  `portals` varchar(500) DEFAULT '' COMMENT '传送门列表',
  `type` int(10) DEFAULT '2' COMMENT '场景类型 1公共 2副本',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_schedule`
--

DROP TABLE IF EXISTS `tb_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_schedule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) NOT NULL COMMENT '角色的ID',
  `schedule_1` int(11) NOT NULL DEFAULT '0' COMMENT '日程1',
  `schedule_2` int(11) NOT NULL DEFAULT '0' COMMENT '日程2',
  `schedule_3` int(11) NOT NULL DEFAULT '0',
  `schedule_4` int(11) NOT NULL DEFAULT '0',
  `schedule_5` int(11) NOT NULL DEFAULT '0',
  `schedule_6` int(11) NOT NULL DEFAULT '0',
  `schedule_7` int(11) NOT NULL DEFAULT '0',
  `schedule_8` int(11) NOT NULL DEFAULT '0',
  `schedule_9` int(11) NOT NULL DEFAULT '0',
  `schedule_10` int(11) NOT NULL DEFAULT '0',
  `schedule_11` int(11) NOT NULL DEFAULT '0',
  `schedule_12` int(11) NOT NULL DEFAULT '0',
  `schedule_13` int(11) NOT NULL DEFAULT '0',
  `schedule_14` int(11) NOT NULL DEFAULT '0',
  `schedule_15` int(11) NOT NULL DEFAULT '0',
  `schedule_16` int(11) NOT NULL DEFAULT '0',
  `schedule_17` int(11) NOT NULL DEFAULT '0',
  `schedule_18` int(11) NOT NULL DEFAULT '0',
  `schedule_19` int(11) NOT NULL DEFAULT '0',
  `schedule_20` int(11) NOT NULL DEFAULT '0',
  `scheduledate` date NOT NULL COMMENT '进度日期',
  `activity` int(11) NOT NULL DEFAULT '0' COMMENT '角色当日活跃度',
  `bound_1` tinyint(2) NOT NULL DEFAULT '0' COMMENT '第一阶段奖励是否领取 0 未领取 1已领取',
  `bound_2` tinyint(2) NOT NULL DEFAULT '0' COMMENT '第二阶段奖励是否领取 ',
  `bound_3` tinyint(2) NOT NULL DEFAULT '0' COMMENT '第三阶段奖励是否领取 ',
  `bound_4` tinyint(2) NOT NULL DEFAULT '0' COMMENT '第四阶段奖励是否领取 ',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=946 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_schedule_bound`
--

DROP TABLE IF EXISTS `tb_schedule_bound`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_schedule_bound` (
  `bound_tag` int(10) NOT NULL AUTO_INCREMENT COMMENT '阶段奖励序号',
  `vitality_required` int(10) NOT NULL DEFAULT '0' COMMENT '阶段活力需求',
  `item_bound` int(10) NOT NULL COMMENT '物品奖励模板ID',
  PRIMARY KEY (`bound_tag`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_schedule_config`
--

DROP TABLE IF EXISTS `tb_schedule_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_schedule_config` (
  `schedule_tag` int(11) NOT NULL COMMENT '进度标识',
  `schedule_activity` int(11) NOT NULL COMMENT '进度活力',
  `schedule_goal` int(11) NOT NULL COMMENT '进度目标数量',
  `schedule_des` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '进度的描述',
  PRIMARY KEY (`schedule_tag`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_shieldword`
--

DROP TABLE IF EXISTS `tb_shieldword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_shieldword` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sword` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7833 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_skill`
--

DROP TABLE IF EXISTS `tb_skill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_skill` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `characterId` int(20) NOT NULL COMMENT '角色的id',
  `skillId` int(11) NOT NULL COMMENT '技能的id',
  `skillLevel` int(11) DEFAULT '1' COMMENT '技能的等级',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_skill_effect`
--

DROP TABLE IF EXISTS `tb_skill_effect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_skill_effect` (
  `effectId` int(10) unsigned NOT NULL COMMENT '技能的特效ID',
  `formula` varchar(255) NOT NULL DEFAULT '' COMMENT '技能效果计算公式',
  `clearBuffId` int(10) NOT NULL DEFAULT '0' COMMENT '清除buff的ID',
  `clearRate` int(10) NOT NULL DEFAULT '100' COMMENT '清除buff的概率',
  `addBuffId` int(10) NOT NULL DEFAULT '0' COMMENT '添加buff的ID',
  `addRate` int(10) NOT NULL DEFAULT '100' COMMENT '添加buff的概率',
  PRIMARY KEY (`effectId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_skill_info`
--

DROP TABLE IF EXISTS `tb_skill_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_skill_info` (
  `skillId` int(10) NOT NULL COMMENT '技能的ID',
  `skillName` varchar(255) NOT NULL DEFAULT '' COMMENT '技能的名称',
  `skillGroup` int(10) NOT NULL DEFAULT '0' COMMENT '技能组的id',
  `level` int(10) DEFAULT '1' COMMENT '技能的等级',
  `icon` int(20) NOT NULL DEFAULT '0' COMMENT '技能图标',
  `type` int(20) NOT NULL DEFAULT '0' COMMENT '技能图标类型',
  `skillType` int(20) NOT NULL DEFAULT '3' COMMENT '技能类型 0主动技能1被动技能2应用技能3战斗技能',
  `profession` int(20) NOT NULL DEFAULT '0' COMMENT '职业限制 0无限制 1战士 2法师 3游侠 4牧师 6怪物 9所有角色普通攻击技能',
  `skillDescript` varchar(255) NOT NULL DEFAULT '' COMMENT '技能的描述',
  `weaponRequied` int(10) NOT NULL DEFAULT '0' COMMENT '技能所需武器',
  `releaseType` int(10) NOT NULL DEFAULT '1' COMMENT '技能释放类型 1主动 2被动',
  `levelRequired` int(10) NOT NULL DEFAULT '1' COMMENT '技能需求等级',
  `itemRequired` int(10) NOT NULL DEFAULT '20030061' COMMENT '技能物品需求',
  `itemCountRequired` int(10) NOT NULL DEFAULT '1' COMMENT '技能物品个数需求',
  `levelUpMoney` int(10) NOT NULL DEFAULT '0' COMMENT '技能需要钱数',
  `releaseCD` int(10) NOT NULL DEFAULT '0' COMMENT '技能CD时间（回合数）',
  `distanceType` int(10) NOT NULL DEFAULT '2' COMMENT '技能的距离类型 1远程 2近身',
  `rangeType` int(10) NOT NULL DEFAULT '1' COMMENT '技能的范围类型 1单体 2全体 ..',
  `attributeType` int(10) NOT NULL DEFAULT '1' COMMENT '技能的属性类型 1物理 2魔法',
  `targetType` int(10) NOT NULL DEFAULT '3' COMMENT '技能的目标类型 1=自己 2=队友 3=敌方',
  `expendPower` int(10) NOT NULL DEFAULT '0' COMMENT '技能能量消耗',
  `expendHp` int(10) NOT NULL DEFAULT '0' COMMENT '技能血量消耗',
  `effect` int(10) NOT NULL DEFAULT '0' COMMENT '技能的效果ID',
  `releaseEffect` int(10) NOT NULL DEFAULT '0' COMMENT '技能的释放特效',
  `bearEffect` int(10) NOT NULL DEFAULT '0' COMMENT '技能的承受特效',
  `throwEffectId` int(10) NOT NULL DEFAULT '0' COMMENT '技能的投射特效',
  `aoeEffectId` int(10) NOT NULL DEFAULT '0' COMMENT '全屏特效',
  PRIMARY KEY (`skillId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_statistics`
--

DROP TABLE IF EXISTS `tb_statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_statistics` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `recorddate` date NOT NULL COMMENT '记录日期',
  `high` int(11) NOT NULL DEFAULT '0' COMMENT '当天最高在线',
  `createrole` int(11) NOT NULL DEFAULT '0' COMMENT '当天创建角色数量',
  `loginuser` int(11) NOT NULL DEFAULT '0' COMMENT '当天登陆过的账号数量',
  `onlineaverage` int(11) NOT NULL DEFAULT '0' COMMENT '平均在线时间',
  `onlinetotal` int(10) NOT NULL DEFAULT '0' COMMENT '总在线时间（分钟）',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=151 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_strengthenicon`
--

DROP TABLE IF EXISTS `tb_strengthenicon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_strengthenicon` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '强化图标持续时间',
  `pid` int(20) DEFAULT NULL COMMENT '角色id',
  `ctime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '图标开始时间',
  `counts` int(20) DEFAULT NULL COMMENT '冷却时间(秒)',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=100 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_task_goal`
--

DROP TABLE IF EXISTS `tb_task_goal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_task_goal` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '任务目的表',
  `trackDesc` varchar(100) NOT NULL DEFAULT '' COMMENT '任务的追踪描述',
  `goalType` int(11) NOT NULL DEFAULT '1' COMMENT '任务的目的类型,1=送信对话,2=杀怪,3=收集道具,4=使用道具,5=装备强化',
  `goalNpcID` int(20) NOT NULL DEFAULT '0' COMMENT '目标NPC的ID',
  `talkNum` int(20) NOT NULL DEFAULT '0' COMMENT '交谈次数',
  `goalMonsterID` int(20) NOT NULL DEFAULT '0' COMMENT '目标怪物的ID',
  `killNum` int(20) NOT NULL DEFAULT '0' COMMENT '目标数量',
  `useItemID` int(20) NOT NULL DEFAULT '0' COMMENT '使用的目标物品',
  `useNum` int(20) NOT NULL DEFAULT '0' COMMENT '使用目标次数',
  `collectItemID` int(20) NOT NULL DEFAULT '0' COMMENT '收集物品的ID',
  `dropMonsterID` int(20) NOT NULL DEFAULT '0' COMMENT '相关的掉落关联怪物',
  `collectNum` int(20) NOT NULL DEFAULT '0' COMMENT '收集的目标数量',
  `equipmentID` int(20) NOT NULL DEFAULT '0' COMMENT '目标装备的ID',
  `goalQualityLevel` int(20) NOT NULL DEFAULT '0' COMMENT '目标品质等级',
  `categories_id` int(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_task_goal_progress`
--

DROP TABLE IF EXISTS `tb_task_goal_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_task_goal_progress` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `questRecordId` int(10) DEFAULT NULL COMMENT '任务id',
  `questGoalId` int(10) DEFAULT NULL COMMENT '任务目标id',
  `talkCount` int(10) DEFAULT '0' COMMENT '已经交谈次数',
  `killCount` int(10) DEFAULT '0' COMMENT '已经杀死怪物的数量',
  `useCount` int(10) DEFAULT '0' COMMENT '已经使用物品的次数',
  `collectCount` int(10) DEFAULT '0' COMMENT '已经收集到得物品的数量',
  `qualityLevel` int(10) DEFAULT '0' COMMENT '装备强化到的等级',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_task_info`
--

DROP TABLE IF EXISTS `tb_task_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_task_info` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '任务的ID',
  `name` varchar(10) NOT NULL DEFAULT '' COMMENT '任务的名称',
  `vestmap` int(20) NOT NULL DEFAULT '-1' COMMENT '起始地图ID',
  `type` tinyint(4) NOT NULL DEFAULT '-1' COMMENT '任务的类型 1=主线，2=支线，3=行会，4=环任务',
  `purposeType` tinyint(4) NOT NULL DEFAULT '1' COMMENT '任务的目的类型,1=送信对话,2=杀怪,3=收集道具,4=使用道具,5=装备强化',
  `description` varchar(100) NOT NULL DEFAULT '' COMMENT '任务的描述',
  `professionRequire` tinyint(4) NOT NULL DEFAULT '0' COMMENT '职业限制，0无限制，1=战士，2=法师，3=牧师，4=游侠',
  `levelRequire` tinyint(4) NOT NULL DEFAULT '1' COMMENT '等级限制',
  `rankRequire` tinyint(4) NOT NULL DEFAULT '0' COMMENT '军衔限制',
  `guildLevelRequire` tinyint(4) NOT NULL DEFAULT '0' COMMENT '行会等级限制',
  `taskBefore` varchar(4) NOT NULL DEFAULT '' COMMENT '前置任务，多个用逗号分隔',
  `triggerCondition` tinyint(4) NOT NULL DEFAULT '-1' COMMENT '触发条件，1=进入场景，2=杀死怪物，3=获得道具，4=穿戴装备，5=装备升级，6=角色升级，7=获得成就，8=声望等级提升，9=军衔提升',
  `triggerID` varchar(20) NOT NULL DEFAULT '' COMMENT '触发条件ID,多个以逗号分开',
  `providerID` int(20) NOT NULL DEFAULT '-1' COMMENT '任务提供者的ID',
  `providerType` tinyint(4) NOT NULL DEFAULT '-1' COMMENT '任务提供者的类型，1=NPC，2=道具，3=系统',
  `getItemID` int(20) NOT NULL DEFAULT '-1' COMMENT '获取任务物品的ID',
  `getItemCount` int(20) NOT NULL DEFAULT '0' COMMENT '获取物品的数量',
  `reporterID` int(20) NOT NULL DEFAULT '-1' COMMENT '提交任务者的ID',
  `reporterType` tinyint(4) NOT NULL DEFAULT '-1' COMMENT '接受提交者的类型 1=NPC，2=怪物，3=可使用任务道具，4=可收集任务道具，5=装备',
  `taskDialogue` varchar(100) NOT NULL DEFAULT '' COMMENT '任务对话',
  `taskRefusalDialogue` varchar(100) NOT NULL DEFAULT '' COMMENT '任务拒绝对话',
  `taskAccepDialogue` varchar(100) NOT NULL DEFAULT '' COMMENT '任务接受对话',
  `taskConductDialogue_p` varchar(100) NOT NULL DEFAULT '' COMMENT '任务未完成时提供者的对话',
  `taskConductDialogue_r` varchar(100) NOT NULL DEFAULT '' COMMENT '任务未完成时提交者的对话',
  `taskFinishDialogue` varchar(100) NOT NULL DEFAULT '' COMMENT '任务完成时的对话',
  `ExpBound` int(20) NOT NULL DEFAULT '0' COMMENT '经验奖励',
  `coinBound` int(20) NOT NULL DEFAULT '0' COMMENT '游戏币奖励',
  `couponBound` int(20) NOT NULL DEFAULT '0' COMMENT '礼券奖励',
  `prestigeType` int(20) NOT NULL DEFAULT '0' COMMENT '声望的类型',
  `prestigeBound` int(20) NOT NULL DEFAULT '0' COMMENT '声望奖励',
  `gloryBound` int(20) unsigned NOT NULL DEFAULT '0' COMMENT '军衔值奖励',
  `designationBound` int(20) NOT NULL DEFAULT '0' COMMENT '称号奖励',
  `buffBound` int(20) NOT NULL DEFAULT '0' COMMENT '称号奖励',
  `refreshTime` time NOT NULL DEFAULT '00:00:00' COMMENT '每日刷新时间',
  `executableCount` int(10) NOT NULL DEFAULT '1' COMMENT '每日可执行次数',
  `optionalItemBound` varchar(100) NOT NULL DEFAULT '' COMMENT '可选的物品奖励（根据职业的不同）格式为（X，YYYY，ZZ），X为玩家职业代码，Y为奖励物品ID，Z为奖励物品数量；职业代码为  1=战士',
  `requiredItemBound` varchar(100) NOT NULL DEFAULT '' COMMENT '固定的物品奖励，格式为（XXXX，YY），X为奖品ID，Y为奖品数量，多个奖品之间可使用“，”分割',
  `visible` tinyint(4) NOT NULL DEFAULT '1' COMMENT '任务的可见和隐藏性（0=不可见，1=可见）',
  `categories_id` int(11) DEFAULT '1',
  `steps` varchar(20) DEFAULT '' COMMENT '任务的目标列表用逗号分隔',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=112 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_task_main`
--

DROP TABLE IF EXISTS `tb_task_main`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_task_main` (
  `taskID` int(10) NOT NULL DEFAULT '0' COMMENT '主线任务的ID',
  `taskName` varchar(50) NOT NULL DEFAULT '' COMMENT '主线任务的名称',
  `taskType` int(10) NOT NULL DEFAULT '1' COMMENT '主线任务的类型1 = 对话 2 = 打怪 3 = 通关副本 4 = 消耗魔钻 5 = 收集道具',
  `lableType` varchar(255) NOT NULL DEFAULT '克洛村' COMMENT '任务所属标签',
  `taskDescription` varchar(255) NOT NULL DEFAULT '' COMMENT '任务的描述',
  `taskGoalDes` varchar(255) NOT NULL DEFAULT '' COMMENT '任务目的描述',
  `providerScene` int(10) NOT NULL DEFAULT '1000' COMMENT '接受任务的场景',
  `providerNPC` int(10) NOT NULL DEFAULT '0' COMMENT '任务提供者的id',
  `reporterNPC` int(10) NOT NULL DEFAULT '0' COMMENT '任务提交NPC的ID',
  `giveItem` varchar(255) NOT NULL DEFAULT '' COMMENT '任务接受时给予的物品 格式如{0:[(10000,5),(10001,1)],1:[(10001,1)]}',
  `NPCTalk1` varchar(255) NOT NULL DEFAULT '' COMMENT 'NPC第一次说话',
  `UserTalk1` varchar(255) NOT NULL DEFAULT '' COMMENT '玩家第一次回答',
  `NPCTalk2` varchar(255) NOT NULL DEFAULT '' COMMENT 'NPC第二次说话',
  `UserTalk2` varchar(255) NOT NULL DEFAULT '' COMMENT '玩家第二次回答',
  `NPCTalk3` varchar(255) NOT NULL DEFAULT '' COMMENT 'NPC第三次说话',
  `UserEnter` varchar(255) NOT NULL DEFAULT '' COMMENT '任务接受确认文字',
  `professionRequired` tinyint(4) NOT NULL DEFAULT '0' COMMENT '任务的职业限制 0通用',
  `levelRequired` int(10) NOT NULL DEFAULT '0' COMMENT '任务的等级限制',
  `priorityID` int(10) NOT NULL DEFAULT '0' COMMENT '前置任务的ID',
  `quality` tinyint(4) NOT NULL DEFAULT '1' COMMENT '任务的品质',
  `finishedState` varchar(255) NOT NULL DEFAULT '' COMMENT '任务的完成状态',
  `demandItem` int(10) NOT NULL DEFAULT '0' COMMENT '任务道具需求',
  `itemRelationMonster` int(10) NOT NULL DEFAULT '0' COMMENT '道具关联的怪物',
  `itemCount` int(10) NOT NULL DEFAULT '0' COMMENT '任务道具需求数量',
  `demandMonster` int(10) NOT NULL DEFAULT '0' COMMENT '任务怪物需求',
  `monsterCount` int(10) NOT NULL DEFAULT '0' COMMENT '怪物数量需求',
  `demandNPC` int(10) NOT NULL DEFAULT '0' COMMENT '对话NPC的ID',
  `demandDialogue` varchar(255) NOT NULL DEFAULT '' COMMENT '任务对话',
  `dialogueFinished` varchar(255) NOT NULL DEFAULT '' COMMENT '任务对话完成对话',
  `demandCheckpoint` int(10) NOT NULL DEFAULT '0' COMMENT '任务关卡需求',
  `demandGold` int(10) NOT NULL DEFAULT '0' COMMENT '消耗魔钻任务',
  `NPCFinishTalk` varchar(255) NOT NULL DEFAULT '' COMMENT '完成任务NPC的对话',
  `UserFinishEnter` varchar(255) NOT NULL DEFAULT '' COMMENT '任务完成确认文字',
  `NPCUnfinishTalk` varchar(255) NOT NULL DEFAULT '' COMMENT '未完成对话',
  `UserUnfinishEnter` varchar(255) NOT NULL DEFAULT '' COMMENT '任务未完成确认文字',
  `ExpPrize` int(10) NOT NULL DEFAULT '0' COMMENT '经验奖励',
  `CoinPrize` int(10) NOT NULL DEFAULT '0' COMMENT '魔币奖励',
  `GoldPrize` int(10) NOT NULL DEFAULT '0' COMMENT '魔钻奖励',
  `LegioPrize` int(10) NOT NULL DEFAULT '0' COMMENT '军团贡献奖励',
  `StatePrize` int(10) NOT NULL DEFAULT '0' COMMENT 'buff奖励(buff的id)',
  `ItemPrize` varchar(255) NOT NULL DEFAULT '' COMMENT '物品奖励格式如{0:[(10000,5),(10001,1)],1:[(10001,1)]}',
  `task_running_des` varchar(255) NOT NULL DEFAULT '' COMMENT '任务进行中追踪描述',
  `running_int_arg1` int(10) NOT NULL DEFAULT '0',
  `running_char_arg1` varchar(50) NOT NULL DEFAULT '',
  `running_int_arg2` int(10) NOT NULL DEFAULT '0',
  `running_char_arg2` varchar(50) NOT NULL DEFAULT '',
  `running_int_arg3` int(10) NOT NULL DEFAULT '0',
  `running_char_arg3` varchar(50) NOT NULL DEFAULT '',
  `running_int_arg4` int(10) NOT NULL DEFAULT '0',
  `running_char_arg4` varchar(50) NOT NULL DEFAULT '',
  `running_int_arg5` int(10) NOT NULL DEFAULT '0',
  `running_char_arg5` varchar(50) NOT NULL DEFAULT '',
  `task_complete_des` varchar(255) NOT NULL DEFAULT '' COMMENT '任务完成的任务追踪描述',
  `complete_int_arg1` int(10) NOT NULL DEFAULT '0',
  `complete_char_arg1` varchar(50) NOT NULL DEFAULT '',
  `complete_int_arg2` int(10) NOT NULL DEFAULT '0',
  `complete_char_arg2` varchar(50) NOT NULL DEFAULT '',
  `complete_int_arg3` int(10) NOT NULL DEFAULT '0',
  `complete_char_arg3` varchar(50) NOT NULL DEFAULT '',
  `complete_int_arg4` int(10) NOT NULL DEFAULT '0',
  `complete_char_arg4` varchar(50) NOT NULL DEFAULT '',
  `complete_int_arg5` int(10) NOT NULL DEFAULT '0',
  `complete_char_arg5` varchar(50) DEFAULT '',
  PRIMARY KEY (`taskID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_task_main_copy`
--

DROP TABLE IF EXISTS `tb_task_main_copy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_task_main_copy` (
  `taskID` int(10) NOT NULL DEFAULT '0' COMMENT '主线任务的ID',
  `taskName` varchar(50) NOT NULL DEFAULT '' COMMENT '主线任务的名称',
  `taskType` int(10) NOT NULL DEFAULT '1' COMMENT '主线任务的类型1 = 对话 2 = 打怪 3 = 通关副本 4 = 消耗魔钻 5 = 收集道具',
  `lableType` varchar(255) NOT NULL DEFAULT '克洛村' COMMENT '任务所属标签',
  `taskDescription` varchar(255) NOT NULL DEFAULT '' COMMENT '任务的描述',
  `taskGoalDes` varchar(255) NOT NULL DEFAULT '' COMMENT '任务目的描述',
  `providerScene` int(10) NOT NULL DEFAULT '1000' COMMENT '接受任务的场景',
  `providerNPC` int(10) NOT NULL DEFAULT '0' COMMENT '任务提供者的id',
  `reporterNPC` int(10) NOT NULL DEFAULT '0' COMMENT '任务提交NPC的ID',
  `giveItem` varchar(255) NOT NULL DEFAULT '' COMMENT '任务接受时给予的物品 格式如{0:[(10000,5),(10001,1)],1:[(10001,1)]}',
  `NPCTalk1` varchar(255) NOT NULL DEFAULT '' COMMENT 'NPC第一次说话',
  `UserTalk1` varchar(255) NOT NULL DEFAULT '' COMMENT '玩家第一次回答',
  `NPCTalk2` varchar(255) NOT NULL DEFAULT '' COMMENT 'NPC第二次说话',
  `UserTalk2` varchar(255) NOT NULL DEFAULT '' COMMENT '玩家第二次回答',
  `NPCTalk3` varchar(255) NOT NULL DEFAULT '' COMMENT 'NPC第三次说话',
  `UserEnter` varchar(255) NOT NULL DEFAULT '' COMMENT '任务接受确认文字',
  `professionRequired` tinyint(4) NOT NULL DEFAULT '0' COMMENT '任务的职业限制 0通用',
  `levelRequired` int(10) NOT NULL DEFAULT '0' COMMENT '任务的等级限制',
  `priorityID` int(10) NOT NULL DEFAULT '0' COMMENT '前置任务的ID',
  `quality` tinyint(4) NOT NULL DEFAULT '1' COMMENT '任务的品质',
  `demandItem` int(10) NOT NULL DEFAULT '0' COMMENT '任务道具需求',
  `itemRelationMonster` int(10) NOT NULL DEFAULT '0' COMMENT '道具关联的怪物',
  `itemCount` int(10) NOT NULL DEFAULT '0' COMMENT '任务道具需求数量',
  `demandMonster` int(10) NOT NULL DEFAULT '0' COMMENT '任务怪物需求',
  `monsterCount` int(10) NOT NULL DEFAULT '0' COMMENT '怪物数量需求',
  `demandNPC` int(10) NOT NULL DEFAULT '0' COMMENT '对话NPC的ID',
  `demandDialogue` varchar(255) NOT NULL DEFAULT '' COMMENT '任务对话',
  `dialogueFinished` varchar(255) NOT NULL DEFAULT '' COMMENT '任务对话完成对话',
  `demandCheckpoint` int(10) NOT NULL DEFAULT '0' COMMENT '任务关卡需求',
  `demandGold` int(10) NOT NULL DEFAULT '0' COMMENT '消耗魔钻任务',
  `NPCFinishTalk` varchar(255) NOT NULL DEFAULT '' COMMENT '完成任务NPC的对话',
  `UserFinishEnter` varchar(255) NOT NULL DEFAULT '' COMMENT '任务完成确认文字',
  `NPCUnfinishTalk` varchar(255) NOT NULL DEFAULT '' COMMENT '未完成对话',
  `UserUnfinishEnter` varchar(255) NOT NULL DEFAULT '' COMMENT '任务未完成确认文字',
  `ExpPrize` int(10) NOT NULL DEFAULT '0' COMMENT '经验奖励',
  `CoinPrize` int(10) NOT NULL DEFAULT '0' COMMENT '魔币奖励',
  `GoldPrize` int(10) NOT NULL DEFAULT '0' COMMENT '魔钻奖励',
  `LegioPrize` int(10) NOT NULL DEFAULT '0' COMMENT '军团贡献奖励',
  `StatePrize` int(10) NOT NULL DEFAULT '0' COMMENT 'buff奖励(buff的id)',
  `ItemPrize` varchar(255) NOT NULL DEFAULT '' COMMENT '物品奖励格式如{0:[(10000,5),(10001,1)],1:[(10001,1)]}',
  `task_running_des` varchar(255) NOT NULL DEFAULT '' COMMENT '任务进行中追踪描述',
  `running_int_arg1` int(10) NOT NULL DEFAULT '0',
  `running_char_arg1` varchar(50) NOT NULL DEFAULT '',
  `running_int_arg2` int(10) NOT NULL DEFAULT '0',
  `running_char_arg2` varchar(50) NOT NULL DEFAULT '',
  `running_int_arg3` int(10) NOT NULL DEFAULT '0',
  `running_char_arg3` varchar(50) NOT NULL DEFAULT '',
  `running_int_arg4` int(10) NOT NULL DEFAULT '0',
  `running_char_arg4` varchar(50) NOT NULL DEFAULT '',
  `running_int_arg5` int(10) NOT NULL DEFAULT '0',
  `running_char_arg5` varchar(50) NOT NULL DEFAULT '',
  `task_complete_des` varchar(255) NOT NULL DEFAULT '' COMMENT '任务完成的任务追踪描述',
  `complete_int_arg1` int(10) NOT NULL DEFAULT '0',
  `complete_char_arg1` varchar(50) NOT NULL DEFAULT '',
  `complete_int_arg2` int(10) NOT NULL DEFAULT '0',
  `complete_char_arg2` varchar(50) NOT NULL DEFAULT '',
  `complete_int_arg3` int(10) NOT NULL DEFAULT '0',
  `complete_char_arg3` varchar(50) NOT NULL DEFAULT '',
  `complete_int_arg4` int(10) NOT NULL DEFAULT '0',
  `complete_char_arg4` varchar(50) NOT NULL DEFAULT '',
  `complete_int_arg5` int(10) NOT NULL DEFAULT '0',
  `complete_char_arg5` varchar(50) DEFAULT '',
  PRIMARY KEY (`taskID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_task_main_record`
--

DROP TABLE IF EXISTS `tb_task_main_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_task_main_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) NOT NULL COMMENT '角色的ID',
  `mainRecord` int(11) NOT NULL DEFAULT '1000' COMMENT '主线任务的进度记录',
  `applyTime` datetime DEFAULT '2011-11-10 10:00:00' COMMENT '接受任务的时间',
  `finishTime` datetime DEFAULT NULL COMMENT '完成任务的时间',
  `status` int(11) NOT NULL DEFAULT '1' COMMENT '0未完成 1已完成',
  `trackStatu` tinyint(4) NOT NULL DEFAULT '0' COMMENT '任务追踪状态',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_task_process`
--

DROP TABLE IF EXISTS `tb_task_process`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_task_process` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `taskId` int(10) NOT NULL COMMENT '任务id',
  `characterId` int(10) DEFAULT '0' COMMENT '角色的ID',
  `killCount` int(10) NOT NULL DEFAULT '0' COMMENT '已经杀死怪物的数量',
  `collectCount` int(10) NOT NULL DEFAULT '0' COMMENT '已经收集到得物品的数量',
  `talkCount` int(10) NOT NULL DEFAULT '0' COMMENT '任务的交谈次数',
  `goldCount` int(10) NOT NULL DEFAULT '0' COMMENT '任务已经消耗魔钻',
  `checkpointCount` int(10) NOT NULL DEFAULT '0' COMMENT '通关关卡次数',
  `trackStatu` int(10) NOT NULL DEFAULT '0' COMMENT '任务追踪状态',
  `finished` int(10) NOT NULL DEFAULT '0' COMMENT '是否提交过',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6623 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_task_record`
--

DROP TABLE IF EXISTS `tb_task_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_task_record` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taskId` int(11) NOT NULL COMMENT '任务的id',
  `characterId` int(11) NOT NULL COMMENT '角色的ID',
  `applyTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '接受任务的时间',
  `finishTime` datetime DEFAULT NULL COMMENT '完成任务的时间',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '0未完成 1已完成',
  `itemBonus` int(11) NOT NULL DEFAULT '-1' COMMENT '奖励物品id',
  `trackStatu` tinyint(4) NOT NULL DEFAULT '0' COMMENT '任务追踪状态',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_teaminstance`
--

DROP TABLE IF EXISTS `tb_teaminstance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_teaminstance` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '组队副本战斗',
  `tpid` int(20) DEFAULT NULL COMMENT '组队副本类型',
  `names` varchar(50) DEFAULT NULL COMMENT '组队副本名称',
  `resourceid` int(20) DEFAULT NULL COMMENT '场景资源id',
  `mosters` varchar(500) DEFAULT NULL COMMENT '[[怪物id,阵法位置(1-9)],[怪物id,阵法位置(1-9)]]',
  `width` int(20) DEFAULT NULL COMMENT '场景的宽度',
  `height` int(20) DEFAULT NULL COMMENT '场景的高度',
  `dropid` varchar(200) DEFAULT NULL COMMENT '[teaminstance_drop主键id,teaminstance_drop主键id] 每填写一个id就掉落一个物品',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_teaminstance_drop`
--

DROP TABLE IF EXISTS `tb_teaminstance_drop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_teaminstance_drop` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '多人副本掉落表',
  `ditem` varchar(500) DEFAULT NULL COMMENT '[[物品id,物品数量,1,2],[物品id,物品数量,3,10]] 上限是100',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_technology`
--

DROP TABLE IF EXISTS `tb_technology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_technology` (
  `technology` int(10) unsigned NOT NULL COMMENT '科技编号',
  `technologyName` varchar(50) NOT NULL COMMENT '科技名称',
  `technologyDes` varchar(255) NOT NULL COMMENT '科技的描述',
  `icon` int(20) NOT NULL COMMENT '科技的图标',
  `technologyMaxLevel` int(10) NOT NULL DEFAULT '1' COMMENT '科技最大等级',
  `curSchedule` int(10) NOT NULL DEFAULT '10' COMMENT '科技当前进度',
  `technologyFormula` varchar(255) NOT NULL DEFAULT '' COMMENT '科技加成的公式',
  PRIMARY KEY (`technology`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_temppackage`
--

DROP TABLE IF EXISTS `tb_temppackage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_temppackage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(11) DEFAULT NULL COMMENT '玩家id',
  `itemId` int(11) DEFAULT NULL COMMENT '物品id',
  `position` tinyint(4) DEFAULT NULL COMMENT '当前位置',
  `stack` int(11) DEFAULT NULL COMMENT '当前叠加数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_territory`
--

DROP TABLE IF EXISTS `tb_territory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_territory` (
  `id` int(10) NOT NULL DEFAULT '0' COMMENT '城镇要塞的ID',
  `sceneId` int(10) NOT NULL DEFAULT '0' COMMENT '城镇的ID',
  `sname` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '城镇要塞的名称',
  `sdesc` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '城镇的说明',
  `mconfig` varchar(1024) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '战斗的怪物配置',
  `gid` int(10) DEFAULT '0' COMMENT '殖民军团的ID',
  `gname` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '殖民军团的名称',
  `pid` int(10) DEFAULT '0' COMMENT '殖民者的ID',
  `pname` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '殖民者的名称',
  `chanchu` varchar(1024) COLLATE utf8_unicode_ci DEFAULT '{''coin'':100}' COMMENT '殖民地的产出',
  `chanchuStr` varchar(255) COLLATE utf8_unicode_ci DEFAULT '金币' COMMENT '殖民地产出说明',
  `updateTime` int(20) DEFAULT '0' COMMENT '领地被更新的时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_topitem`
--

DROP TABLE IF EXISTS `tb_topitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_topitem` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '装备排行主键id',
  `itemid` int(20) DEFAULT NULL COMMENT '角色物品id',
  `typeid` tinyint(2) NOT NULL DEFAULT '0' COMMENT '物品类型 0武器  1装备  2饰品',
  `marks` int(20) DEFAULT '0' COMMENT '评分',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_tower_info`
--

DROP TABLE IF EXISTS `tb_tower_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_tower_info` (
  `id` int(10) NOT NULL DEFAULT '1' COMMENT '塔的层数',
  `name` varchar(20) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '该层的名称',
  `monsterdesc` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '该层的怪物信息',
  `boundinfo` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '该层的奖励信息',
  `level` int(10) NOT NULL DEFAULT '0' COMMENT '进入该层的等级需求',
  `dropoutid` int(10) NOT NULL DEFAULT '1' COMMENT '该层的掉落规则',
  `expbound` int(10) NOT NULL DEFAULT '0' COMMENT '该层的经验奖励',
  `matrixid` int(10) NOT NULL DEFAULT '100001' COMMENT '怪物的阵法ID',
  `rule` varchar(255) COLLATE utf8_bin NOT NULL DEFAULT '[]' COMMENT '怪物的摆放规则',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_tower_record`
--

DROP TABLE IF EXISTS `tb_tower_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_tower_record` (
  `characterId` int(10) NOT NULL COMMENT '角色的ID',
  `climbtimes` int(10) NOT NULL DEFAULT '0' COMMENT '已经爬过的次数',
  `nowLayers` int(10) NOT NULL DEFAULT '1' COMMENT '当前所在层数',
  `recordDate` date NOT NULL DEFAULT '2012-07-07' COMMENT '记录的日期',
  `high` int(10) NOT NULL DEFAULT '0' COMMENT '角色爬过的最高层数',
  PRIMARY KEY (`characterId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_training`
--

DROP TABLE IF EXISTS `tb_training`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_training` (
  `characterId` int(10) NOT NULL COMMENT '角色的ID',
  `memberId` int(10) NOT NULL COMMENT '挂机成员的ID列表',
  `starttime` datetime NOT NULL COMMENT '挂机开始的时间',
  `traintype` int(10) NOT NULL COMMENT '挂机类型',
  `trainmode` int(10) NOT NULL DEFAULT '1' COMMENT '挂机模式',
  PRIMARY KEY (`characterId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_turnrecord`
--

DROP TABLE IF EXISTS `tb_turnrecord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_turnrecord` (
  `characterId` int(10) NOT NULL COMMENT '角色的id',
  `turncointimes` int(10) NOT NULL DEFAULT '0' COMMENT '当天直接换取金钱的次数',
  `turncoindate` datetime NOT NULL DEFAULT '2010-11-11 11:11:11' COMMENT '上次直接换取经验的时间时间',
  `turnexptimes` int(10) NOT NULL DEFAULT '0' COMMENT '当天直接换取经验的次数',
  `turnexpdate` datetime NOT NULL DEFAULT '2010-11-11 11:11:11' COMMENT '上次直接换取经验的时间',
  `turnenergytimes` int(10) NOT NULL DEFAULT '0' COMMENT '购买体力的次数',
  `turnenergydate` datetime NOT NULL DEFAULT '2010-11-11 11:11:11' COMMENT '上次直接购买体力的时间',
  `viplevellibao` int(10) NOT NULL DEFAULT '0' COMMENT 'vip等级礼包',
  `miningdate` datetime NOT NULL DEFAULT '2010-11-11 11:11:11' COMMENT '上次立即完成挖掘的时间',
  `finishedMining` int(10) NOT NULL DEFAULT '0' COMMENT '立即完成挖掘次数',
  `traindate` datetime NOT NULL DEFAULT '2010-11-11 11:11:11' COMMENT '上次立即完成训练的时间',
  `finishedTrain` int(10) NOT NULL DEFAULT '0' COMMENT '立即完成训练的次数',
  PRIMARY KEY (`characterId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_user_character`
--

DROP TABLE IF EXISTS `tb_user_character`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_user_character` (
  `id` int(11) NOT NULL COMMENT '用户id',
  `character_1` int(11) DEFAULT '0' COMMENT '用户第一个角色的id',
  `character_2` int(11) DEFAULT '0' COMMENT '用户第二个角色的id',
  `character_3` int(11) DEFAULT '0' COMMENT '用户第三个角色的id',
  `character_4` int(11) DEFAULT '0' COMMENT '用户第四个角色的id',
  `character_5` int(11) DEFAULT '0' COMMENT '用户第五个角色的id',
  `pid` int(11) DEFAULT '0' COMMENT '用户邀请人的id',
  `last_character` int(11) DEFAULT '-1' COMMENT '上次登录的角色',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_vipexp`
--

DROP TABLE IF EXISTS `tb_vipexp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_vipexp` (
  `viplevel` int(4) NOT NULL DEFAULT '0' COMMENT 'VIP的等级',
  `maxexp` int(10) NOT NULL DEFAULT '0' COMMENT '升级VIP的最大经验'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_vippermissions`
--

DROP TABLE IF EXISTS `tb_vippermissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_vippermissions` (
  `viplevel` int(10) NOT NULL DEFAULT '0' COMMENT 'vip的等级',
  `libaoId` int(10) NOT NULL DEFAULT '0' COMMENT '可以领取礼包的ID',
  `cardnum` int(10) NOT NULL DEFAULT '0' COMMENT '通关可翻开牌子的数量',
  `turncointimes` int(10) NOT NULL DEFAULT '0' COMMENT '可使用点石成金的次数',
  `turnexptimes` int(10) NOT NULL DEFAULT '0' COMMENT '可使用土匪猛进的次数',
  `zhekou` int(10) NOT NULL DEFAULT '0' COMMENT '商城的折扣',
  `petflow` int(10) NOT NULL DEFAULT '0' COMMENT '宠物更随功能 0不开启 1开启',
  `goldskillup` int(10) NOT NULL DEFAULT '0' COMMENT '钻直接升级技能 0 不开启 1开启',
  `turnenergytimes` int(10) NOT NULL DEFAULT '0' COMMENT '每日购买精力次数',
  `arenatimes` int(10) NOT NULL DEFAULT '0' COMMENT '竞技场购买次数',
  `finishedMining` int(10) NOT NULL DEFAULT '0' COMMENT '挖掘立即完成次数',
  `finishedTrain` int(10) NOT NULL DEFAULT '0' COMMENT '训练立即完成次数',
  `climbtimes` int(10) NOT NULL DEFAULT '0' COMMENT '爬塔刷新次数'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_warehouse`
--

DROP TABLE IF EXISTS `tb_warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_warehouse` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `characterId` int(20) DEFAULT NULL COMMENT '玩家ID',
  `itemId` int(20) DEFAULT NULL COMMENT '对应玩家仓库中物品id',
  `position` int(11) DEFAULT NULL COMMENT '前当位置',
  `stack` int(11) DEFAULT NULL COMMENT '当前叠加数',
  `packageCounts` int(11) DEFAULT NULL COMMENT '存放在第几个仓库里',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_whitelist`
--

DROP TABLE IF EXISTS `tb_whitelist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_whitelist` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '名单编号',
  `hostname` varchar(255) COLLATE utf8_bin NOT NULL COMMENT '主机IP地址',
  `permission` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '权限范围',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_winning`
--

DROP TABLE IF EXISTS `tb_winning`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_winning` (
  `id` int(20) NOT NULL AUTO_INCREMENT COMMENT '连胜表,主键id',
  `pid` int(20) NOT NULL DEFAULT '0' COMMENT '角色id',
  `count` int(20) NOT NULL DEFAULT '1' COMMENT '连胜次数',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=39 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_wish_record`
--

DROP TABLE IF EXISTS `tb_wish_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_wish_record` (
  `characterId` int(10) NOT NULL COMMENT '角色的ID',
  `recordDate` date NOT NULL COMMENT '上次记录的日期',
  `wish_0_times` int(10) NOT NULL DEFAULT '0' COMMENT '使用四叶草许愿的次数',
  `wish_1_times` int(10) NOT NULL DEFAULT '0' COMMENT '使用郁金香许愿的次数',
  `wish_2_times` int(10) NOT NULL DEFAULT '0' COMMENT '使用蝴蝶兰许愿的次数',
  `wish_3_times` int(10) NOT NULL DEFAULT '0' COMMENT '使用紫罗兰许愿的次数',
  `wish_4_times` int(10) NOT NULL DEFAULT '0' COMMENT '使用曼陀罗许愿的次数',
  PRIMARY KEY (`characterId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_zhangjie`
--

DROP TABLE IF EXISTS `tb_zhangjie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_zhangjie` (
  `id` int(10) NOT NULL COMMENT '章节的ID',
  `yid` int(10) DEFAULT '0' COMMENT '所属战役的ID',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '章节的名称',
  `icon` int(10) DEFAULT '0' COMMENT '章节的图标',
  `quality` int(10) DEFAULT '1' COMMENT '章节的品质',
  `desc` varchar(1024) COLLATE utf8_unicode_ci DEFAULT '章节的描述' COMMENT '章节的描述',
  `levelrequired` int(10) DEFAULT '0' COMMENT '章节的等级需求',
  `priority` int(10) DEFAULT '0' COMMENT '前置章节的ID',
  `mconfig` varchar(1024) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '章节战斗的怪物配置',
  `resourceid` int(10) DEFAULT '0' COMMENT '章节资源的ID',
  `scene` int(10) DEFAULT '0' COMMENT '章节战斗场景ID',
  `coin` int(10) DEFAULT '0' COMMENT '战后金币奖励',
  `exp` int(10) DEFAULT '0' COMMENT '战后经验奖励',
  `dropid` int(10) DEFAULT '0' COMMENT '战后物品掉落',
  `dropicon` varchar(100) COLLATE utf8_unicode_ci DEFAULT '[]' COMMENT '可能掉落的物品说明',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_zhanyi`
--

DROP TABLE IF EXISTS `tb_zhanyi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_zhanyi` (
  `id` int(10) NOT NULL COMMENT '战役的ID',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT '战役名称' COMMENT '战役名称',
  `monsterID` int(10) DEFAULT '0' COMMENT '战役首领的ID',
  `desc` varchar(1024) COLLATE utf8_unicode_ci DEFAULT '战役的描述' COMMENT '战役的描述',
  `levelrequired` int(10) DEFAULT '0' COMMENT '战役的等级需求',
  `priority` int(10) DEFAULT '0' COMMENT '前置的战役ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tb_zhanyi_record`
--

DROP TABLE IF EXISTS `tb_zhanyi_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_zhanyi_record` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '记录的ID',
  `characterId` int(10) NOT NULL COMMENT '角色的ID',
  `zhanyi` int(10) DEFAULT '1000' COMMENT '战役的ID',
  `zhangjie` int(10) NOT NULL DEFAULT '1000' COMMENT '章节的ID',
  `star` int(10) NOT NULL DEFAULT '0' COMMENT '战斗的评分',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `dbtest1`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `dbtest1` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `dbtest1`;

--
-- Table structure for table `tb1`
--

DROP TABLE IF EXISTS `tb1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb1` (
  `id` int(11) NOT NULL,
  `gmt` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `dbtest2`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `dbtest2` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `dbtest2`;

--
-- Table structure for table `tb2`
--

DROP TABLE IF EXISTS `tb2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb2` (
  `id` int(11) NOT NULL,
  `val` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `dbtest3`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `dbtest3` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `dbtest3`;

--
-- Table structure for table `tb2`
--

DROP TABLE IF EXISTS `tb2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb2` (
  `id` int(11) NOT NULL,
  `val` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `master`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `master` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `master`;

--
-- Current Database: `mysql`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mysql` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `mysql`;

--
-- Table structure for table `columns_priv`
--

DROP TABLE IF EXISTS `columns_priv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `columns_priv` (
  `Host` char(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Db` char(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `User` char(16) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Table_name` char(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Column_name` char(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Column_priv` set('Select','Insert','Update','References') CHARACTER SET utf8 NOT NULL DEFAULT '',
  PRIMARY KEY (`Host`,`Db`,`User`,`Table_name`,`Column_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Column privileges';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `db`
--

DROP TABLE IF EXISTS `db`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `db` (
  `Host` char(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Db` char(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `User` char(16) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Select_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Insert_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Update_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Delete_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Drop_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Grant_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `References_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Index_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Alter_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_tmp_table_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Lock_tables_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_view_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Show_view_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_routine_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Alter_routine_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Execute_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Event_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Trigger_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  PRIMARY KEY (`Host`,`Db`,`User`),
  KEY `User` (`User`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Database privileges';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event`
--

DROP TABLE IF EXISTS `event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event` (
  `db` char(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `name` char(64) NOT NULL DEFAULT '',
  `body` longblob NOT NULL,
  `definer` char(77) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `execute_at` datetime DEFAULT NULL,
  `interval_value` int(11) DEFAULT NULL,
  `interval_field` enum('YEAR','QUARTER','MONTH','DAY','HOUR','MINUTE','WEEK','SECOND','MICROSECOND','YEAR_MONTH','DAY_HOUR','DAY_MINUTE','DAY_SECOND','HOUR_MINUTE','HOUR_SECOND','MINUTE_SECOND','DAY_MICROSECOND','HOUR_MICROSECOND','MINUTE_MICROSECOND','SECOND_MICROSECOND') DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_executed` datetime DEFAULT NULL,
  `starts` datetime DEFAULT NULL,
  `ends` datetime DEFAULT NULL,
  `status` enum('ENABLED','DISABLED','SLAVESIDE_DISABLED') NOT NULL DEFAULT 'ENABLED',
  `on_completion` enum('DROP','PRESERVE') NOT NULL DEFAULT 'DROP',
  `sql_mode` set('REAL_AS_FLOAT','PIPES_AS_CONCAT','ANSI_QUOTES','IGNORE_SPACE','NOT_USED','ONLY_FULL_GROUP_BY','NO_UNSIGNED_SUBTRACTION','NO_DIR_IN_CREATE','POSTGRESQL','ORACLE','MSSQL','DB2','MAXDB','NO_KEY_OPTIONS','NO_TABLE_OPTIONS','NO_FIELD_OPTIONS','MYSQL323','MYSQL40','ANSI','NO_AUTO_VALUE_ON_ZERO','NO_BACKSLASH_ESCAPES','STRICT_TRANS_TABLES','STRICT_ALL_TABLES','NO_ZERO_IN_DATE','NO_ZERO_DATE','INVALID_DATES','ERROR_FOR_DIVISION_BY_ZERO','TRADITIONAL','NO_AUTO_CREATE_USER','HIGH_NOT_PRECEDENCE','NO_ENGINE_SUBSTITUTION','PAD_CHAR_TO_FULL_LENGTH') NOT NULL DEFAULT '',
  `comment` char(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `originator` int(10) unsigned NOT NULL,
  `time_zone` char(64) CHARACTER SET latin1 NOT NULL DEFAULT 'SYSTEM',
  `character_set_client` char(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `collation_connection` char(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `db_collation` char(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `body_utf8` longblob,
  PRIMARY KEY (`db`,`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Events';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `func`
--

DROP TABLE IF EXISTS `func`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `func` (
  `name` char(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `ret` tinyint(1) NOT NULL DEFAULT '0',
  `dl` char(128) COLLATE utf8_bin NOT NULL DEFAULT '',
  `type` enum('function','aggregate') CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User defined functions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `help_category`
--

DROP TABLE IF EXISTS `help_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `help_category` (
  `help_category_id` smallint(5) unsigned NOT NULL,
  `name` char(64) NOT NULL,
  `parent_category_id` smallint(5) unsigned DEFAULT NULL,
  `url` text NOT NULL,
  PRIMARY KEY (`help_category_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='help categories';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `help_keyword`
--

DROP TABLE IF EXISTS `help_keyword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `help_keyword` (
  `help_keyword_id` int(10) unsigned NOT NULL,
  `name` char(64) NOT NULL,
  PRIMARY KEY (`help_keyword_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='help keywords';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `help_relation`
--

DROP TABLE IF EXISTS `help_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `help_relation` (
  `help_topic_id` int(10) unsigned NOT NULL,
  `help_keyword_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`help_keyword_id`,`help_topic_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='keyword-topic relation';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `help_topic`
--

DROP TABLE IF EXISTS `help_topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `help_topic` (
  `help_topic_id` int(10) unsigned NOT NULL,
  `name` char(64) NOT NULL,
  `help_category_id` smallint(5) unsigned NOT NULL,
  `description` text NOT NULL,
  `example` text NOT NULL,
  `url` text NOT NULL,
  PRIMARY KEY (`help_topic_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='help topics';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `innodb_index_stats`
--

DROP TABLE IF EXISTS `innodb_index_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `innodb_index_stats` (
  `database_name` varchar(64) COLLATE utf8_bin NOT NULL,
  `table_name` varchar(64) COLLATE utf8_bin NOT NULL,
  `index_name` varchar(64) COLLATE utf8_bin NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `stat_name` varchar(64) COLLATE utf8_bin NOT NULL,
  `stat_value` bigint(20) unsigned NOT NULL,
  `sample_size` bigint(20) unsigned DEFAULT NULL,
  `stat_description` varchar(1024) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`database_name`,`table_name`,`index_name`,`stat_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin STATS_PERSISTENT=0;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `innodb_table_stats`
--

DROP TABLE IF EXISTS `innodb_table_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `innodb_table_stats` (
  `database_name` varchar(64) COLLATE utf8_bin NOT NULL,
  `table_name` varchar(64) COLLATE utf8_bin NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `n_rows` bigint(20) unsigned NOT NULL,
  `clustered_index_size` bigint(20) unsigned NOT NULL,
  `sum_of_other_index_sizes` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`database_name`,`table_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin STATS_PERSISTENT=0;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ndb_binlog_index`
--

DROP TABLE IF EXISTS `ndb_binlog_index`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ndb_binlog_index` (
  `Position` bigint(20) unsigned NOT NULL,
  `File` varchar(255) NOT NULL,
  `epoch` bigint(20) unsigned NOT NULL,
  `inserts` int(10) unsigned NOT NULL,
  `updates` int(10) unsigned NOT NULL,
  `deletes` int(10) unsigned NOT NULL,
  `schemaops` int(10) unsigned NOT NULL,
  `orig_server_id` int(10) unsigned NOT NULL,
  `orig_epoch` bigint(20) unsigned NOT NULL,
  `gci` int(10) unsigned NOT NULL,
  PRIMARY KEY (`epoch`,`orig_server_id`,`orig_epoch`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `plugin`
--

DROP TABLE IF EXISTS `plugin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plugin` (
  `name` varchar(64) NOT NULL DEFAULT '',
  `dl` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='MySQL plugins';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `proc`
--

DROP TABLE IF EXISTS `proc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `proc` (
  `db` char(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `name` char(64) NOT NULL DEFAULT '',
  `type` enum('FUNCTION','PROCEDURE') NOT NULL,
  `specific_name` char(64) NOT NULL DEFAULT '',
  `language` enum('SQL') NOT NULL DEFAULT 'SQL',
  `sql_data_access` enum('CONTAINS_SQL','NO_SQL','READS_SQL_DATA','MODIFIES_SQL_DATA') NOT NULL DEFAULT 'CONTAINS_SQL',
  `is_deterministic` enum('YES','NO') NOT NULL DEFAULT 'NO',
  `security_type` enum('INVOKER','DEFINER') NOT NULL DEFAULT 'DEFINER',
  `param_list` blob NOT NULL,
  `returns` longblob NOT NULL,
  `body` longblob NOT NULL,
  `definer` char(77) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `sql_mode` set('REAL_AS_FLOAT','PIPES_AS_CONCAT','ANSI_QUOTES','IGNORE_SPACE','NOT_USED','ONLY_FULL_GROUP_BY','NO_UNSIGNED_SUBTRACTION','NO_DIR_IN_CREATE','POSTGRESQL','ORACLE','MSSQL','DB2','MAXDB','NO_KEY_OPTIONS','NO_TABLE_OPTIONS','NO_FIELD_OPTIONS','MYSQL323','MYSQL40','ANSI','NO_AUTO_VALUE_ON_ZERO','NO_BACKSLASH_ESCAPES','STRICT_TRANS_TABLES','STRICT_ALL_TABLES','NO_ZERO_IN_DATE','NO_ZERO_DATE','INVALID_DATES','ERROR_FOR_DIVISION_BY_ZERO','TRADITIONAL','NO_AUTO_CREATE_USER','HIGH_NOT_PRECEDENCE','NO_ENGINE_SUBSTITUTION','PAD_CHAR_TO_FULL_LENGTH') NOT NULL DEFAULT '',
  `comment` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `character_set_client` char(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `collation_connection` char(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `db_collation` char(32) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `body_utf8` longblob,
  PRIMARY KEY (`db`,`name`,`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Stored Procedures';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `procs_priv`
--

DROP TABLE IF EXISTS `procs_priv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `procs_priv` (
  `Host` char(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Db` char(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `User` char(16) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Routine_name` char(64) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `Routine_type` enum('FUNCTION','PROCEDURE') COLLATE utf8_bin NOT NULL,
  `Grantor` char(77) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Proc_priv` set('Execute','Alter Routine','Grant') CHARACTER SET utf8 NOT NULL DEFAULT '',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Host`,`Db`,`User`,`Routine_name`,`Routine_type`),
  KEY `Grantor` (`Grantor`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Procedure privileges';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `proxies_priv`
--

DROP TABLE IF EXISTS `proxies_priv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `proxies_priv` (
  `Host` char(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `User` char(16) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Proxied_host` char(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Proxied_user` char(16) COLLATE utf8_bin NOT NULL DEFAULT '',
  `With_grant` tinyint(1) NOT NULL DEFAULT '0',
  `Grantor` char(77) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Host`,`User`,`Proxied_host`,`Proxied_user`),
  KEY `Grantor` (`Grantor`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User proxy privileges';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `servers`
--

DROP TABLE IF EXISTS `servers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `servers` (
  `Server_name` char(64) NOT NULL DEFAULT '',
  `Host` char(64) NOT NULL DEFAULT '',
  `Db` char(64) NOT NULL DEFAULT '',
  `Username` char(64) NOT NULL DEFAULT '',
  `Password` char(64) NOT NULL DEFAULT '',
  `Port` int(4) NOT NULL DEFAULT '0',
  `Socket` char(64) NOT NULL DEFAULT '',
  `Wrapper` char(64) NOT NULL DEFAULT '',
  `Owner` char(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`Server_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='MySQL Foreign Servers table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `slave_master_info`
--

DROP TABLE IF EXISTS `slave_master_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `slave_master_info` (
  `Number_of_lines` int(10) unsigned NOT NULL COMMENT 'Number of lines in the file.',
  `Master_log_name` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'The name of the master binary log currently being read from the master.',
  `Master_log_pos` bigint(20) unsigned NOT NULL COMMENT 'The master log position of the last read event.',
  `Host` char(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT 'The host name of the master.',
  `User_name` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT 'The user name used to connect to the master.',
  `User_password` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT 'The password used to connect to the master.',
  `Port` int(10) unsigned NOT NULL COMMENT 'The network port used to connect to the master.',
  `Connect_retry` int(10) unsigned NOT NULL COMMENT 'The period (in seconds) that the slave will wait before trying to reconnect to the master.',
  `Enabled_ssl` tinyint(1) NOT NULL COMMENT 'Indicates whether the server supports SSL connections.',
  `Ssl_ca` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT 'The file used for the Certificate Authority (CA) certificate.',
  `Ssl_capath` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT 'The path to the Certificate Authority (CA) certificates.',
  `Ssl_cert` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT 'The name of the SSL certificate file.',
  `Ssl_cipher` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT 'The name of the cipher in use for the SSL connection.',
  `Ssl_key` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT 'The name of the SSL key file.',
  `Ssl_verify_server_cert` tinyint(1) NOT NULL COMMENT 'Whether to verify the server certificate.',
  `Heartbeat` float NOT NULL,
  `Bind` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT 'Displays which interface is employed when connecting to the MySQL server',
  `Ignored_server_ids` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT 'The number of server IDs to be ignored, followed by the actual server IDs',
  `Uuid` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT 'The master server uuid.',
  `Retry_count` bigint(20) unsigned NOT NULL COMMENT 'Number of reconnect attempts, to the master, before giving up.',
  `Ssl_crl` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT 'The file used for the Certificate Revocation List (CRL)',
  `Ssl_crlpath` text CHARACTER SET utf8 COLLATE utf8_bin COMMENT 'The path used for Certificate Revocation List (CRL) files',
  `Enabled_auto_position` tinyint(1) NOT NULL COMMENT 'Indicates whether GTIDs will be used to retrieve events from the master.',
  PRIMARY KEY (`Host`,`Port`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 STATS_PERSISTENT=0 COMMENT='Master Information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `slave_relay_log_info`
--

DROP TABLE IF EXISTS `slave_relay_log_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `slave_relay_log_info` (
  `Number_of_lines` int(10) unsigned NOT NULL COMMENT 'Number of lines in the file or rows in the table. Used to version table definitions.',
  `Relay_log_name` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'The name of the current relay log file.',
  `Relay_log_pos` bigint(20) unsigned NOT NULL COMMENT 'The relay log position of the last executed event.',
  `Master_log_name` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'The name of the master binary log file from which the events in the relay log file were read.',
  `Master_log_pos` bigint(20) unsigned NOT NULL COMMENT 'The master log position of the last executed event.',
  `Sql_delay` int(11) NOT NULL COMMENT 'The number of seconds that the slave must lag behind the master.',
  `Number_of_workers` int(10) unsigned NOT NULL,
  `Id` int(10) unsigned NOT NULL COMMENT 'Internal Id that uniquely identifies this record.',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 STATS_PERSISTENT=0 COMMENT='Relay Log Information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `slave_worker_info`
--

DROP TABLE IF EXISTS `slave_worker_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `slave_worker_info` (
  `Id` int(10) unsigned NOT NULL,
  `Relay_log_name` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Relay_log_pos` bigint(20) unsigned NOT NULL,
  `Master_log_name` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Master_log_pos` bigint(20) unsigned NOT NULL,
  `Checkpoint_relay_log_name` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Checkpoint_relay_log_pos` bigint(20) unsigned NOT NULL,
  `Checkpoint_master_log_name` text CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `Checkpoint_master_log_pos` bigint(20) unsigned NOT NULL,
  `Checkpoint_seqno` int(10) unsigned NOT NULL,
  `Checkpoint_group_size` int(10) unsigned NOT NULL,
  `Checkpoint_group_bitmap` blob NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 STATS_PERSISTENT=0 COMMENT='Worker Information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tables_priv`
--

DROP TABLE IF EXISTS `tables_priv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tables_priv` (
  `Host` char(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Db` char(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `User` char(16) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Table_name` char(64) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Grantor` char(77) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Table_priv` set('Select','Insert','Update','Delete','Create','Drop','Grant','References','Index','Alter','Create View','Show view','Trigger') CHARACTER SET utf8 NOT NULL DEFAULT '',
  `Column_priv` set('Select','Insert','Update','References') CHARACTER SET utf8 NOT NULL DEFAULT '',
  PRIMARY KEY (`Host`,`Db`,`User`,`Table_name`),
  KEY `Grantor` (`Grantor`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table privileges';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `time_zone`
--

DROP TABLE IF EXISTS `time_zone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `time_zone` (
  `Time_zone_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Use_leap_seconds` enum('Y','N') NOT NULL DEFAULT 'N',
  PRIMARY KEY (`Time_zone_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Time zones';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `time_zone_leap_second`
--

DROP TABLE IF EXISTS `time_zone_leap_second`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `time_zone_leap_second` (
  `Transition_time` bigint(20) NOT NULL,
  `Correction` int(11) NOT NULL,
  PRIMARY KEY (`Transition_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Leap seconds information for time zones';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `time_zone_name`
--

DROP TABLE IF EXISTS `time_zone_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `time_zone_name` (
  `Name` char(64) NOT NULL,
  `Time_zone_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`Name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Time zone names';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `time_zone_transition`
--

DROP TABLE IF EXISTS `time_zone_transition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `time_zone_transition` (
  `Time_zone_id` int(10) unsigned NOT NULL,
  `Transition_time` bigint(20) NOT NULL,
  `Transition_type_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`Time_zone_id`,`Transition_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Time zone transitions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `time_zone_transition_type`
--

DROP TABLE IF EXISTS `time_zone_transition_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `time_zone_transition_type` (
  `Time_zone_id` int(10) unsigned NOT NULL,
  `Transition_type_id` int(10) unsigned NOT NULL,
  `Offset` int(11) NOT NULL DEFAULT '0',
  `Is_DST` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Abbreviation` char(8) NOT NULL DEFAULT '',
  PRIMARY KEY (`Time_zone_id`,`Transition_type_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Time zone transition types';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `Host` char(60) COLLATE utf8_bin NOT NULL DEFAULT '',
  `User` char(16) COLLATE utf8_bin NOT NULL DEFAULT '',
  `Password` char(41) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL DEFAULT '',
  `Select_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Insert_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Update_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Delete_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Drop_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Reload_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Shutdown_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Process_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `File_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Grant_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `References_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Index_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Alter_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Show_db_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Super_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_tmp_table_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Lock_tables_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Execute_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Repl_slave_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Repl_client_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_view_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Show_view_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_routine_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Alter_routine_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_user_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Event_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Trigger_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `Create_tablespace_priv` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  `ssl_type` enum('','ANY','X509','SPECIFIED') CHARACTER SET utf8 NOT NULL DEFAULT '',
  `ssl_cipher` blob NOT NULL,
  `x509_issuer` blob NOT NULL,
  `x509_subject` blob NOT NULL,
  `max_questions` int(11) unsigned NOT NULL DEFAULT '0',
  `max_updates` int(11) unsigned NOT NULL DEFAULT '0',
  `max_connections` int(11) unsigned NOT NULL DEFAULT '0',
  `max_user_connections` int(11) unsigned NOT NULL DEFAULT '0',
  `plugin` char(64) COLLATE utf8_bin DEFAULT '',
  `authentication_string` text COLLATE utf8_bin,
  `password_expired` enum('N','Y') CHARACTER SET utf8 NOT NULL DEFAULT 'N',
  PRIMARY KEY (`Host`,`User`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Users and global privileges';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `general_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `general_log` (
  `event_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_host` mediumtext NOT NULL,
  `thread_id` bigint(21) unsigned NOT NULL,
  `server_id` int(10) unsigned NOT NULL,
  `command_type` varchar(64) NOT NULL,
  `argument` mediumtext NOT NULL
) ENGINE=CSV DEFAULT CHARSET=utf8 COMMENT='General log';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `slow_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `slow_log` (
  `start_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_host` mediumtext NOT NULL,
  `query_time` time NOT NULL,
  `lock_time` time NOT NULL,
  `rows_sent` int(11) NOT NULL,
  `rows_examined` int(11) NOT NULL,
  `db` varchar(512) NOT NULL,
  `last_insert_id` int(11) NOT NULL,
  `insert_id` int(11) NOT NULL,
  `server_id` int(10) unsigned NOT NULL,
  `sql_text` mediumtext NOT NULL,
  `thread_id` bigint(21) unsigned NOT NULL
) ENGINE=CSV DEFAULT CHARSET=utf8 COMMENT='Slow log';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `sequence`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sequence` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `sequence`;

--
-- Table structure for table `account_sequence`
--

DROP TABLE IF EXISTS `account_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `account_sequence` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2098 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `test`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `test` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `test`;

--
-- Current Database: `traversing_1`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `traversing_1` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `traversing_1`;

--
-- Table structure for table `tb_test`
--

DROP TABLE IF EXISTS `tb_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_test` (
  `uid` int(11) NOT NULL,
  `items` mediumblob,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `traversing_2`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `traversing_2` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `traversing_2`;

--
-- Table structure for table `tb_test`
--

DROP TABLE IF EXISTS `tb_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_test` (
  `uid` int(11) NOT NULL,
  `items` mediumblob,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `traversing_3`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `traversing_3` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `traversing_3`;

--
-- Table structure for table `tb_test`
--

DROP TABLE IF EXISTS `tb_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_test` (
  `uid` int(11) NOT NULL,
  `items` mediumblob,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `traversing_4`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `traversing_4` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `traversing_4`;

--
-- Table structure for table `tb_test`
--

DROP TABLE IF EXISTS `tb_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_test` (
  `uid` int(11) NOT NULL,
  `items` mediumblob,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Current Database: `traversing_master`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `traversing_master` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `traversing_master`;

--
-- Table structure for table `configs`
--

DROP TABLE IF EXISTS `configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `configs` (
  `config_key` varchar(32) NOT NULL,
  `config_value` mediumblob,
  PRIMARY KEY (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-06-10 11:29:56
