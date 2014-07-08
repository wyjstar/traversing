DROP TABLE IF EXISTS `tb_character_hero`;

CREATE TABLE `tb_character_hero` (
  `id` varchar(50) not null,
  `character_id` bigint(20) NOT NULL,
  `property` blob NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
