#-*- coding:utf-8 -*-
import action
from service.node import chatgateservice

from gfirefly.server.globalobject import GlobalObject


def doWhenStop():
    """服务器关闭前的处理
    """
    print "##############################"
    print "##########checkAdmins#############"
    print "##############################"
    # MAdminManager().checkAdmins()


GlobalObject().stophandler = doWhenStop
