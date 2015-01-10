# coding:utf8
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
    # 帐号表
    MAdminManager().registe(memmode.tb_account)
    # 用户阵容信息
    MAdminManager().registe(memmode.tb_character_line_up)
    # 公会信息表
    MAdminManager().registe(memmode.tb_guild_info)
    # 玩家公会表
    MAdminManager().registe(memmode.tb_guild_name)
    # 活跃度
    MAdminManager().registe(memmode.tb_character_tasks)


def check_mem_db(delta):
    """同步内存数据到数据库
    """
    MAdminManager().checkAdmins()
    reactor.callLater(delta, check_mem_db, delta)
