# coding:utf8
'''
Created on 2014-2-24

@author: lan (www.9miao.com)
'''
from gfirefly.server.globalobject import GlobalObject, masterserviceHandle
from gtwisted.core import reactor
from gfirefly.server.logobj import logger

reactor = reactor


@masterserviceHandle
def serverStop():
    """供master调用的接口：关闭服务器
    """
    logger.info('stop')
    if GlobalObject().stophandler:
        GlobalObject().stophandler()
    reactor.callLater(0.5, reactor.stop)
    return True


@masterserviceHandle
def sreload():
    """供master调用的接口：热更新模块
    """
    logger.info('reload')
    if GlobalObject().reloadmodule:
        reload(GlobalObject().reloadmodule)
    return True


@masterserviceHandle
def remote_connect(rname, rhost):
    """供master调用的接口：进行远程的rpc连接
    """
    GlobalObject().remote_connect(rname, rhost)
