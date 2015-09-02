# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:16.
"""

import test.unittest.init_data.init_connection
import unittest
from app.game.logic.mail import *
from app.game.service.gatenoteservice import remoteservice
from app.game.core.PlayersManager import PlayersManager
from app.proto_file.mailbox_pb2 import *


class MailActionTest(unittest.TestCase):
    def setUp(self):
        from test.unittest.init_test_data import init

        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_get_all_mail_info_1301(self):
        response_data = get_mails(1)
        response = GetMailInfos()
        response.ParseFromString(response_data)

        mails = [mail for mail in response.mails]
        self.assertEqual(len(mails), 7, "%d_%d" % (len(mails), 7))
        first_index = 0
        for i in range(len(mails)):
            if mails[i].mail_id == "001":
                first_index = i
        # first
        first = mails[first_index]
        self.assertEqual(first.mail_id, '001', "%s_%s" % (first.mail_id, '001'))
        self.assertEqual(first.sender_id, 2, "%d_%d" % (first.sender_id, 2))
        self.assertEqual(first.sender_name, 'player2', "%s_%s" % (first.sender_name, "player2"))
        self.assertEqual(first.title, 'mail1', "%s_%s" % (first.title, 'title1'))
        self.assertEqual(first.content, 'content1', "%s_%s" % (first.content, 'content1'))
        self.assertEqual(first.mail_type, 1, "%d_%d" % (first.mail_type, 1))
        self.assertEqual(first.send_time, 100, "%d_%d" % (first.send_time, 100))
        self.assertEqual(first.is_readed, False)

    def test_read_mail_1302(self):
        # 赠送体力
        response_data = read_mail(1, ['001'], 1)
        response = ReadMailResponse()
        response.ParseFromString(response_data)
        print response, "read_mail"
        mail = self.player.mail_component.get_mail('001')
        self.assertEqual(mail, None)
        # 领奖
        read_mail(1, ['003'], 2)
        mail = self.player.mail_component.get_mail('003')
        self.assertEqual(mail, None)
        # 公告 / 消息
        read_mail(1, ['005'], 3)
        read_mail(1, ['007'], 4)
        mail = self.player.mail_component.get_mail('005')
        self.assertTrue(mail.is_readed)
        mail = self.player.mail_component.get_mail('007')
        self.assertTrue(mail.is_readed)

    def test_delete_mail_1303(self):
        delete_mail(1, ['001', '002', '003'])
        mail = self.player.mail_component.get_mail('001')
        self.assertEqual(mail, None)
        mail = self.player.mail_component.get_mail('002')
        self.assertEqual(mail, None)
        mail = self.player.mail_component.get_mail('003')
        self.assertEqual(mail, None)

