#!/usr/bin/env python
# -*- coding: utf-8 -*-

from gfirefly.server.globalobject import GlobalObject

def call(command, data):
    GlobalObject().remote['gate']._reference._service.callTarget(command, 1, data)
