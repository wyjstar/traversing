DROP TABLE IF EXISTS `tb_character_info`;

CREATE TABLE `tb_character_info` (
  `uid` bigint(20) NOT NULL,
  `nickname` char(50) NOT NULL,
  `createdate` datetime NOT NULL,
  `hero_list` blob not null,
  `hero_chip_list` blob not null,
 PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
