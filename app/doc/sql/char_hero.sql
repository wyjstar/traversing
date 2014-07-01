/* 1 */
use `traversing_1`;
DROP TABLE IF EXISTS `tb_char_hero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE `tb_char_hero` (
  `id` bigint(20) not null AUTO_INCREMENT,
  `characterid` bigint(20) NOT NULL,
  `hero_no` char(50) NOT NULL,
  `level` tinyint(10) NOT NULL,
  `break_level` tinyint(10) NOT NULL,
  `exp` smallint(20) NOT NULL,
  `equipment_ids` varchar(1000) NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/* 2 */
use `traversing_2`;
DROP TABLE IF EXISTS `tb_char_hero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE `tb_char_hero` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `characterid` bigint(20) NOT NULL,
  `hero_no` char(50) NOT NULL,
  `level` tinyint(10) NOT NULL,
  `break_level` tinyint(10) NOT NULL,
  `exp` smallint(20) NOT NULL,
  `equipment_ids` varchar(1000) NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* 3 */
use `traversing_3`;
DROP TABLE IF EXISTS `tb_char_hero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_char_hero` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `characterid` bigint(20) NOT NULL,
  `hero_no` char(50) NOT NULL,
  `level` tinyint(10) NOT NULL,
  `break_level` tinyint(10) NOT NULL,
  `exp` smallint(20) NOT NULL,
  `equipment_ids` varchar(1000) NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* 4 */
use `traversing_4`;
DROP TABLE IF EXISTS `tb_char_hero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_char_hero` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `characterid` bigint(20) NOT NULL,
  `hero_no` char(50) NOT NULL,
  `level` tinyint(10) NOT NULL,
  `break_level` tinyint(10) NOT NULL,
  `exp` smallint(20) NOT NULL,
  `equipment_ids` varchar(1000) NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

