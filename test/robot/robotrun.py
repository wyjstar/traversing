# -*- coding:utf-8 -*-


from fsmmanager import fsm_manager
from twisted.internet import reactor


def tick():
    print 'tick 1'
    fsm_manager.frame()
    reactor.callLater(0, tick)


if __name__ == '__main__':
    print 'begin'
    reactor.callLater(0, tick)
    reactor.run()
