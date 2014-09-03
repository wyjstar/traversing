-- MySQL dump 10.13  Distrib 5.6.17, for Linux (x86_64)
--
-- Host: localhost    Database: account_1
-- ------------------------------------------------------
-- Server version	5.6.17
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
  `create_time` int(11) NOT NULL,
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
-- Table structure for table `tb_name_mapping`
--

DROP TABLE IF EXISTS `tb_name_mapping`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_name_mapping` (
  `account_name` varchar(20) NOT NULL,
  `id` bigint(20) NOT NULL,
  PRIMARY KEY (`account_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- Dump completed on 2014-08-02 16:44:57
