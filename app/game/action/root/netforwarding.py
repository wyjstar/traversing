#coding:utf8
"""
"""
from gfirefly.server.globalobject import rootserviceHandle
from gfirefly.server.globalobject import GlobalObject


@rootserviceHandle
def push_object(topic_id, msg, send_list):
    """ send msg to client in send_list
        send_list:
    """
    GlobalObject().remotep['gate'].callRemote("pushObject", topic_id, msg, send_list)


