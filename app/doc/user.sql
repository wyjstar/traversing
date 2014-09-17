DROP TABLE IF EXISTS tb_user;
CREATE TABLE tb_user (
  `id`         VARCHAR(32)         NOT NULL,
  `account_name` VARCHAR(20) DEFAULT NULL,
  `account_password` VARCHAR(32) DEFAULT NULL,
  `last_login`   INT(11)             NOT NULL,
  `create_time`  INT(11)             NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_name` (`account_name`)
)
  ENGINE =InnoDB
  DEFAULT CHARSET =utf8;

