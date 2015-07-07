# coding:utf-8
'''
Created on 2015-5-2

@author: hack
'''
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import push_pb2


remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def register_push_2222(data, player):
    """
    注册推送ID
    """
    request = push_pb2.registerPush()
    request.ParseFromString(data)
    response = push_pb2.registerPushRes()
    print 'register_push_2222'
    print request
    remote_gate['push'].register_push_message_remote(player.base_info.id,
                                                     request.deviceToken)
    response.res.result = True

    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def set_push_switch_2223(data, player):
    """
    设置推送消息开关
    """
    # print 'set_push_switch_2223', type(data), len(data)
    request = push_pb2.msgSwitchReq()
    request.ParseFromString(data)
    print 'request', request

    remote_gate['push'].set_push_switch_remote(player.base_info.id, data)
    return request.SerializePartialToString()


@remoteserviceHandle('gate')
def get_push_switch_2224(data, player):
    """
    获取推送消息开关
    """
    # print 'get_push_switch_2224'
    response = remote_gate['push'].get_push_switch_remote(player.base_info.id)
    res = push_pb2.msgSwitchRes()
    res.ParseFromString(response)
    print res
    return response
