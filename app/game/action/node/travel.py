# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.game.core.drop_bag import BigBag
from app.proto_file.travel_pb2 import TravelResponse, TravelRequest, \
    TravelInitResponse, BuyShoesRequest, BuyShoesResponse, \
    TravelSettleRequest, TravelSettleResponse, \
    EventStartRequest, EventStartResponse, \
    NoWaitRequest, NoWaitResponse, OpenChestResponse, \
    AutoTravelRequest, AutoTravelResponse, \
    SettleAutoRequest, SettleAutoResponse, \
    FastFinishAutoRequest, FastFinishAutoResponse
from shared.db_opear.configs_data import game_configs
import random
from gfirefly.server.logobj import logger
import time
from gfirefly.server.globalobject import GlobalObject
from shared.utils.const import const
from shared.tlog import tlog_action
from app.game.core.item_group_helper import is_afford, consume
from app.game.core.item_group_helper import gain, get_return
from app.game.core.task import hook_task, CONDITIONId
from shared.common_logic.feature_open import is_not_open, FO_TRAVEL


xs = 100000
remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def travel_831(data, player):
    """游历"""
    args = TravelRequest()
    args.ParseFromString(data)
    stage_id = args.stage_id
    response = TravelResponse()

    if is_not_open(player, FO_TRAVEL):
        response.res.result = False
        response.res.result_no = 811  # 等级不够
        return response.SerializeToString()

    # ====================判断够不够
    need_items = game_configs.base_config.get('travelExpend')
    result = is_afford(player, need_items)  # 校验
    if not result.get('result'):
        response.res.result = False
        response.res.result_no = 888
        return response.SerializePartialToString()
    travel_cache = player.travel_component.travel

    travel_event_id = get_travel_event_id()
    flag = 10
    if travel_cache.get(stage_id):
        for event in travel_cache.get(stage_id):
            if travel_event_id == event[0] % xs:
                flag += 1
    else:
        travel_cache[stage_id] = []

    res_travel_event_id = flag * xs + travel_event_id

    event_info = game_configs.travel_event_config.get('events').get(travel_event_id)
    if not event_info:
        logger.error('get travel event config error')
        response.res.result = False
        response.res.result_no = 800  # 未知错误
        return response.SerializeToString()

    response.event_id = res_travel_event_id

    res_drops = response.drops

    drops = get_drops(stage_id)
    drop_data = get_drop_data(drops)

    get_return(player, drop_data, res_drops)

    # 等待 战斗 答题 领取
    if event_info.type == 4:
        gain(player, drops, const.TRAVEL)
    else:
        travel_cache.get(stage_id).append([res_travel_event_id, drops])

    # ====================消耗
    return_data = consume(player, need_items, const.TRAVEL)
    get_return(player, return_data, response.consume)
    player.travel_component.save()

    hook_task(player, CONDITIONId.TRAVEL, 1)

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
            if game_configs.travel_event_config.get('events').get(tra[0]%xs).type == 1:
                if len(tra) == 3:
                    res_travel.time = tra[2]

    response.chest_time = player.travel_component.chest_time

    player.travel_component.update_travel_item(response)

    update_auto(player, 1)
    deal_auto_response(response, player)

    player.travel_component.save()

    response.res.result = True
    # logger.debug(response)
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
    common_bag = BigBag(game_configs.base_config.get('travelChest'))
    common_drop = common_bag.get_drop_items()
    drops.extend(common_drop)
    drop_data = gain(player, drops, const.TRAVEL_OPEN_CHEST)
    get_return(player, drop_data, res_drops)

    player.travel_component.chest_time = int(time.time())

    player.travel_component.save()

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def travel_settle_833(data, player):
    """ settle,
        type 1 3 这此结算
    """
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

    event_info = game_configs.travel_event_config.get('events').get(args.event_id%xs)
    if event_info.type == 1:
        if not event_cache[2]:
            logger.error('event_cache[2] not find: %s' % event_cache)
            response.res.result = False
            response.res.result_no = 800
            return response.SerializeToString()
        if int(time.time()) - event_cache[2] < \
                event_info.parameter.items()[0][0]:
            response.res.result = False
            response.res.result_no = 814
            return response.SerializeToString()

    # 结算
    if event_info.type == 3 and not event_info.parameter[args.parameter]:
        common_bag = BigBag(event_info.wrong)
        common_drop = common_bag.get_drop_items()

        gain_data = gain(player, common_drop, const.TRAVEL)
        get_return(player, gain_data, response.drops)
    else:
        gain_data = gain(player, event_cache[1], const.TRAVEL)
        get_return(player, gain_data, response.drops)

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
    event_info = game_configs.travel_event_config.get('events').get(args.event_id%xs)
    if event_info.type == 1:
        start_time = int(time.time())
        response.time = start_time

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

    event_info = game_configs.travel_event_config.get('events').get(event_id%xs)
    if player.finance.gold < event_info.price:
        response.res.result = False
        response.res.result_no = 102  # 充值币不足
        return response.SerializeToString()

    player.finance.consume_gold(event_info.price, const.TRAVEL)

    gain(player, event_cache[1], const.TRAVEL)
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

    auto_travel_config = game_configs.base_config.get('autoTravel').get(ttime)

    if player.finance.gold < auto_travel_config[1]:
        response.res.result = False
        response.res.result_no = 102  # 充值币不足
        return response.SerializeToString()

    can_auto_travel = 1
    auto_is_finish = 1
    if player.travel_component.auto.get(stage_id):
        auto_is_finish = 0
        for auto_travel in player.travel_component.auto.get(stage_id):
            if game_configs.base_config.get('autoTravel').get(auto_travel.get('continued_time'))[0] != auto_travel.get('already_times'):
                can_auto_travel = 0
            else:
                for auto_travel_event in auto_travel.get('events'):
                    if len(auto_travel_event) < 3:
                        can_auto_travel = 0

    if not can_auto_travel:
        response.res.result = False
        response.res.result_no = 819
        return response.SerializeToString()

    # 扣元宝
    player.finance.consume_gold(auto_travel_config[1], const.TRAVEL_AUTO)

    # 逻辑
    if auto_is_finish:
        player.travel_component.auto[stage_id] = []
    info = {
        'start_time': int(time.time()),
        'continued_time': ttime,
        'events': [],
        'already_times': 0}
    player.travel_component.auto[stage_id].append(info)
    player.finance.save_data()
    deal_auto_response(response, player)

    response.res.result = True
    tlog_action.log('AutoTravel', player, stage_id, ttime)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def settle_auto_838(data, player):

    args = SettleAutoRequest()
    args.ParseFromString(data)
    stage_id = args.stage_id
    start_time = args.start_time
    event_id = args.event_id  # id 为0  就是全部结算
    settle_type = args.settle_type  # 0 普通结算 1 立即结算

    response = SettleAutoResponse()

    if settle_type: # 立即完成,条件够不够
        if not event_id:
            logger.error('travel seetle type and event id dont matching')
            response.res.result = False
            response.res.result_no = 800
            return response.SerializeToString()
        else:
            event_conf = game_configs.travel_event_config.get('events').get(event_id%xs)
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
    for i in stage_info: # 遍历本章节所有的自动游历组
        if i.get('start_time') == start_time: # 找到要处理的自动游历组
            auto_travel_info = i
    if not auto_travel_info:
        logger.error('auto travel, this start time not find')
        response.res.result = False
        response.res.result_no = 818
        return response.SerializeToString()
    if not event_id: # 全部结算
        if game_configs.base_config.get('autoTravel').get(auto_travel_info.get('continued_time'))[0] != auto_travel_info.get('already_times'):
            logger.error('auto travel dont finish')
            response.res.result = False
            response.res.result_no = 819
            return response.SerializeToString()

    flag1 = 1
    flag = 1
    event_infos = []
    for event_info in auto_travel_info.get('events'):
        if event_info[0] == 0 and event_id != event_info[1]: # 如果 状态是未完成 就标志为0
            flag1 = 0

        if event_id:  # 单独结算
            if event_info[1] != event_id:
                continue

        event_conf = game_configs.travel_event_config.get('events').get(event_info[1]%xs)
        if event_conf.type == 1 and not settle_type:
            if int(time.time()) - event_info[3] < \
                    event_conf.parameter.items()[0][0] * 60:
                continue

        event_infos.append(event_info)
    if not event_infos:
        logger.error('event dont find')
        response.res.result = False
        response.res.result_no = 829
        return response.SerializeToString()

    if settle_type:
        player.finance.consume_gold(game_configs.travel_event_config.get('events').get(event_id%xs).price, const.TRAVEL_AUTO)
        player.finance.save_data()

    for event_info in event_infos:
        # 结算
        gain(player, event_info[2], const.TRAVEL_AUTO)
        event_info[0] = 1

    if game_configs.base_config.get('autoTravel').get(auto_travel_info.get('continued_time'))[0] == auto_travel_info.get('already_times') and flag1:
        stage_info.remove(auto_travel_info)
    player.travel_component.save()
    deal_auto_response(response, player)

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def fast_finish_auto_839(data, player):

    args = FastFinishAutoRequest()
    args.ParseFromString(data)
    start_time = args.start_time
    stage_id = args.stage_id

    response = FastFinishAutoResponse()

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

    update_auto(player, 1)

    if game_configs.base_config.get('autoTravel').get(auto_travel_info.get('continued_time')) == auto_travel_info.get('already_times'):
        logger.error('auto travel dont finish')
        response.res.result = False
        response.res.result_no = 820
        return response.SerializeToString()

    if not game_configs.vip_config.get(player.base_info.vip_level).autoTravelGet:
        logger.error('auto travel dont finish')
        response.res.result = False
        response.res.result_no = 822
        return response.SerializeToString()

    update_auto(player, 2, stage_id)

    player.finance.save_data()
    player.travel_component.save()

    deal_auto_response(response, player)

    response.res.result = True
    return response.SerializeToString()


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
                res_travel.state = tra[0]
                res_travel.event_id = tra[1]
                res_drops = res_travel.drops
                drop_data = get_drop_data(tra[2])
                get_return(player, drop_data, res_drops)
                if game_configs.travel_event_config.get('events').get(tra[1]%xs).type == 1:
                    if len(tra) == 4:
                        res_travel.time = tra[3]


def update_auto(player, up_type, update_stage_id=0):
    # 立刻完成需要stage_id
    # 1 普通 2,立刻
    for (stage_id, item) in player.travel_component.auto.items():
        if up_type == 2 and update_stage_id != stage_id:
            continue
        for one_auto in item:
            auto_travel_config = game_configs.base_config.get('autoTravel').get(one_auto.get('continued_time'))
            timeA = int(time.time()) - one_auto.get('start_time')
            if timeA > one_auto.get('continued_time') * 60 or up_type == 2:
                cishu = auto_travel_config[0]
            else:
                cishu = timeA / (one_auto.get('continued_time') * 60 / auto_travel_config[0])
            need_times = cishu - one_auto.get('already_times')
            if need_times > 0:
                for _ in range(need_times):
                    travel_event_id = get_travel_event_id()
                    flag = 10
                    for event in one_auto.get('events'):
                        if travel_event_id == event[1]%xs:
                            flag += 1
                    res_travel_event_id = flag * xs + travel_event_id

                    # 掉落
                    drops = get_drops(stage_id)
                    if game_configs.travel_event_config.get('events').get(travel_event_id).type == 1:
                        if up_type == 1:
                            the_time = (one_auto.get('continued_time') * 60 / auto_travel_config[0]) * (one_auto.get('already_times') + 1) + one_auto.get('start_time')
                        else:
                            the_time = int(time.time())

                        one_auto.get('events').append([0, res_travel_event_id, drops, the_time])
                    else:
                        one_auto.get('events').append([0, res_travel_event_id, drops])
                    one_auto['already_times'] += 1


def get_travel_event_id():
    travel_event_id = None
    x = random.randint(1, game_configs.travel_event_config.get('weight')[-1][1])
    flag = 0
    for [event_id, weight] in game_configs.travel_event_config.get('weight'):
        if flag < x <= weight:
            travel_event_id = event_id
            break
        flag = weight
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
    stage_info = game_configs.stage_config.get('stages').get(stage_id)
    common_bag = BigBag(stage_info.commonDrop)
    common_drop = common_bag.get_drop_items()
    drops.extend(common_drop)

    return drops
