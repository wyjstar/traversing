DROP TABLE IF EXISTS `tb_character_hero_chip`;

CREATE TABLE `tb_character_hero_chip` (
  `id` varchar(50) not null,
  `character_id` bigint(20) NOT NULL,
  `hero_chip_no` char(50) NOT NULL,
  `num` int(10) NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

