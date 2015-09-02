# coding:utf8
"""
Created on 2013-8-14

@author: lan (www.9miao.com)
"""
from gfirefly.server.globalobject import GlobalObject
from gfirefly.utils.services import CommandService
# from gfirefly.server.logobj import logger


class NetCommandService(CommandService):
    def callTarget(self, targetKey, *args, **kw):
        _conn = args[0]
        data = args[1]

        if targetKey == 100002:
            return data

        dynamic_id = _conn.transport.sessionno
        if not GlobalObject().netfactory.connmanager.hasConnection(dynamic_id):
            return
        result = remote_gate.forwarding_remote(targetKey,
                                               _conn.transport.sessionno,
                                               data)
        return result


remote_gate = GlobalObject().remote['gate']
netservice = NetCommandService("NetService")
GlobalObject().netfactory.addServiceChannel(netservice)
