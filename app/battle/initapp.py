#-*- coding:utf-8 -*-
"""
created by server on 14-5-19下午4:31.
"""
from gfirefly.server.globalobject import GlobalObject


def doWhenStop():
    """服务器关闭前的处理
    """
    print "##############################"
    print "##########checkAdmins#############"
    print "##############################"
    # MAdminManager().checkAdmins()


GlobalObject().stophandler = doWhenStop


def load_module():
    pass