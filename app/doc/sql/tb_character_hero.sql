DROP TABLE IF EXISTS `tb_character_hero`;

CREATE TABLE `tb_character_hero` (
  `id` varchar(50) not null,
  `character_id` bigint(20) NOT NULL,
  `hero_no` int(10) NOT NULL,
  `level` int(10) NOT NULL,
  `break_level` tinyint(10) NOT NULL,
  `exp` int(10) NOT NULL,
  `equipment_ids` blob NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
