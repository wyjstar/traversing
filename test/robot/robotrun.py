# -*- coding:utf-8 -*-


from fsmmanager import FsmManager
from twisted.internet import reactor
from fsm import FsmCommand

fsm_manager = FsmManager(FsmCommand)


def tick():
    fsm_manager.frame()
    reactor.callLater(0, tick)


if __name__ == '__main__':
    reactor.callLater(0, tick)
    reactor.run()
