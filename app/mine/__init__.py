#-*- coding:utf-8 -*-
import action
from service.node import minegateservice
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.logobj import logger


def doWhenStop():
    """服务器关闭前的处理
    """
    print "##############################"
    print "##########checkAdmins#############"
    print "##############################"
    # MAdminManager().checkAdmins()


GlobalObject().stophandler = doWhenStop
