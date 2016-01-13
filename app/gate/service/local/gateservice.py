# coding:utf8
"""
Created on 2013-8-14
"""
from gfirefly.utils.services import CommandService
from gfirefly.server.logobj import logger
import traceback
import time


class LocalService(CommandService):
    def callTarget(self, target_key, *args, **kw):
        """call Target by Single
        @param conn: client connection
        @param target_key: target ID
        @param data: client data
        """
        target = self.getTarget(target_key)
        if not target:
            logger.error('the command %s not Found on service:[%s]' % (target_key, self._name))
            return None
        # if target_key not in self.unDisplay:
        #     logger.info("call method %s on service:[%s]" % (target.__name__, self._name))
        t = time.time()
        try:
            response = target(target_key, *args, **kw)
        except Exception, e:
            logger.exception(e)
            return None
        except:
            logger.error(traceback.format_exc())
            return None

        logger.info("call method %s on service:[%s]:%f", target.__name__,
                    self._name, time.time() - t)
        return response


local_service = LocalService('gate_local_service')


def local_service_handle(target):
    """服务处理
    @param target: func Object
    """
    local_service.mapTarget(target)
