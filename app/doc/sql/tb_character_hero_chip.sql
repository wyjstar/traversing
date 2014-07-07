DROP TABLE IF EXISTS `tb_character_hero_chip`;

CREATE TABLE `tb_character_hero_chip` (
  `id` varchar(50) not null,
  `hero_chips` blob NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

