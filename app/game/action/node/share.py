# -*- coding:utf-8 -*-
"""
created by server on 15-5-27下午2:00.
"""
__author__ = 'Server-ZhangChao'

from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import Share_pb2
from app.proto_file.lively_pb2 import rewardResponse

remote_gate = GlobalObject().remote.get('gate')

@remoteserviceHandle('gate')
def get_share_status_2300(data, player):
    msg_data = Share_pb2.ServerShareStatusData()
    for tid in player.share.status:
        msg_data.task_id.append(tid)
    return msg_data.SerializePartialToString()

@remoteserviceHandle('gate')
def get_share_reward_2301(data, player):
    request = Share_pb2.ClientGetShareReward()
    request.ParseFromString(data)
    result = rewardResponse()
    player.share.get_reward(request.task_id, player, result)
    return result.SerializePartialToString()
