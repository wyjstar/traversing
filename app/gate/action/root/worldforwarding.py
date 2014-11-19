#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from gfirefly.server.globalobject import rootserviceHandle
from gfirefly.server.globalobject import GlobalObject

groot = GlobalObject().root
world = GlobalObject().remote["world"]

@rootserviceHandle
def world_forwarding(key, *arg, **kwargs):
    """将请求转到world服务器"""
    return world.(key, *arg, **kwargs)
