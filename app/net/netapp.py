#coding:utf8
'''
Created on 2013-8-14

@author: lan (www.9miao.com)
'''
from app.proto_file import item_pb2
from gfirefly.server.globalobject import GlobalObject
from gfirefly.utils.services import CommandService
from gtwisted.utils import log

class NetCommandService(CommandService):
    
    def callTarget(self,targetKey,*args,**kw):
        '''call Target by Single
        @param conn: client connection
        @param targetKey: target ID
        @param data: client data
        '''
        target = self.getTarget(0)
        if not target:
            log.err('the command '+str(targetKey)+' not Found on service')
            return None
        if targetKey not in self.unDisplay:
            log.msg("call method %s on service[single]"%target.__name__)
        response = target(targetKey,*args,**kw)
        return response
    
netservice = NetCommandService("loginService")

def netserviceHandle(target):
    """
    """
    netservice.mapTarget(target)

GlobalObject().netfactory.addServiceChannel(netservice)


@netserviceHandle
def Forwarding_0(keyname, _conn, data):
    """消息转发，将客户端发送的消息请求转发给gateserver分配处理
    """
    log.msg("forwarding_0++++++++++++++++++++++++++++++++++++")

    if keyname == 100002:
        print 'data:', data
        return data

    dd = GlobalObject().remote['gate'].callRemote("forwarding_test", keyname, _conn.transport.sessionno, data)
    return dd

