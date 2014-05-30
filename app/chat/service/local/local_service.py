#-*- coding:utf-8 -*-
"""
created by server on 14-5-19下午3:58.
"""

from gfirefly.utils.services import CommandService
from gtwisted.utils import log


class LocalService(CommandService):
    def callTarget(self, command_id, *args, **kw):
        """call Target by Single
        @param target_key:
        @param args:
        @param kw:
        @param targetKey: target ID
        @param data: client data
        """
        target = self.getTarget(command_id)
        if not target:
            log.err('the command %s not Found on service[%s]' % (str(command_id)), self._name)
            return None
        if command_id not in self.unDisplay:
            log.msg("call method %s on service[%s]" % (target.__name__, self._name))
        response = target(command_id, *args, **kw)
        return response


localservice = LocalService('localservice')


def localservice_handle(target):
    """服务处理
    @param target: func Object
    """
    localservice.mapTarget(target)
