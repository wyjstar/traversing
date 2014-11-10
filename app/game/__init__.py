#-*- coding:utf-8 -*-
"""
created by server on 14-5-27下午5:21.
"""
import action
from shared.db_opear.configs_data import game_configs
from gfirefly.dbentrust.madminanager import MAdminManager
from gfirefly.server.globalobject import GlobalObject


def doWhenStop():
    """服务器关闭前的处理
    """
    print "##############################"
    print "##########checkAdmins#############"
    print "##############################"
    MAdminManager().checkAdmins()


GlobalObject().stophandler = doWhenStop
