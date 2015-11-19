# coding:utf8
"""
Created on 2013-8-14

@author: lan (www.9miao.com)
"""
from gfirefly.server.globalobject import GlobalObject, remoteserviceHandle


@remoteserviceHandle('gate')
def push_object_remote(topicID, msg, sendList):
    """
    向指定玩家发送消息msg。
    topicID: 为协议号。
    msg: 发送的消息。
    sendList: 玩家连接ID列表。
    """
    GlobalObject().netfactory.pushObject(topicID, msg, sendList)


@remoteserviceHandle('gate')
def push_all_object_remote_noresult(topicID, msg):
    """
    向全区玩家发送消息。
    topicID: 为协议号。
    msg: 发送的消息。
    """
    print("push_all_object_remote_noresult===========")
    GlobalObject().netfactory.pushAllObject(topicID, msg)


@remoteserviceHandle('gate')
def disconnect_remote(connection_id):
    GlobalObject().netfactory.loseConnection(connection_id)
    return True


@remoteserviceHandle('gate')
def change_dynamic_id_remote(old_id, new_id):
    GlobalObject().netfactory.change_id(old_id, new_id)
    return True


@remoteserviceHandle('gate')
def kick_by_id_remote(msg, pid):
    GlobalObject().netfactory.kick(msg, pid)
    return True


@remoteserviceHandle('gate')
def get_ipaddress_remote(pid):
    return GlobalObject().netfactory.get_ipaddress(pid)
