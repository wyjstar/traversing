# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file.travel_pb2 import TravelResponse
from shared.db_opear.configs_data.game_configs import travel_event_config, \
    base_config
import random
from gfirefly.server.logobj import logger
import time


@remoteserviceHandle('gate')
def travel_831(data, player):
    """游历"""
    args = TravelRequest()
    args.ParseFromString(data)
    stage_id = args.stage_id
    response = TravelResponse()

    if base_config.get('travelOpenLevel') > player.level.level:
        response.res.result = False
        response.res.result_no = 811  # 等级不够
        return response.SerializeToString()

    travel_event_id = get_travel_event_id()
    event_info = travel_event_config.get('events').get(travel_event_id)
    if not event_info:
        logger.error('get travel event config error')
        response.res.result = False
        response.res.result_no = 800  # 未知错误
        return response.SerializeToString()

    response.event_id = travel_event_id

    # 等待 战斗 答题 领取
    if event_info.type == 1:
        response.time = int(time.time()

    return response.SerializeToString()


def get_travel_event_id():
    travel_event_id = None
    x = random.randint(0, travel_event_config.get('weight')[-1][1])
    flag = 0
    for [event_id, weight] in travel_event_config.get('weight'):
        if flag <= x < weight:
            travel_event_id = event_id
            break
        flag == weight
    return travel_event_id
