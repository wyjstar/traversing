# -*- coding:utf-8 -*-
"""
created by sphinx on 
"""
# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from app.proto_file import level_gift_pb2
from app.game.logic.common.check import have_player
from shared.db_opear.configs_data.game_configs import activity_config
from app.game.logic.item_group_helper import gain, get_return


@have_player
def get_level_gift(dynamic_id, data, **kwargs):
    request = level_gift_pb2.GetLevelGift()
    request.ParseFromString(data)
    response = level_gift_pb2.GetLevelGiftResponse()

    player = kwargs.get('player')

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
