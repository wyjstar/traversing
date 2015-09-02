# -*- coding:utf-8 -*-
"""
created by sphinx on 
"""
from gfirefly.server.globalobject import GlobalObject
from gfirefly.utils.services import CommandService


login_service = CommandService("LoginService")
GlobalObject().netfactory.addServiceChannel(login_service)