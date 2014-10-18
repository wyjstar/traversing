

DROP TABLE IF EXISTS `tb_nickname_mapping`;


ALTER TABLE tb_character_info  ADD INDEX nickname(nickname);