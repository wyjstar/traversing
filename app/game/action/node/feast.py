# -*- coding:utf-8 -*-
"""
created by server on 14-8-12下午2:17.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic.feast import *
from app.proto_file.guild_pb2 import *

@remote_service_handle
def feast_820(dynamic_id, pro_data):
    """美味酒席
    """
    args = CreateGuildRequest()
    args.ParseFromString(pro_data)
    response = GuildCommonResponse()
    print('cuick,AAAAAAAAAAAAAAAAA,01,node,feast_820')

    abc = feast(dynamic_id, args)

    response.result = True
    return response.SerializeToString()