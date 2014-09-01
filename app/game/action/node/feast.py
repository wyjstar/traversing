# -*- coding:utf-8 -*-
"""
created by server on 14-8-12下午2:17.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic.feast import *
from app.proto_file.feast_pb2 import *
from app.proto_file.common_pb2 import CommonResponse


@remote_service_handle
def feast_820(dynamic_id, pro_data):
    """美味酒席
    """
    response = CommonResponse()
    print('cuick,AAAAAAAAAAAAAAAAA,01,node,feast_820')

    abc = eat_feast(dynamic_id)

    response.result = True
    return response.SerializeToString()

@remote_service_handle
def get_eat_time_821(dynamic_id, pro_data):
    """获取上次吃的时间
    """
    response = GetEatTimeResponse()
    print('cuick,BBBBBBBBBBBBBBBBBBBB,01,node,feast_821')

    abc = get_time(dynamic_id)

    response.result = True
    return response.SerializeToString()