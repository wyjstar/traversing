DROP TABLE IF EXISTS `tb_character_friend`;
CREATE TABLE `tb_character_friend` (
  `id` bigint(20) NOT NULL,
  `friends` mediumblob,
  `blacklist` mediumblob,
  `applicants_list` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
