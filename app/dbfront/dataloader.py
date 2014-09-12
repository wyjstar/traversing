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
    MAdminManager().registe(memmode.tb_character_info)
    MAdminManager().registe(memmode.tb_account)
    MAdminManager().registe(memmode.tb_account_mapping)
    MAdminManager().registe(memmode.tb_character_equipment_chip)

    MAdminManager().registe(memmode.tb_character_equipments)
    MAdminManager().registe(memmode.tb_equipment_info)
    MAdminManager().registe(memmode.tb_character_friend)
    MAdminManager().registe(memmode.tb_character_activity)


def check_mem_db(delta):
    """同步内存数据到数据库
    """
    MAdminManager().checkAdmins()
    reactor.callLater(delta, check_mem_db, delta)

