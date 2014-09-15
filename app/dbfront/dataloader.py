#coding:utf8
"""

"""
import memmode
from gfirefly.dbentrust.madminanager import MAdminManager
from gtwisted.core import reactor
reactor = reactor


def register_madmin():
    """注册数据库与memcached对应
    """

    # 用户信息表
    MAdminManager().registe(memmode.tb_character_info)
    # 用户英雄信息
    MAdminManager().registe(memmode.tb_character_heros)
    # 英雄信息表
    MAdminManager().registe(memmode.tb_character_hero)
    # 用户英雄碎片信息表
    MAdminManager().registe(memmode.tb_character_hero_chip)
    # 用户道具背包
    MAdminManager().registe(memmode.tb_character_item_package)
    # 帐号表
    MAdminManager().registe(memmode.tb_account)
    # 用户阵容信息
    MAdminManager().registe(memmode.tb_character_line_up)
    # 帐号匹配表
    MAdminManager().registe(memmode.tb_account_mapping)
    # 装备碎片表
    MAdminManager().registe(memmode.tb_character_equipment_chip)
    # 用户装备列表
    MAdminManager().registe(memmode.tb_character_equipments)
    # 装备信息表
    MAdminManager().registe(memmode.tb_equipment_info)
    # friend表
    MAdminManager().registe(memmode.tb_character_friend)
    # 公会信息表
    MAdminManager().registe(memmode.tb_guild_info)
    # 玩家公会表
    MAdminManager().registe(memmode.tb_guild_name)
    # 玩家公会表
    MAdminManager().registe(memmode.tb_character_guild)
    # 玩家活动表
    MAdminManager().registe(memmode.tb_character_activity)
    # 主将信息表
    MAdminManager().registe(memmode.tb_character_lord)
    # 关卡信息表
    MAdminManager().registe(memmode.tb_character_stages)
    # 昵称表
    MAdminManager().registe(memmode.tb_nickname_mapping)
    # 玩家邮件表
    MAdminManager().registe(memmode.tb_character_mails)
    # 邮件表
    MAdminManager().registe(memmode.tb_mail_info)

def check_mem_db(delta):
    """同步内存数据到数据库
    """
    print '>>>>>>>>>>>>>>: check mem db'
    MAdminManager().checkAdmins()
    reactor.callLater(delta, check_mem_db, delta)

