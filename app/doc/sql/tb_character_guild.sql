SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `tb_character_guild`;
CREATE TABLE `tb_character_guild` (
  `id` varchar(32) NOT NULL,
  `info` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
