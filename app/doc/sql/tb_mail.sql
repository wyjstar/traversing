DROP TABLE IF EXISTS `tb_character_mails`;

CREATE TABLE `tb_character_mails` (
  `id` bigint(20),
  `mail_ids` blob NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `tb_mail_info`;

CREATE TABLE `tb_mail_info` (
  `id` varchar(50) NOT NULL,
  `character_id` bigint(20) NOT NULL,
  `property` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;