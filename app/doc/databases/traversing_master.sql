-- MySQL dump 10.13  Distrib 5.6.19, for osx10.7 (x86_64)
--
-- Host: localhost    Database: traversing_master
-- ------------------------------------------------------
-- Server version	5.6.19


--
-- Table structure for table `configs`
--

DROP TABLE IF EXISTS `configs`;
CREATE TABLE `configs` (
  `config_key` varchar(32) NOT NULL,
  `config_value` mediumblob,
  PRIMARY KEY (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- Dump completed on 2014-09-29 15:46:10
