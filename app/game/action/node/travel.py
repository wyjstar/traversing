# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.game.core.item_group_helper import gain, get_return
from app.game.core.drop_bag import BigBag
from app.proto_file.travel_pb2 import TravelResponse, TravelRequest, \
    TravelInitResponse, BuyShoesRequest, BuyShoesResponse, \
    TravelSettleRequest, TravelSettleResponse, \
    EventStartRequest, EventStartResponse, \
    NoWaitRequest, NoWaitResponse, OpenChestResponse
from shared.db_opear.configs_data.game_configs import travel_event_config, \
    base_config, stage_config
import random
from gfirefly.server.logobj import logger
import time
# from gfirefly.server.globalobject import GlobalObject


# remote_gate = GlobalObject().remote['gate']


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

    travel_cache = player.travel_component.travel

    while(True):
        travel_event_id = get_travel_event_id()
        flag = 1
        if travel_cache.get(stage_id):
            for event in travel_cache.get(stage_id):
                if travel_event_id == event[0]:
                    flag = 0
            if flag:
                break
        else:
            travel_cache[stage_id] = []
            break

    event_info = travel_event_config.get('events').get(travel_event_id)
    if not event_info:
        logger.error('get travel event config error')
        response.res.result = False
        response.res.result_no = 800  # 未知错误
        return response.SerializeToString()

    response.event_id = travel_event_id

    res_drops = response.drops
    drops = []
    stage_info = stage_config.get('stages').get(stage_id)
    common_bag = BigBag(stage_info.commonDrop)
    common_drop = common_bag.get_drop_items()
    drops.extend(common_drop)

    drop_data = []
    for group_item in drops:
        type_id = group_item.item_type
        num = group_item.num
        item_no = group_item.item_no
        flag = 1
        for i in drop_data:
            if i[0] == type_id and i[2] == item_no:
                i[1] += 1
                flag = 0
                continue
        if flag:
            drop_data.append([type_id, num, item_no])

    get_return(player, drop_data, res_drops)

    # 等待 战斗 答题 领取
    if event_info.type == 4:
        gain(player, drops)
    else:
        travel_cache.get(stage_id).append([travel_event_id, drop_data])

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
    response = TravelInitResponse()

    for (stage_id, item) in player.travel_component.travel.items():
        chapter = response.chapter.add()
        chapter.stage_id = stage_id
        for tra in item:
            res_travel = chapter.travel.add()
            res_travel.event_id = tra[0]
            res_drops = res_travel.drops
            get_return(player, tra[1], res_drops)
            if travel_event_config.get('events').get(tra[0]).type == 1:
                res_travel.time = tra[2]

    res_shose = response.shoes
    res_shose.shoe1 = player.travel_component.shoes[0]
    res_shose.shoe2 = player.travel_component.shoes[1]
    res_shose.shoe3 = player.travel_component.shoes[2]
    res_shose.use_type = player.travel_component.shoes[3]
    res_shose.use_no = player.travel_component.shoes[4]

    response.chest_time = player.travel_component.chest_time

    for (stage_id, item) in player.travel_component.travel_item.items():
        travel_item_chapter = response.travel_item_chapter.add()
        travel_item_chapter.stage_id = stage_id
        for [travel_item_id, num] in item:
            travel_item = travel_item_chapter.travel_item.add()
            travel_item.id = travel_item_id
            travel_item.num = num
    logger.debug(player.travel_component.travel)
    logger.debug(player.travel_component.travel_item)
    return response.SerializeToString()


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


@remoteserviceHandle('gate')
def open_chest_836(data, player):

    response = OpenChestResponse()

    chest_time = player.travel_component.chest_time

    if time.localtime(chest_time).tm_year == time.localtime().tm_year \
            and time.localtime(chest_time).tm_yday == time.localtime().tm_yday:
        response.res.result = False
        response.res.result_no = 816
        return response.SerializeToString()

    res_drops = response.drops
    drops = []
    common_bag = BigBag(base_config.get('travelChest'))
    common_drop = common_bag.get_drop_items()
    drops.extend(common_drop)
    drop_data = gain(player, drops)
    get_return(player, drop_data, res_drops)

    player.travel_component.chest_time = int(time.time())

    player.travel_component.save()

    logger.debug(response)
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def travel_settle_833(data, player):
    """ settle"""
    args = TravelSettleRequest()
    args.ParseFromString(data)
    stage_id = args.stage_id
    event_id = args.event_id

    response = TravelSettleResponse()

    if player.travel_component.travel.get(stage_id):
        stage_cache = player.travel_component.travel.get(stage_id)
    else:
        logger.error("travel stage id not found")
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()

    event_cache = 0
    for event in stage_cache:
        if event[0] == event_id:
            event_cache = event
            break

    if not event_cache:
        logger.error("travel ：event id not found")
        response.res.result = False
        response.res.result_no = 813
        return response.SerializeToString()

    event_info = travel_event_config.get('events').get(args.event_id)
    if event_info.type == 1:
        if int(time.time()) - event_cache[1] < \
                event_info.parameter.items[0][0]:
            response.res.result = False
            response.res.result_no = 814
            return response.SerializeToString()
    elif event_info.type == 3:
        if not event_info.parameter.get(args.answer):
            response.res.result = False
            response.res.result_no = 815
            return response.SerializeToString()

    # 结算
    gain(player, event_cache[1])

    stage_cache.remove(event_cache)
    player.travel_component.save()

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def event_start_834(data, player):
    """ wait event"""
    args = EventStartRequest()
    args.ParseFromString(data)
    stage_id = args.stage_id
    event_id = args.event_id

    response = EventStartResponse()

    if player.travel_component.travel.get(stage_id):
        stage_cache = player.travel_component.travel.get(stage_id)
    else:
        logger.error("travel stage id not found")
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()

    event_cache = 0
    for event in stage_cache:
        if event[0] == event_id:
            event_cache = event
            break

    if not event_cache:
        logger.error("travel ：event id not found")
        response.res.result = False
        response.res.result_no = 813
        return response.SerializeToString()
    event_info = travel_event_config.get('events').get(args.event_id)
    if event_info.type == 1:
        start_time = int(time.time())
        response.time = start_time
        travel_event_id = event_cache[0]
        drop_data = event_cache[1]
        event_cache = [travel_event_id, drop_data, start_time]
        player.travel_component.save()
    elif event_info.type == 2:
        player.travel_component.fight_cache = [stage_id, event_id]

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def no_wait_835(data, player):

    args = NoWaitRequest()
    args.ParseFromString(data)
    stage_id = args.stage_id
    event_id = args.event_id

    response = NoWaitResponse()

    if player.travel_component.travel.get(stage_id):
        stage_cache = player.travel_component.travel.get(stage_id)
    else:
        logger.error("travel stage id not found")
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()

    event_cache = 0
    for event in stage_cache:
        if event[0] == event_id:
            event_cache = event
            break

    if not event_cache:
        logger.error("travel ：event id not found")
        response.res.result = False
        response.res.result_no = 813
        return response.SerializeToString()

    event_info = travel_event_config.get('events').get(event_id)
    if player.finance.gold < event_info.price:
        response.res.result = False
        response.res.result_no = 102  # 充值币不足
        return response.SerializeToString()

    gain(player, event_cache[1])
    player.finance.gold -= event_info.price
    player.finance.save_data()

    stage_cache.remove(event_cache)
    player.travel_component.save()

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
