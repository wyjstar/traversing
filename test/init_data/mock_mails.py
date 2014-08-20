# -*- coding:utf-8 -*-
"""
created by server on 14-8-18上午10:39.
"""

from app.game.core.mail import Mail
from app.game.core.PlayersManager import PlayersManager
import time
from shared.utils.const import const


def init_mail():

    player = PlayersManager().get_player_by_id(1)
    # 领取体力
    mail = Mail(mail_id='001', character_id=1, sender_id=2, sender_name='player2', title='mail1', content='content1',
                mail_type=1, is_readed=False, send_time=100)

    player.mail_component.add_exist_mail(mail)

    mail = Mail(mail_id='002', character_id=1, sender_id=2, sender_name='player2', title='mail2', content='content2',
                mail_type=1, is_readed=False, send_time=int(time.time()))

    player.mail_component.add_exist_mail(mail)

    # 领奖
    mail = Mail(mail_id='003', character_id=1, sender_id=-1, sender_name='system', title='mail3', content='content3',
                mail_type=2, is_readed=False, send_time=int(time.time()), prize={1: [100, 100, 0]})

    player.mail_component.add_exist_mail(mail)

    mail = Mail(mail_id='004', character_id=1, sender_id=-1, sender_name='system', title='mail4', content='content4',
                mail_type=2, is_readed=False, send_time=int(time.time()), prize={1: [100, 100, 0]})

    player.mail_component.add_exist_mail(mail)

    # 公告
    mail = Mail(mail_id='005', character_id=1, sender_id=-1, sender_name='system', title='mail5', content='content5',
                mail_type=3, is_readed=False, send_time=int(time.time()))

    player.mail_component.add_exist_mail(mail)

    mail = Mail(mail_id='006', character_id=1, sender_id=-1, sender_name='system', title='mail6', content='content6',
                mail_type=3, is_readed=True, read_time=int(time.time())-60*60*24*7)

    player.mail_component.add_exist_mail(mail)

    # 消息
    mail = Mail(mail_id='007', character_id=1, sender_id=2, sender_name='player2', title='mail7', content='content7',
                mail_type=4, is_readed=False, send_time=int(time.time()))

    player.mail_component.add_exist_mail(mail)

    mail = Mail(mail_id='008', character_id=1, sender_id=2, sender_name='player2', title='mail8', content='content8',
                mail_type=4, is_readed=False, send_time=int(time.time()))

    player.mail_component.add_exist_mail(mail)