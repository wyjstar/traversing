# -*- coding:utf-8 -*-
"""
created by sphinx on 
"""
from app.proto_file import online_gift_pb2

def get_online_gift(dynamic_id, data, **kwargs):
    request = online_gift_pb2.GetOnlineGift()
    request.ParseFromString(data)

    player = kwargs.get('player')
    player.online_gift
