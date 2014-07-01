# coding:utf8
"""
Created on 2013-8-14
"""
from gfirefly.utils.services import CommandService
from gtwisted.utils import log


class LocalService(CommandService):
    def callTarget(self, target_key, *args, **kw):
        """call Target by Single
        @param conn: client connection
        @param target_key: target ID
        @param data: client data
        """
        target = self.getTarget(target_key)
        if not target:
            log.err('the command %s not Found on service:[%s]' % (target_key, self._name))
            return None
        if target_key not in self.unDisplay:
            log.msg("call method %s on service:[%s]" % (target.__name__, self._name))
        response = target(target_key, *args, **kw)
        return response


local_service = LocalService('gate_local_service')


def local_service_handle(target):
    """服务处理
    @param target: func Object
    """
    local_service.mapTarget(target)
