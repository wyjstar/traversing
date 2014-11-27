#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from gfirefly.server.globalobject import rootserviceHandle
from gfirefly.server.globalobject import GlobalObject

world = GlobalObject().remote["world"]

@rootserviceHandle
def world_forwarding_remote(key, *arg, **kwargs):
    """将请求转到world服务器"""
    print key, "-_- "* 20
    return world.call_remote_for_result(key, *arg, **kwargs)

