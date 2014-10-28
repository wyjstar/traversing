ALTER TABLE tb_character_info  ADD INDEX nickname(nickname);
DROP TABLE IF EXISTS `tb_character_heros`;
DROP TABLE IF EXISTS `tb_character_equipments`;
DROP TABLE IF EXISTS `tb_character_mails`;

DROP TABLE IF EXISTS `tb_pvp_rank`;
CREATE TABLE `tb_pvp_rank` (
  `id` bigint(20) NOT NULL,
  `nickname` varchar(128) DEFAULT '',
  `level` int(11) NOT NULL DEFAULT '1',
  `units` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
