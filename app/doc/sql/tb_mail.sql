DROP TABLE IF EXISTS `tb_mail`;

CREATE TABLE `tb_mail` (
  `id` varchar(50) NOT NULL,
  `title` varchar(255) DEFAULT '' COMMENT '邮件标题',
  `senderId` int(11) DEFAULT '-1' COMMENT '发送邮件的角色ID  当为-1时,将认为是一封由系统产生的邮件,将由type字段提供支持 = -1',
  `sender` varchar(255) NOT NULL DEFAULT '' COMMENT '发送者的名称',
  `receiverId` int(11) DEFAULT NULL COMMENT '接受人id',
  `type` int(11) DEFAULT '1' COMMENT '邮件的类型（0.  1.',
  `content` varchar(255) DEFAULT '' COMMENT '邮件的内容',
  `isReaded` tinyint(4) DEFAULT '0' COMMENT '是否已经读=0',
  `sendTime` datetime NOT NULL DEFAULT '2011-08-10 14:57:49' COMMENT '发送时间',
  `staminaContains` int(20) DEFAULT '0' COMMENT '包含的体力',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2355 DEFAULT CHARSET=utf8;