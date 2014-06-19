# -*- coding:utf-8 -*-
"""
created by server on 14-6-19下午7:54.
"""

from gfirefly.server.globalobject import GlobalObject
from gfirefly.utils.services import CommandService


remoteservice = CommandService("gateremote")
GlobalObject().remote['gate']._reference.addService(remoteservice)


def remoteservice_handle(target):
    """
    """
    remoteservice.mapTarget(target)
