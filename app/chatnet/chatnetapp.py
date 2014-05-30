#-*- coding:utf-8 -*-
"""
created by server on 14-5-17下午3:38.
"""

from gfirefly.server.globalobject import GlobalObject
from gfirefly.utils.services import CommandService
from gtwisted.utils import log


class NetCommandService(CommandService):
    def callTarget(self, command_id, *args, **kw):
        """call Target by Single
        @param conn: client connection
        @param targetKey: target ID
        @param data: client data
        """
        target = self.getTarget(0)
        if not target:
            log.err('the command %s not Found on service[%s]' % (str(command_id)), self._name)
            return None
        if command_id not in self.unDisplay:
            log.msg("call method %s on service[%s]" % (target.__name__, self._name))
        response = target(command_id, *args, **kw)
        return response


netservice = NetCommandService("loginService")


def netservice_handle(target):
    """
    """
    netservice.mapTarget(target)


GlobalObject().netfactory.addServiceChannel(netservice)


@netservice_handle
def forwarding_0(keyname, _conn, data):
    """消息转发，将客户端发送的消息请求转发给gateserver分配处理
    """
    dd = GlobalObject().remote['chatgate'].callRemote("forwarding",
                                                      keyname, _conn.transport.sessionno, data)
    return dd