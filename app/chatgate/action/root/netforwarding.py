#-*- coding:utf-8 -*-
"""
created by server on 14-5-17下午4:38.
"""
from gfirefly.server.globalobject import rootserviceHandle
from gfirefly.server.globalobject import GlobalObject


@rootserviceHandle
def forwarding(key, dynamic_id, data):  # net 传过来的信息
    """
    @param key: 请求的指令号
    @param dynamic_id: 动态id
    @param data: 数据
    """
    return GlobalObject().root.callChild('chat', key, dynamic_id, data)


@rootserviceHandle
def push_chat_message(send_list, msg):
    GlobalObject().root.callChild('chatnet', 'push_message', send_list, msg)


@rootserviceHandle
def netconnlost(dynamic_id):
    GlobalObject().root.childsmanager.callChildNotForResult('chat', 3, dynamic_id)

