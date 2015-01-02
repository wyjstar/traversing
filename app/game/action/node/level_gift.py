# -*- coding:utf-8 -*-
"""
created by sphinx on 
"""

from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import level_gift_pb2
from shared.db_opear.configs_data.game_configs import activity_config
from app.game.core.item_group_helper import gain, get_return


@remoteserviceHandle('gate')
def get_level_gift_1131(data, player):
    """get online gift"""
    request = level_gift_pb2.GetLevelGift()
    request.ParseFromString(data)
    response = level_gift_pb2.GetLevelGiftResponse()

    activity_level_gift = activity_config.get(3)

    if request.gift_id in player.level_gift.received_gift_ids:
        response.result = False
        return response.SerializeToString()

    for a in activity_level_gift:
        if request.gift_id == a['id']:
            gain_data = a['reward']
            return_data = gain(player, gain_data)
            get_return(player, return_data, response.gain)

            player.level_gift.received_gift_ids.append(request.gift_id)
            player.level_gift.save_data()

            response.result = True
            return response.SerializeToString()

    response.result = False
    return response.SerializeToString()

@remoteserviceHandle('gate')
def new_level_gift_840(data, player):
    """get online gift"""
    response = level_gift_pb2.NewLevelGiftResponse()

    conf = activity_config.get(5)

    for a in range(1, player.level.level):
        if not player.level_gift.level_gift[a]:
            level_info = response.level_info.add()
            level_info.level = a + 1

            gain_data = conf.get(a+1)['reward']
            return_data = gain(player, gain_data)
            get_return(player, return_data, level_info.drops)
            player.level_gift.level_gift[a] = 1

    player.level_gift.save_data()

    response.res.result = True
    return response.SerializeToString()
