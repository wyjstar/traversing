# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import rootserviceHandle

childsman = GlobalObject().root.childsmanager
groot = GlobalObject().root

def disconnect(dynamic_id):
    return childsman.child('net').disconnect_remote(dynamic_id)


def change_dynamic_id(new_id, cur_id):
    return childsman.child('net').change_dynamic_id_remote(new_id, cur_id)


@remoteserviceHandle('world')
def push_all_object_remote(topic_id, message):
    push_all_objects(topic_id, message)

def push_all_objects(topic_id, message):
    """
    向全服玩家发送消息
    """
    groot.child('net').push_all_object_remote(topic_id, message)

@rootserviceHandle
def push_notice_remote(topic_id, message):
    logger.debug("push_notice_remote===================")
    push_all_objects(topic_id, message)

@rootserviceHandle
def disconnect_remote(dynamic_id):
    logger.debug("disconnect_remote===================")
    disconnect(dynamic_id)

@remoteserviceHandle('world')
def push_message_to_transit_remote(key, character_id, *args):
    logger.debug("push_message_to_transit_remote")

    transit_remote = GlobalObject().remote['transit']
    return transit_remote.push_message_remote(key, character_id, args)
