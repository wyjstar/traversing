#-*- coding:utf-8 -*-
import action
from service.node import pushgateservice
from gtwisted.core import reactor
from gfirefly.server.globalobject import GlobalObject
from app.push.core.pusher import Pusher
from gfirefly.server.logobj import logger


def doWhenStop():
    """服务器关闭前的处理
    """
    print "##############################"
    print "##########checkAdmins#############"
    print "##############################"
    # MAdminManager().checkAdmins()


GlobalObject().stophandler = doWhenStop

def do_push():
    push = Pusher()
    push.gen_task()
    push.process()
    reactor.callLater(10, do_push)
    logger.info('push data num:%s', 1)
    

reactor.callLater(10, do_push)
