# -*- coding:utf-8 -*-
"""
created by server on 14-8-12下午2:17.
"""
from app.game.logic.feast import eat_feast, get_time
from app.proto_file.feast_pb2 import EatFeastResponse, GetEatTimeResponse
from gfirefly.server.globalobject import remoteserviceHandle


@remoteserviceHandle('gate')
def feast_820(dynamic_id, pro_data):
    """美味酒席
    """
    response = EatFeastResponse()
    res = eat_feast(dynamic_id)
    response.res = res
    return response.SerializeToString()

@remoteserviceHandle('gate')
def get_eat_time_821(dynamic_id, pro_data):
    """获取上次吃的时间
    """
    response = GetEatTimeResponse()
    last_eat_time = get_time(dynamic_id)
    response.res.result = True
    response.eat_time = last_eat_time
    return response.SerializeToString()