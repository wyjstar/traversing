#coding:utf-8
'''
Created on 2015-5-2

@author: hack
'''
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import push_pb2



remote_gate = GlobalObject().remote['gate']


@remoteserviceHandle('gate')
def register_push_2222(data, player):
    """
    注册推送ID
    """
    request = push_pb2.registerPush()
    request.ParseFromString(data)
    response = push_pb2.registerPushRes()
    remote_gate.register_push_message(player.base_info.id, request.deviceToken)
    response.result = True
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def set_push_switch2223(data, player):
    """
    设置推送消息开关
    """
    request = push_pb2.msgSwitchReq()
    request.ParseFromString(data)
    
    remote_gate.set_push_switch(player.base_info.id, request.SerializePartialToString())
    return request.SerializePartialToString()
