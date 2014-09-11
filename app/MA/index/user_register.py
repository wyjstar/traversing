# -*- coding:utf-8 -*-
"""
created by sphinx on 11/9/14.
"""
from gfirefly.server.globalobject import webserviceHandle


@webserviceHandle('/register/<name,pwd>')
def user_register(name,pwd):
    pass
