# -*- coding:utf-8 -*-
"""
created by server on 14-8-18上午10:39.
"""

from app.proto_file.db_pb2 import Mail_PB
import time


def init_mail(player):

    # 领取体力
    mail = Mail_PB()

    mail.mail_id = '001'
    mail.character_id = 1
    mail.sender_id = 2
    mail.sender_name = 'player2'
    mail.title = 'mail1'
    mail.content = 'content1'
    mail.mail_type = 1
    mail.is_readed = False
    mail.send_time = 100

    player.mail_component.add_exist_mail(mail)

    mail.mail_id = '002'
    mail.character_id = 1
    mail.sender_id = 2
    mail.sender_name = 'player2'
    mail.title = 'mail2'
    mail.content = 'content2'
    mail.mail_type = 1
    mail.is_readed = False
    mail.send_time = int(time.time())

    player.mail_component.add_exist_mail(mail)

    # 领奖
    mail.mail_id = '003'
    mail.character_id = 1
    mail.sender_id = -1
    mail.sender_name = 'system'
    mail.title = 'mail3'
    mail.content = 'content3'
    mail.mail_type = 2
    mail.is_readed = False
    mail.send_time = int(time.time())
    mail.prize = {1: [100, 100, 0]}

    player.mail_component.add_exist_mail(mail)

    mail.mail_id = '004'
    mail.character_id = 1
    mail.sender_id = -1
    mail.sender_name = 'system'
    mail.title = 'mail4'
    mail.content = 'content4'
    mail.mail_type = 2
    mail.is_readed = False
    mail.send_time = int(time.time())
    mail.prize = {1: [100, 100, 0]}

    player.mail_component.add_exist_mail(mail)

    # 公告
    mail.mail_id = '005'
    mail.character_id = 1
    mail.sender_id = -1
    mail.sender_name = 'system'
    mail.title = 'mail5'
    mail.content = 'content5'
    mail.mail_type = 3
    mail.is_readed = False
    mail.send_time = int(time.time())

    player.mail_component.add_exist_mail(mail)

    mail.mail_id = '006'
    mail.character_id = 1
    mail.sender_id = -1
    mail.sender_name = 'system'
    mail.title = 'mail6'
    mail.content = 'content6'
    mail.mail_type = 3
    mail.is_readed = True
    mail.read_time = int(time.time())-60*60*24*7

    player.mail_component.add_exist_mail(mail)

    # 消息
    mail.mail_id = '007'
    mail.character_id = 1
    mail.sender_id = 2
    mail.sender_name = 'player2'
    mail.title = 'mail7'
    mail.content = 'content7'
    mail.mail_type = 4
    mail.is_readed = False
    mail.send_time = int(time.time())

    player.mail_component.add_exist_mail(mail)

    mail.mail_id = '008'
    mail.character_id = 1
    mail.sender_id = 2
    mail.sender_name = 'player2'
    mail.title = 'mail8'
    mail.content = 'content8'
    mail.mail_type = 4
    mail.is_readed = False
    mail.send_time = int(time.time())

    player.mail_component.add_exist_mail(mail)
