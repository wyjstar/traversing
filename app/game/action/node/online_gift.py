# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from shared.db_opear.configs_data.game_configs import activity_config
from app.game.core.item_group_helper import gain, get_return
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.logobj import logger
from app.proto_file import online_gift_pb2
from shared.utils.const import const


@remoteserviceHandle('gate')
def get_online_gift_1121(data, player):
    """get online gift"""
    player.online_gift.check_time()

    request = online_gift_pb2.GetOnlineGift()
    request.ParseFromString(data)
    response = online_gift_pb2.GetOnlineGiftResponse()

    activity_online_gift = activity_config.get(4)
    online_minutes = player.online_gift.online_time  # / 60

    if request.gift_id in player.online_gift.received_gift_ids:
        logger.error('repeat onilne gift:%s,%s',
                     player.online_gift.received_gift_ids,
                     request.gift_id)
        response.result = False
        return response.SerializeToString()

    for a in activity_online_gift:
        if request.gift_id == a['id']:
            if online_minutes >= a['parameterA']:
                gain_data = a['reward']
                return_data = gain(player, gain_data, const.ONLINE_GIFT)
                get_return(player, return_data, response.gain)

                data = dict(online_time=player.online_gift.online_time,
                            received_gift_ids=player.online_gift.received_gift_ids)
                player.online_gift.received_gift_ids.append(request.gift_id)
                player.online_gift.reset()
                player.online_gift.save_data()

                response.result = True
                return response.SerializeToString()
            break
    else:
        logger.error('cant find gift id:%s', request.gift_id)

    response.result = False
    logger.error(response)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_online_and_level_gift_data_1120(data, player):
    response = online_gift_pb2.GetOnlineLevelGiftData()

    response.online_time = int(player.online_gift.online_time)
    for _ in player.online_gift.received_gift_ids:
        response.received_online_gift_id.append(_)
    for _ in player.level_gift.received_gift_ids:
        response.received_level_gift_id.append(_)

    return response.SerializeToString()
