# -*- coding:utf-8 -*-
import action
from gtwisted.core import reactor
from app.push.core.pusher import pusher
# from gfirefly.server.logobj import logger


def do_push():
    pusher.gen_task()
    pusher.process()
    reactor.callLater(10, do_push)
#     logger.info('push data num:%s', 1)

reactor.callLater(10, do_push)
