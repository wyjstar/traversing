SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `tb_character_activity`;
CREATE TABLE `tb_character_activity` (
  `id` bigint(20) NOT NULL,
  `sign_in` blob,
  `online_gift` blob,
  `level_gift` blob,
  `feast` int default 0,
  `login_gift` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
