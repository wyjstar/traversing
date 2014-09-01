# -*- coding:utf-8 -*-
"""
created by sphinx on 
"""
from app.proto_file import online_gift_pb2
from app.game.logic.common.check import have_player


@have_player
def get_online_gift(dynamic_id, data, **kwargs):
    request = online_gift_pb2.GetOnlineGift()
    request.ParseFromString(data)
    response = online_gift_pb2.GetOnlineGiftResponse()

    player = kwargs.get('player')
    player.online_gift.get_online_gift(request.gift_id)

    response.result = True
    return response.SerializeToString()
