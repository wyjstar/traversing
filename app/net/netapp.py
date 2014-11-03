#coding:utf8
'''
Created on 2013-8-14

@author: lan (www.9miao.com)
'''
from gfirefly.server.globalobject import GlobalObject
from gfirefly.utils.services import CommandService
from gfirefly.server.logobj import logger


class NetCommandService(CommandService):
    
    def callTarget(self, targetKey, *args, **kw):
        '''call Target by Single
        @param conn: client connection
        @param targetKey: target ID
        @param data: client data
        '''
        target = self.getTarget(0)
        if not target:
            logger.error('the command '+str(targetKey)+' not Found on service')
            return None
        if targetKey not in self.unDisplay:
            logger.info("call method %s on service[single]" % target.__name__)
        print "#net"
        response = target(targetKey, *args, **kw)
        return response

netservice = NetCommandService("NetService")


def netserviceHandle(target):
    """
    """
    netservice.mapTarget(target)

GlobalObject().netfactory.addServiceChannel(netservice)


@netserviceHandle
def Forwarding_0(keyname, _conn, data):
    """消息转发，将客户端发送的消息请求转发给gateserver分配处理
    """
    logger.info("forwarding_0++++++++++++++++++++++++++++++++++++")

    if keyname == 100002:
        return data

    dynamic_id = _conn.transport.sessionno
    if not GlobalObject().netfactory.connmanager.hasConnection(dynamic_id):
        return
    result = GlobalObject().remote['gate'].callRemote("forwarding", keyname, _conn.transport.sessionno, data)
    return result

