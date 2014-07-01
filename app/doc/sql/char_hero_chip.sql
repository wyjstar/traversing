/* 1 */
use `traversing_1`;
DROP TABLE IF EXISTS `tb_char_hero_chip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE `tb_char_hero_chip` (
  `id` bigint(20) not null,
  `characterid` bigint(20) NOT NULL,
  `hero_chip_no` char(50) NOT NULL,
  `num` smallint(10) NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/* 2 */
use `traversing_2`;
DROP TABLE IF EXISTS `tb_char_hero_chip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;

CREATE TABLE `tb_char_hero_chip` (
  `id` bigint(20) NOT NULL,
  `characterid` bigint(20) NOT NULL,
  `hero_chip_no` char(50) NOT NULL,
  `num` smallint(10) NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* 3 */
use `traversing_3`;
DROP TABLE IF EXISTS `tb_char_hero_chip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_char_hero_chip` (
  `id` bigint(20) NOT NULL,
  `characterid` bigint(20) NOT NULL,
  `hero_chip_no` char(50) NOT NULL,
  `num` smallint(10) NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* 4 */
use `traversing_4`;
DROP TABLE IF EXISTS `tb_char_hero_chip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_char_hero_chip` (
  `id` bigint(20) NOT NULL,
  `characterid` bigint(20) NOT NULL,
  `hero_chip_no` char(50) NOT NULL,
  `num` smallint(10) NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

