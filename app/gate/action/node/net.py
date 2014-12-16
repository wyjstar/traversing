# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.globalobject import remoteserviceHandle

childsman = GlobalObject().root.childsmanager
groot = GlobalObject().root

def disconnect(dynamic_id):
    return childsman.child('net').disconnect_remote(dynamic_id)


def change_dynamic_id(new_id, cur_id):
    return childsman.child('net').change_dynamic_id_remote(new_id, cur_id)


@remoteserviceHandle('world')
def push_all_object_remote(topic_id, message):
    groot.child('net').push_all_object_remote(topic_id, message)

