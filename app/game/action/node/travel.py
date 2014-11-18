# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file.travel_pb2 import TravelResponse, TravelRequest, \
    TraverInitResponse, BuyShoesRequest, BuyShoesResponse
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

    shoes = player.travel_component.shoes
    if shoes[0] + shoes[1] + shoes[2] == 0:
        response.res.result = False
        response.res.result_no = 812  # 鞋子不足
        return response.SerializeToString()

    travel_event_id = get_travel_event_id()
    event_info = travel_event_config.get('events').get(travel_event_id)
    if not event_info:
        logger.error('get travel event config error')
        response.res.result = False
        response.res.result_no = 800  # 未知错误
        return response.SerializeToString()

    response.event_id = travel_event_id

    travel_cache = player.travel_component.travel
    if not travel_cache.get(stage_id):
        travel_cache[stage_id] = []

    # 等待 战斗 答题 领取
    if event_info.type == 1:
        response.time = int(time.time())
        travel_cache.get(stage_id).append([travel_event_id, int(time.time())])
    elif event_info.type == 2 or event_info.type == 3:
        travel_cache.get(stage_id).append([travel_event_id])
    elif event_info.type == 4:
        # 直接获取奖励
        pass
        # TODO 直接领取奖励

    if shoes[3] == 0:
        for i in[2, 1, 0]:
            if shoes[i] != 0:
                shoes[3] = i + 1
                shoes[4] = 1
                break
    else:
        if base_config.get("travelShoe"+str(shoes[3]))[1] == shoes[4] + 1:
            shoes[shoes[3]-1] -= 1
            shoes[4] = 0
            shoes[3] = 0
        else:
            shoes[4] += 1
    player.travel_component.save()

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def travel_init_830(data, player):
    """init travel"""
    response = TraverInitResponse()

    for (character_id, item) in player.travel_component.travel:
        chapter = response.chapter.add()
        for tra in item:
            res_travel = chapter.travel.add()
            res_travel.event_id = tra[0]
            if travel_event_config.get('events').get(tra[0]).type == 1:
                res_travel.time = tra[1]

    res_shose = response.shoes
    res_shose.shoe1 = player.travel_component.shoes[0]
    res_shose.shoe2 = player.travel_component.shoes[1]
    res_shose.shoe3 = player.travel_component.shoes[2]
    res_shose.use_type = player.travel_component.shoes[3]
    res_shose.use_no = player.travel_component.shoes[4]

    response.chest_time = player.travel_component.chest_time


@remoteserviceHandle('gate')
def buy_shoes_832(data, player):
    """buy_shoes"""
    args = BuyShoesRequest()
    args.ParseFromString(data)
    response = BuyShoesResponse()

    need_good = 0
    for shoes_info in args.shoes_infos:
        need_good += base_config.get("travelShoe"+str(shoes_info.shoes_type))[2] \
            * shoes_info.shoes_no

    if player.finance.gold < need_good:
        response.res.result = False
        response.res.result_no = 102  # 充值币不足
        return response.SerializeToString()

    for shoes_info in args.shoes_infos:
        player.travel_component.shoes[shoes_info.shoes_type-1] += \
            shoes_info.shoes_no

    player.finance.gold -= need_good

    player.travel_component.save()
    player.finance.save_data()

    response.res.result = True
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
