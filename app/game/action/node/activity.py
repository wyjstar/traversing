# -*- coding:utf-8 -*-
"""
"""

from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import activity_pb2
from shared.db_opear.configs_data import game_configs
from app.game.core.item_group_helper import gain, get_return
from shared.utils.const import const


@remoteserviceHandle('gate')
def get_act_gift_1832(data, player):
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_act_info_1831(data, player):
    """get act info"""
    args = activity_pb2.GetActInfoRequese()
    args.ParseFromString(data)
    act_type = args.act_type

    response = activity_pb2.GetActInfoResponse()
    received_ids = player.ap_gift.received_gift_ids.get(act_type)
    if received_ids:
        for id in received_ids:
            response.received_gift_ids.append(id)
    response.res.result = True
    return response.SerializeToString()
