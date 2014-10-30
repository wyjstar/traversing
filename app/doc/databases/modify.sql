#ALTER TABLE tb_character_info ADD column pvp_count bigint(20) NOT NULL DEFAULT '0';
#ALTER TABLE tb_character_info ADD column pvp_score bigint(20) NOT NULL DEFAULT '0';
ALTER TABLE tb_character_stages ADD column sweep_times mediumblob NOT NULL;
ALTER TABLE tb_character_stages ADD column stage_up_time bigint(20) NOT NULL;

