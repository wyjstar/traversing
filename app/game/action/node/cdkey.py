# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import cdkey_pb2


@remoteserviceHandle('gate')
def get_tomorrow_gift_1122(data, player):
    request = cdkey_pb2.CdkeyRequest()
    request.ParseFromString(data)

    response = cdkey_pb2.CdkeyResqonse()
    response.res.result = False

    # gain_data = tomorrow_gift['reward']
    # return_data = gain(player, gain_data, const.TOMORROW_GIFT)
    # get_return(player, return_data, response.gain)
    # response.result = True
    return response.SerializeToString()
