# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from gfirefly.server.globalobject import rootserviceHandle


@rootserviceHandle
def register_server(name, ip, port):
    return True


@rootserviceHandle
def synchronize_info(name, status):
    return True
