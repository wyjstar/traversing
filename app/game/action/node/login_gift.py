# -*- coding:utf-8 -*-
"""
created by server on 14-9-3下午5:28.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic.login_gift import *
from app.proto_file.feast_pb2 import *


@remote_service_handle
def get_login_gift_825(dynamic_id, pro_data):
    """登录奖励
    """
    # type: 1:连续登录 2:累积登录 3
    response = EatFeastResponse()
    print('cuick,AAAAAAAAAAAAAAAAA,01,node,get_login_gift_825')

    cumulative_received, continuous_received, cumulative_day, continuous_day = get_login_gift(dynamic_id)

    response.res = res
    return response.SerializeToString()