# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import time
from shared.db_opear.configs_data import game_configs
from app.game.core.item_group_helper import gain, get_return
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.logobj import logger
from app.proto_file import online_gift_pb2
from app.proto_file import recharge_pb2
from shared.utils.const import const
from shared.tlog import tlog_action


@remoteserviceHandle('gate')
def get_online_gift_1121(data, player):
    """get online gift"""
    player.online_gift.check_time()

    request = online_gift_pb2.GetOnlineGift()
    request.ParseFromString(data)
    response = online_gift_pb2.GetOnlineGiftResponse()

    activity_online_gift = game_configs.activity_config.get(4)
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
                # player.online_gift.reset()
                player.online_gift.save_data()
                tlog_action.log('OnlineGift', player, request.gift_id)

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


@remoteserviceHandle('gate')
def get_online_and_level_gift_data_1150(data, player):
    response = recharge_pb2.GetRechargeGiftDataResponse()
    player.recharge.get_data(response)
    player.recharge.save_data()
    logger.debug("get_online_and_level_gift_data_1150:%s", response)

    return response.SerializeToString()


@remoteserviceHandle('gate')
def take_recharge_gift_1151(data, player):
    request = recharge_pb2.GetRechargeGiftRequest()
    request.ParseFromString(data)
    print '1151===============request:', request

    response = recharge_pb2.GetRechargeGiftResponse()
    response.res.result = True

    player.recharge.take_gift(request.gift, response)
    player.recharge.save_data()
    print '1151===============response:', response
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_tomorrow_gift_1122(data, player):
    response = online_gift_pb2.GetActivityResponse()
    response.result = False

    tomorrow_gift = game_configs.activity_config.get(15, [])
    if not tomorrow_gift:
        logger.error('tomorrow gift is not exist')
        return response.SerializeToString()
    else:
        tomorrow_gift = game_configs.activity_config.get(15)[0]
    # if not tomorrow_gift.get('is_open'):
    #     logger.error('tomorrow gift is not open')
    #     return response.SerializeToString()
    if player.base_info.tomorrow_gift != 0:
        logger.error('tomorrow gift is taken!')
        return response.SerializeToString()
    register_time = time.localtime(player.base_info.register_time)
    now_time = time.localtime()
    if now_time.tm_yday <= register_time.tm_yday and now_time.tm_year <= register_time.tm_year:
        logger.error('tomorrow gift is miss!')
        return response.SerializeToString()

    player.base_info.tomorrow_gift = tomorrow_gift.id
    player.base_info.save_data()

    gain_data = tomorrow_gift['reward']
    return_data = gain(player, gain_data, const.TOMORROW_GIFT)
    get_return(player, return_data, response.gain)
    response.result = True
    return response.SerializeToString()
