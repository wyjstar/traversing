# -*- coding:utf-8 -*-
"""
created by server on 14-6-5下午4:52.
"""
from gfirefly.server.globalobject import GlobalObject
from gfirefly.utils.services import CommandService
from gfirefly.server.logobj import logger


class NodeServiceHandler(CommandService):
    def callTarget(self, command_id, *args, **kw):
        """call Target by Single
        @param conn: client connection
        @param targetKey: target ID
        @param data: client data
        """
        target = self.getTarget(command_id)
        if not target:
            logger.error('the command %s not Found on service[%s]' % (str(command_id)), self._name)
            return None
        if command_id not in self.unDisplay:
            logger.info("call method %s on service[%s]" % (target.__name__, self._name))
        print "gate.callTarget"
        response = target(command_id, *args, **kw)
        return response


nodeservice = NodeServiceHandler('nodeservice')


def nodeservice_handle(target):
    """服务处理，添加处理函数
    @param target: func Object
    """
    nodeservice.mapTarget(target)

noderemote = GlobalObject().remote['gate']
noderemote._reference.addService(nodeservice)