# -*- coding:utf-8 -*-
"""
created by server on 14-6-19下午7:54.
"""

from gfirefly.server.globalobject import GlobalObject
from gfirefly.utils.services import CommandService


remoteservice = CommandService("gateremote")

try:
    GlobalObject().remote['gate']._reference.addService(remoteservice)
except Exception:
    pass


def remote_service_handle(target):
    """
    """
    remoteservice.mapTarget(target)

