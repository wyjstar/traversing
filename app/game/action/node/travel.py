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
    NoWaitRequest, NoWaitResponse, OpenChestResponse, \
    AutoTravelRequest, AutoTravelResponse, \
    SettleAutoRequest, SettleAutoResponse
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

    drops = get_drops(stage_id)
    drop_data = get_drop_data(drops)

    get_return(player, drop_data, res_drops)

    # 等待 战斗 答题 领取
    if event_info.type == 4:
        gain(player, drops)
    else:
        travel_cache.get(stage_id).append([travel_event_id, drops])

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
            drop_data = get_drop_data(tra[1])
            get_return(player, drop_data, res_drops)
            if travel_event_config.get('events').get(tra[0]).type == 1:
                if len(tra) == 3:
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

    update_auto(player)
    deal_auto_response(response, player)

    logger.debug(response)
    response.res.result = True
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
        if int(time.time()) - event_cache[2] < \
                event_info.parameter.items()[0][0]:
            response.res.result = False
            response.res.result_no = 814
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

        # travel_event_id = event_cache[0]
        # drop_data = event_cache[1]
        # event_cache = [travel_event_id, drop_data, start_time]
        event_cache.append(start_time)

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


@remoteserviceHandle('gate')
def auto_travel_837(data, player):

    args = AutoTravelRequest()
    args.ParseFromString(data)
    stage_id = args.stage_id
    ttime = args.ttime

    response = AutoTravelResponse()

    auto_travel_config = base_config.get('autoTravel').get(ttime)

    if player.finance.gold < auto_travel_config[1]:
        response.res.result = False
        response.res.result_no = 102  # 充值币不足
        return response.SerializeToString()

    # TODO 验证 有没有没有完成的自动游历
    flag = 0
    if player.travel_component.auto.get(stage_id):
        for auto_travel in player.travel_component.auto.get(stage_id):
            if base_config.get('autoTravel').get(auto_travel.get('continued_time')) != auto_travel.get('already_times'):
                flag = 1
            else:
                for auto_travel_event in auto_travel.get('events'):
                    if len(auto_travel_event) < 3:
                        flag = 1
    else:
        player.travel_component.auto[stage_id] = []

    if flag:
        response.res.result = False
        response.res.result_no = 819
        return response.SerializeToString()

    info = {
        'start_time': int(time.time()),
        'continued_time': ttime,
        'events': [],
        'already_times': 0}
    player.travel_component.auto[stage_id].append(info)

    # update_auto(player)
    player.finance.gold -= auto_travel_config[1]
    player.finance.save_data()

    # deal_auto_response(response, player)

    response.res.result = True
    logger.debug(response)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def settle_auto_838(data, player):

    args = SettleAutoRequest()
    args.ParseFromString(data)
    stage_id = args.stage_id
    start_time = args.start_time
    event_id = args.event_id
    settle_type = args.settle_type

    response = SettleAutoResponse()

    if settle_type:
        if not event_id:
            logger.error('travel seetle type and event id dont matching')
            response.res.result = False
            response.res.result_no = 800
            return response.SerializeToString()
        else:
            event_conf = travel_event_config.get('events').get(event_id)
            if player.finance.gold < event_conf.price:
                response.res.result = False
                response.res.result_no = 102  # 充值币不足
                return response.SerializeToString()

    auto_info = player.travel_component.auto
    stage_info = auto_info.get(stage_id)
    if not stage_info:
        logger.error('auto stage info is None')
        response.res.result = False
        response.res.result_no = 817
        return response.SerializeToString()

    auto_travel_info = {}
    for i in stage_info:
        if i.get('start_time') == start_time:
            auto_travel_info = i
    if not auto_travel_info:
        logger.error('auto travel, this start time not find')
        response.res.result = False
        response.res.result_no = 818
        return response.SerializeToString()

    if base_config.get('autoTravel').get(auto_travel_info.get('continued_time')) != auto_travel_info.get('already_times'):
        logger.error('auto travel dont finish')
        response.res.result = False
        response.res.result_no = 819
        return response.SerializeToString()

    del_list = []

    for event_info in auto_travel_info.get('events'):
        if event_id:
            if event_info[0] != event_id:
                continue

        event_conf = travel_event_config.get('events').get(event_info[0])
        if event_conf.type == 1 and not settle_type:
            if int(time.time()) - event_info[2] < \
                    event_conf.parameter.items[0][0]:
                continue

        # 结算
        gain(player, event_info[1])

        del_list.append(event_info)

    for del_event in del_list:
        auto_travel_info.get('events').remove(del_event)

    if len(auto_travel_info.get('events')) == 0:
        stage_info.remove(auto_travel_info)

    player.travel_component.save()
    if settle_type:
        player.finance.gold -= travel_event_config.get('events').get(event_id).price
        player.finance.save_data()

    deal_auto_response(response, player)

    response.res.result = True
    response.SerializeToString()


def deal_auto_response(response, player):
    for (stage_id, item) in player.travel_component.auto.items():
        stage_travel = response.stage_travel.add()
        stage_travel.stage_id = stage_id
        for auto_info in item:
            auto_travel = stage_travel.auto_travel.add()
            auto_travel.start_time = auto_info.get('start_time')
            auto_travel.continued_time = auto_info.get('continued_time')
            auto_travel.already_times = auto_info.get('already_times')
            for tra in auto_info.get('events'):

                res_travel = auto_travel.travel.add()
                res_travel.event_id = tra[0]
                res_drops = res_travel.drops
                drop_data = get_drop_data(tra[1])
                get_return(player, drop_data, res_drops)
                if travel_event_config.get('events').get(tra[0]).type == 1:
                    if len(tra) == 3:
                        res_travel.time = tra[2]


def update_auto(player):
    for (stage_id, item) in player.travel_component.auto.items():
        for one_auto in item:
            auto_travel_config = base_config.get('autoTravel').get(one_auto.get('continued_time'))
            timeA = int(time.time()) - one_auto.get('start_time')
            if timeA > one_auto.get('continued_time') * 60:
                cishu = auto_travel_config[0]
            else:
                cishu = timeA / (one_auto.get('continued_time') * 60 / auto_travel_config[0])
            need_times = cishu - one_auto.get('already_times')
            if need_times > 0:
                for _ in range(need_times):

                    while(True):
                        travel_event_id = get_travel_event_id()
                        flag = 1
                        for event in one_auto.get('events'):
                            if travel_event_id == event[0]:
                                flag = 0
                        if flag:
                            break
                    # 掉落
                    drops = get_drops(stage_id)
                    if travel_event_config.get('events').get(travel_event_id).type == 1:
                        the_time = (one_auto.get('continued_time') * 60 / auto_travel_config[0]) * (one_auto.get('already_times') + 1)

                        one_auto.get('events').append([travel_event_id, drops, the_time])
                    else:
                        one_auto.get('events').append([travel_event_id, drops])
                    one_auto['already_times'] += 1

    player.travel_component.save()


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


def get_drop_data(drops):
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
    return drop_data


def get_drops(stage_id):
    drops = []
    stage_info = stage_config.get('stages').get(stage_id)
    common_bag = BigBag(stage_info.commonDrop)
    common_drop = common_bag.get_drop_items()
    drops.extend(common_drop)

    return drops
