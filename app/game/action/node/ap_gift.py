
# -*- coding:utf-8 -*-
"""
created by sphinx on
"""

from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import ap_gift_pb2
from shared.db_opear.configs_data import game_configs
from app.game.core.item_group_helper import gain, get_return
from shared.utils.const import const


@remoteserviceHandle('gate')
def get_ap_gift_1832(data, player):
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def init_ap_gift_info_1831(data, player):
    """get online gift"""
    response = ap_gift_pb2.InitApGiftInfoResponse()
    received_ids = player.ap_gift.received_gift_ids
    for id in received_ids:
        response.received_gift_ids.append(id)
    response.res.result = True
    return response.SerializeToString()
