ALTER TABLE tb_character_info ADD column pvp_count bigint(20) NOT NULL DEFAULT '0';
ALTER TABLE tb_character_info ADD column pvp_score bigint(20) NOT NULL DEFAULT '0';
ALTER TABLE tb_character_stages ADD column sweep_times mediumblob NOT NULL;
ALTER TABLE tb_character_stages ADD column stage_up_time bigint(20) NOT NULL;
ALTER TABLE tb_pvp_rank ADD column hero_ids tinyblob NOT NULL;
DROP TABLE IF EXISTS `tb_character_lively`;
CREATE TABLE `tb_character_lively` (
  `id` bigint(20) NOT NULL,
  `lively` int(11) NOT NULL,
  `tasks` mediumblob,
  `event_map` mediumblob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE tb_character_lively ADD column last_day varchar(8);
