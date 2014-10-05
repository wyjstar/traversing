# -*- coding:utf-8 -*-
"""
created by sphinx on 
"""
from gfirefly.server.globalobject import GlobalObject


def disconnect(dynamic_id):
    return GlobalObject().root.callChildByName('net', 'disconnect', dynamic_id)


def change_dynamic_id(new_id, cur_id):
    return GlobalObject().root.callChildByName('net', 'change_dynamic_id', new_id, cur_id)
