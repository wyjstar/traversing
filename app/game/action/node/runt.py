# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file.runt_pb2 import RuntSetRequest, RuntSetResponse, \
    RuntPickRequest, RuntPickResponse, InitRuntResponse, RefreshRuntResponse, \
    RefiningRuntRequest, RefiningRuntResponse, BuildRuntResponse, \
    MakeRuntResponse, MakeRuntRequest
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from app.game.core.item_group_helper import consume
from app.game.core.item_group_helper import is_consume
from app.game.core.item_group_helper import is_afford
from shared.db_opear.configs_data.data_helper import parse
import random
import time
from shared.utils.pyuuid import get_uuid
import copy
from shared.utils.const import const
from app.game.core.activity import target_update
from shared.tlog import tlog_action
from shared.common_logic.feature_open import is_not_open, FO_RUNT_ADD


@remoteserviceHandle('gate')
def runt_set_841(data, player):
    """镶嵌符文"""
    args = RuntSetRequest()
    args.ParseFromString(data)
    hero_no = args.hero_no
    runt_type = args.runt_type
    runt_set_infos = args.runt_set_info

    response = RuntSetResponse()
    if is_not_open(player, FO_RUNT_ADD):
        response.res.result = False
        response.res.result_no = 837
        return response.SerializeToString()

    hero = player.hero_component.get_hero(hero_no)
    for runt_set_info in runt_set_infos:
        runt_po = runt_set_info.runt_po
        runt_no = runt_set_info.runt_no

        if runt_po > game_configs.base_config.get('totemSpaceNum'+str(runt_type)):
            response.res.result = False
            response.res.result_no = 827
            return response.SerializeToString()

        if hero.runt.get(runt_type):
            if hero.runt.get(runt_type).get(runt_po):
                response.res.result = False
                response.res.result_no = 821
                return response.SerializeToString()
        else:
            hero.runt[runt_type] = {}

        runt_info = player.runt.m_runt.get(runt_no)
        if not runt_info:
            response.res.result = False
            response.res.result_no = 825
            return response.SerializeToString()

    now = int(time.time())
    for runt_set_info in runt_set_infos:
        runt_po = runt_set_info.runt_po
        runt_no = runt_set_info.runt_no
        runt_info = player.runt.m_runt.get(runt_no)
        hero.runt.get(runt_type)[runt_po] = [runt_no] + runt_info
        player.runt.reduce_runt(runt_no)
        tlog_action.log('HeroRuntSet', player, hero_no, now,
                        runt_no, runt_po, runt_info[0])

    target_update(player, [55])
    hero.save_data()
    player.runt.save()

    response.res.result = True
    return response.SerializeToString()


# def do_runt_set(hero_no, runt_type, runt_po, runt_no, player):
#     """镶嵌符文"""
#     pass


@remoteserviceHandle('gate')
def runt_pick_842(data, player):
    """摘除符文"""
    args = RuntPickRequest()
    args.ParseFromString(data)
    hero_no = args.hero_no
    runt_type = args.runt_type
    runt_po = args.runt_po

    response = RuntPickResponse()

    hero = player.hero_component.get_hero(hero_no)

    need_coin = 0
    runts = []
    if runt_po:
        if not hero.runt.get(runt_type) or not hero.runt.get(runt_type).get(runt_po):
            response.res.result = False
            response.res.result_no = 823  # 符文不存在
            return response.SerializeToString()

        runt_info = hero.runt.get(runt_type).get(runt_po)
        need_coin = game_configs.stone_config.get('stones').get(runt_info[1]).PickPrice
        runt_info = hero.runt.get(runt_type).get(runt_po)
        runts = [runt_info]

    else:
        runt_po = 0
        if not hero.runt.get(runt_type):
            response.res.result = False
            response.res.result_no = 823  # 符文不存在
            return response.SerializeToString()
        for (_, runt_info) in hero.runt[runt_type].items():
            need_coin += game_configs.stone_config.get('stones').get(runt_info[1]).PickPrice
            runts.append(runt_info)

    # if player.finance.coin < need_coin:
    #     response.res.result = False
    #     response.res.result_no = 101  # 银币不足
    #     return response.SerializeToString()

    # if len(player.runt.m_runt) + len(runts) > \
    #         game_configs.base_config.get('totemStash'):
    #     response.res.result = False
    #     response.res.result_no = 824
    #     return response.SerializeToString()

    now = int(time.time())
    for runt_info in runts:
        runt_info1 = copy.copy(runt_info)
        del runt_info1[0]
        player.runt.m_runt[runt_info[0]] = runt_info1
        tlog_action.log('HeroRuntPick', player, hero_no, runt_type,
                        now, runt_info[0], runt_po, runt_info1[0])

    if runt_po:
        del hero.runt[runt_type][runt_po]
    else:
        del hero.runt[runt_type]

    hero.save_data()
    player.runt.save()

    # player.finance.consume_coin(need_coin, const.RUNT_PICK)
    # player.finance.save_data()

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def init_runt_843(data, player):
    """初始化"""
    response = InitRuntResponse()

    my_runt = player.runt.m_runt

    for (runt_no, runt_info) in my_runt.items():
        runt_pb = response.runt.add()
        [runt_id, main_attr, minor_attr] = runt_info

        player.runt.deal_runt_pb(runt_no, runt_id, main_attr, minor_attr, runt_pb)

    if time.localtime(player.runt.refresh_times[1]).tm_year == time.localtime().tm_year \
            and time.localtime(player.runt.refresh_times[1]).tm_yday == time.localtime().tm_yday:
        response.refresh_times = player.runt.refresh_times[0]
    else:
        response.refresh_times = 0

    response.stone1 = player.runt.stone1
    response.stone2 = player.runt.stone2

    if player.runt.refresh_runt:
        [runt_no, runt_id, main_attr, minor_attr] = player.runt.refresh_runt
        player.runt.deal_runt_pb(runt_no, runt_id, main_attr, minor_attr, response.refresh_runt)

    return response.SerializeToString()


@remoteserviceHandle('gate')
def refresh_runt_844(data, player):
    """打造刷新"""
    response = RefreshRuntResponse()

    need_gold = 0  # 0 免费，1 招募令，2 元宝
    refresh_times = copy.copy(player.runt.refresh_times)
    if time.localtime(player.runt.refresh_times[1]).tm_year == time.localtime().tm_year \
            and time.localtime(player.runt.refresh_times[1]).tm_yday == time.localtime().tm_yday:
        refresh_times[0] += 1
        if game_configs.base_config.get('totemRefreshFreeTimes') <= player.runt.refresh_times[0]:
            need_gold = 1
    else:
        # player.runt.refresh_times = [1, int(time.time())]
        refresh_times = [1, int(time.time())]

    need_item = game_configs.base_config.get('totemRefreshItem')
    if need_gold == 1 and not is_afford(player, need_item).get('result'):
        need_gold = 2

    if need_gold == 2 and player.finance.gold < game_configs.base_config.get('totemRefreshPrice'):
        response.res.result = False
        response.res.result_no = 102  # 充值币不足
        return response.SerializeToString()

    if need_gold == 1:
        consume(player, need_item, const.RUNT_REFRESH)
    if need_gold == 2:
        player.finance.consume_gold(game_configs.base_config.get('totemRefreshPrice'), const.RUNT_REFRESH)

    player.runt.refresh_times = refresh_times
    while True:
        new_refresh_id = player.runt.build_refresh()
        if player.runt.refresh_runt:
            if not player.runt.refresh_runt[1] == new_refresh_id:
                break
        else:
            break

    runt_no = get_uuid()
    mainAttr, minorAttr = player.runt.get_attr(new_refresh_id)
    player.runt.refresh_runt = [runt_no, new_refresh_id, mainAttr, minorAttr]
    player.runt.deal_runt_pb(runt_no, new_refresh_id, mainAttr, minorAttr, response.refresh_runt)

    player.finance.save_data()
    player.runt.save()

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def refining_runt_845(data, player):
    """符文炼化"""
    args = RefiningRuntRequest()
    args.ParseFromString(data)
    runts = args.runt_no

    response = RefiningRuntResponse()

    stone1 = 0
    stone2 = 0
    runt = []
    for runt_no in runts:
        runt_info = player.runt.m_runt.get(runt_no)
        if not runt_info:
            logger.error('refining runt,runt no dont find,runt no:%s', runt_no)
            continue

        runt_conf = game_configs.stone_config.get('stones').get(runt_info[0])
        stone1 += runt_conf.stone1
        stone2 += runt_conf.stone2
        for _ in range(runt_conf.biggerStoneNum):
            if random.random() <= runt_conf.biggerStoneCri:
                get_runt_id = runt_conf.biggerStoneId[random.randint(0, len(runt_conf.biggerStoneId)-1)]
                new_runt_no = player.runt.add_runt(get_runt_id)
                if new_runt_no:
                    runt.append(new_runt_no)
        del player.runt.m_runt[runt_no]

    player.runt.stone1 += stone1
    player.runt.stone2 += stone2

    player.runt.save()

    for runt_no in runt:
        runt_info = player.runt.m_runt.get(runt_no)
        runt_pb = response.runt.add()
        [runt_id, main_attr, minor_attr] = runt_info

        player.runt.deal_runt_pb(runt_no, runt_id, main_attr, minor_attr, runt_pb)

    response.stone1 = stone1
    response.stone2 = stone2

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def build_runt_846(data, player):
    """打造"""
    response = BuildRuntResponse()

    refresh_runt = player.runt.refresh_runt
    if not refresh_runt:
        response.res.result = False
        response.res.result_no = 828
        return response.SerializeToString()

    runt_conf = game_configs.stone_config.get('stones').get(refresh_runt[1])
    [need_stone1, need_stone2, need_coin] = runt_conf.price
    if player.runt.stone1 < need_stone1 or player.runt.stone2 < need_stone2 or player.finance.coin < need_coin:
        response.res.result = False
        response.res.result_no = 826
        return response.SerializeToString()

    player.runt.stone1 -= need_stone1
    player.runt.stone2 -= need_stone2
    player.finance.coin -= need_coin

    if len(player.runt.m_runt) + 1 > game_configs.base_config.get('totemStash'):
        response.res.result = False
        response.res.result_no = 824
        return response.SerializeToString()

    [runt_no, runt_id, main_attr, minor_attr] = player.runt.refresh_runt
    player.runt.m_runt[runt_no] = [runt_id, main_attr, minor_attr]

    while True:
        new_refresh_id = player.runt.build_refresh()
        if not player.runt.refresh_runt[1] == new_refresh_id:
            break

    runt_no = get_uuid()
    mainAttr, minorAttr = player.runt.get_attr(new_refresh_id)
    player.runt.refresh_runt = [runt_no, new_refresh_id, mainAttr, minorAttr]
    player.runt.deal_runt_pb(runt_no, new_refresh_id, mainAttr, minorAttr, response.refresh_runt)

    player.runt.save()
    player.finance.save_data()

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def make_runt_857(data, player):
    """合成宝石"""
    args = MakeRuntRequest()
    args.ParseFromString(data)
    runts = args.runt_no
    num = args.num
    print args, '==================================', num
    response = MakeRuntResponse()

    price = game_configs.base_config.get('stonesynthesis')

    is_afford_res = is_afford(player, price, multiple=num)  # 校验
    if num and not is_afford_res.get('result'):
        logger.error('make_runt_857, item not enough')
        response.res.result = False
        response.res.result_no = is_afford_res.get('result_no')
        return response.SerializeToString()

    if len(runts) < 5:
        logger.error('make_runt_857, rune count dont enough')
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()

    runt_conf = None
    runt_ids = [0, 0, 0, 0, 0]
    flag = 0
    for runt_no in runts:
        runt_info = player.runt.m_runt.get(runt_no)

        if not runt_info:
            logger.error('make_runt_857,runt no dont find,runt no:%s', runt_no)
            response.res.result = False
            response.res.result_no = 800
            return response.SerializeToString()
        if not runt_conf:
            runt_conf = game_configs.stone_config.get('stones').get(runt_info[0])
        if runt_conf.id != runt_info[0]:
            logger.error('make_runt_857, rune different types')
            response.res.result = False
            response.res.result_no = 800
            return response.SerializeToString()

        runt_ids[flag] = runt_info[0]
        flag += 1

    is_afford_res = is_afford(player, runt_conf.consume)  # 校验
    if num and not is_afford_res.get('result'):
        logger.error('make_runt_857, item not enough')
        response.res.result = False
        response.res.result_no = is_afford_res.get('result_no')
        return response.SerializeToString()

    for runt_no in runts:
        del player.runt.m_runt[runt_no]

    if num:
        consume(player, price, const.RUNT_MAKE, multiple=num)  # 消耗
    consume(player, runt_conf.consume, const.RUNT_MAKE)  # 消耗

    new_runt_no = 0

    random_num = runt_conf.synthesis[0]+runt_conf.synthesis[1]*num
    if random.random() <= random_num:
        get_runt_id = runt_conf.synthesis[2]
    else:
        get_runt_id = runt_conf.id
    new_runt_no = player.runt.add_runt(get_runt_id)

    runt_info = player.runt.m_runt.get(new_runt_no)
    runt_pb = response.runt
    [runt_id, main_attr, minor_attr] = runt_info
    player.runt.deal_runt_pb(new_runt_no, runt_id, main_attr,
                             minor_attr, runt_pb)

    tlog_action.log('MakeRunt', player, runt_ids[0], runt_ids[1],
                    runt_ids[2], runt_ids[3], runt_ids[4], num, runt_id,
                    new_runt_no)

    player.runt.save()
    # 7日活动
    new_runt_conf = game_configs.stone_config.get('stones').get(get_runt_id)
    player.act.mine_mix_runt(new_runt_conf.quality)
    response.res.result = True
    return response.SerializeToString()
