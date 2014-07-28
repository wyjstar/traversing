#coding:utf8
"""
"""
from gfirefly.server.globalobject import rootserviceHandle
from gfirefly.server.globalobject import GlobalObject


def push_object(topic_id, msg, send_list):
    """ send msg to client in send_list
        send_list:
    """
    GlobalObject().remote['gate'].callRemote("pushObject", topic_id, msg, send_list)


