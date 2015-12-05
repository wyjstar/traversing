# -*- coding:utf-8 -*-
from app.proto_file.db_pb2 import Mail_PB
import time
# from gfirefly.server.logobj import logger


def deal_mail(conf_id=0, nickname='', receive_id=0, guild_name='',
              guild_p_num=0, guild_level=0, guild_id=0, pvp_rank=0,
              rune_num=0, rank=0, integral=0, boss_id=0, arg1='',
              prize=''):
    mail = Mail_PB()
    if arg1:
        mail.arg1 = arg1
    if conf_id:
        mail.config_id = conf_id
    if nickname:
        mail.nickname = nickname
    if boss_id:
        mail.boss_id = boss_id
    if guild_name:
        mail.guild_name = guild_name
    if guild_p_num:
        mail.guild_person_num = guild_p_num
    if guild_level:
        mail.guild_level = guild_level
    if guild_id:
        mail.guild_id = guild_id
    if pvp_rank:
        mail.pvp_rank = pvp_rank
    if rune_num:
        mail.rune_num = rune_num
    if prize:
        mail.prize = prize
    if rank:
        mail.rank = rank
    if integral:
        mail.integral = integral
    mail.send_time = int(time.time())
    mail_data = mail.SerializePartialToString()
    return mail_data, receive_id
