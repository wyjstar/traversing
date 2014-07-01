# -*- coding:utf-8 -*-
"""
created by server on 14-6-5下午3:33.
"""
from gfirefly.server.globalobject import GlobalObject
from gfirefly.utils.services import CommandService
from gtwisted.utils import log


class NodeServiceHandler(CommandService):
    def callTarget(self, command_id, *args, **kw):
        """call Target by Single
        @param conn: client connection
        @param targetKey: target ID
        @param data: client data
        """
        target = self.getTarget(command_id)
        if not target:
            log.err('the command %s not Found on service:[%s]' % (str(command_id)), self._name)
            return None
        if command_id not in self.unDisplay:
            log.msg("call method %s on service:[%s]" % (target.__name__, self._name))
        response = target(command_id, *args, **kw)
        return response


node_service = NodeServiceHandler('gate_node_service')


def node_service_handle(target):
    """服务处理，添加处理函数
    @param target: func Object
    """
    node_service.mapTarget(target)


node_remote = GlobalObject().remote['gate']
node_remote._reference.addService(node_service)