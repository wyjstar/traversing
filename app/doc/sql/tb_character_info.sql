DROP TABLE IF EXISTS `tb_character_info`;

CREATE TABLE `tb_character_info` (
  `uid` bigint(20) NOT NULL,
  `nickname` char(50) NOT NULL,
  `createdate` datetime NOT NULL,
  `coin` int not null,
  `hero_soul` int not null,
  `gold` int not null,
 PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
