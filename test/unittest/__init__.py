# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午7:05.
"""
from gfirefly.server.globalobject import GlobalObject
from gfirefly.distributed.node import RemoteObject


GlobalObject().remote['gate'] = RemoteObject('gate')
