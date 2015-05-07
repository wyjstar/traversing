# -*- coding:utf-8 -*-
'''
created by server on 14-5-19下午8:51.
'''
from gfirefly.server.globalobject import GlobalObject
from gfirefly.utils.services import CommandService


nodeservice = CommandService('nodeservice')


def nodeservice_handle(target):
    """服务处理，添加处理函数
    @param target: func Object
    """
    nodeservice.mapTarget(target)

noderemote = GlobalObject().remote['gate']
noderemote._reference.addService(nodeservice)
