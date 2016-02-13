# coding:utf8
"""
Created on 2011-1-3
服务类
@author: sean_lan
"""
import traceback
import time
from gfirefly.server.logobj import logger


class Service(object):
    """A remoting service

    attributes:
    ============
     * name - string, service name.
     * runstyle
    """

    def __init__(self, name):
        self._name = name
        self.unDisplay = set()
        self._targets = {}  # Keeps track of targets internally

    def __iter__(self):
        return self._targets.itervalues()

    def addUnDisplayTarget(self, command):
        """Add a target unDisplay when client call it."""
        self.unDisplay.add(command)

    def mapTarget(self, target):
        """Add a target to the service."""
        key = target.__name__
        if key in self._targets:
            exist_target = self._targets.get(key)
            e = Exception("target[%d] exists, Conflict between %s and %s" %
                          (key, exist_target.__name__, target.__name__))
            raise e
        self._targets[key] = target

    def unMapTarget(self, target):
        """Remove a target from the service."""
        key = target.__name__
        if key in self._targets:
            del self._targets[key]

    def unMapTargetByKey(self, targetKey):
        """Remove a target from the service."""
        del self._targets[targetKey]

    def getTarget(self, targetKey):
        """Get a target from the service by name."""
        target = self._targets.get(targetKey, None)
        return target

    def callTarget(self, targetKey, *args, **kw):
        """call Target
        @param conn: client connection
        @param targetKey: target ID
        @param data: client data
        """
        target = self.getTarget(targetKey)
        if not target:
            logger.error('command %s not Found on service[%s]' % (str(targetKey), self._name))
            logger.debug(self._targets)
            return None
        # if targetKey not in self.unDisplay:
        #     logger.info("call method %s on service[%s]" %
        #                 (target.__name__, self._name))
        t = time.time()
        try:
            response = target(*args, **kw)
        except Exception, e:
            logger.exception(e)
            logger.error("func:%s arg:%s kw:%s", targetKey, args, kw)
            return None
        except:
            logger.error(traceback.format_exc())
            return None
        logger.info("call method %s on service[%s]:%f",
                    target.__name__, self._name, time.time() - t)
        return response


class CommandService(Service):
    """A remoting service
    According to Command ID search target
    """

    def mapTarget(self, target):
        """Add a target to the service.
        """
        key = target.__name__.split('_')[-1]
        if key.isdigit():
            key = int(key)
            if key in self._targets:
                exist_target = self._targets.get(key)
                str_err = "target [%d] Already exists, Conflict between the %s and %s" \
                          % (key, exist_target.__name__, target.__name__)
                raise Exception(str_err)
            self._targets[key] = target
        else:
            Service.mapTarget(self, target)

    def unMapTarget(self, target):
        """Remove a target from the service.
        """
        key = target.__name__.split('_')[-1]
        if key.isdigit():
            key = int(target.__name__.split('_')[-1])
            if key in self._targets:
                del self._targets[key]
        else:
            Service.mapTarget(target)
