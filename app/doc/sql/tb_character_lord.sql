DROP TABLE IF EXISTS `tb_character_lord`;
CREATE TABLE `tb_character_lord` (
  `id` bigint(20) NOT NULL,
  `attr_info` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
