# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from app.proto_file import online_gift_pb2
from app.game.logic.common.check import have_player
from shared.db_opear.configs_data.game_configs import activity_config
from app.game.logic.item_group_helper import gain, get_return


@have_player
def get_online_gift(data, player):
    request = online_gift_pb2.GetOnlineGift()
    request.ParseFromString(data)
    response = online_gift_pb2.GetOnlineGiftResponse()

    activity_online_gift = activity_config.get(4)
    online_minutes = player.online_gift.online_time  # / 60

    if request.gift_id in player.online_gift.received_gift_ids:
        response.result = False
        return response.SerializeToString()

    for a in activity_online_gift:
        if request.gift_id == a['id']:
            if online_minutes >= a['parameterA']:
                gain_data = a['reward']
                return_data = gain(player, gain_data)
                get_return(player, return_data, response.gain)

                data = {'online_time': player.online_gift.online_time,
                        'received_gift_ids': player.online_gift.received_gift_ids}
                player.online_gift.received_gift_ids.append(request.gift_id)
                player.online_gift.save_data()

                response.result = True
                return response.SerializeToString()
            else:
                break

    response.result = False
    return response.SerializeToString()


@have_player
def get_online_and_level_gift_data(data, player):
    response = online_gift_pb2.GetOnlineLevelGiftData()

    response.online_time = player.online_gift.online_time
    for _ in player.online_gift.received_gift_ids:
        response.received_online_gift_id.append(_)
    for _ in player.level_gift.received_gift_ids:
        response.received_level_gift_id.append(_)

    return response.SerializeToString()
