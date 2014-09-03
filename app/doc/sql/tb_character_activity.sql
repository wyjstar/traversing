SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `tb_character_activity`;
CREATE TABLE `tb_character_activity` (
  `id` bigint(20) NOT NULL,
  `sign_in` blob,
  `online_gift` blob,
  `level_gift` blob,
  `feast` bigint(20),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
