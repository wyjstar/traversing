# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file.runt_pb2 import RuntSetRequest, RuntSetResponse, \
    RuntPickRequest, RuntPickResponse, InitRuntResponse, RefreshRuntResponse, \
    RefiningRuntRequest, RefiningRuntResponse, BuildRuntResponse
from shared.db_opear.configs_data.game_configs import stone_config, base_config
from gfirefly.server.logobj import logger
import random
import time


@remoteserviceHandle('gate')
def runt_set_841(data, player):
    """镶嵌符文"""
    args = RunSetRequest()
    args.ParseFromString(data)
    hero_no = args.hero_no
    runt_type = args.runt_type
    runt_po = args.runt_po
    runt_id = args.runt_id

    response = RunSetResponse()

    hero = player.hero_component.get_hero(hero_no)

    if hero.runt.get(runt_type):
        if hero.runt.get(runt_type).get(runt_po):
            response.res.result = False
            response.res.result_no = 821
            return response.SerializeToString()
    else:
        hero.runt[runt_type] = {}

    hero.runt.get(runt_type)[runt_po] = runt_id

    if player.runt.reduce_runt(runt_id, 1):
        response.res.result = False
        response.res.result_no = 825
        return response.SerializeToString()

    hero.save_data()
    player.runt.save()

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def runt_pick_842(data, player):
    """摘除符文"""
    args = RunPickRequest()
    args.ParseFromString(data)
    hero_no = args.hero_no
    runt_type = args.runt_type
    runt_po = args.runt_po

    response = RunPickResponse()

    hero = player.hero_component.get_hero(hero_no)

    if not hero.runt.get(runt_type) or not hero.runt.get(runt_type).get(runt_po):
        response.res.result = False
        response.res.result_no = 823  # 符文不存在
        return response.SerializeToString()

    runt_id = hero.runt.get(runt_type).get(runt_po)

    runt_conf = stone_config.get('stones').get(runt_id)
    need_gold = runt_conf.PickPrice

    if player.finance.gold < need_gold:
        response.res.result = False
        response.res.result_no = 102  # 充值币不足
        return response.SerializeToString()

    del hero.runt[runt_type][runt_po]

    if not player.runt.add_runt(runt_id, 1):
        response.res.result = False
        response.res.result_no = 824
        return response.SerializeToString()

    hero.save_data()
    player.runt.save()

    player.finance.gold -= need_gold
    player.finance.save_data()

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def init_runt_843(data, player):
    """初始化"""
    response = InitRuntResponse()

    my_runt = player.runt.m_runt

    for (runt_id, num) in my_runt.items():
        mrunt = response.runt.add()
        mrunt.runt_id = runt_id
        mrunt.num = num

    if time.localtime(player.runt.refresh_times[1]).tm_year == time.localtime().tm_year \
            and time.localtime(player.refresh_times).tm_yday == time.localtime().tm_yday:
        response.refresh_times = player.runt.refresh_times
    else:
        response.refresh_times = 0

    response.stone1 = player.runt.stone1
    response.stone2 = player.runt.stone2
    response.refresh_id = player.runt.refresh_id

    return response.SerializeToString()


@remoteserviceHandle('gate')
def refresh_runt_844(data, player):
    """打造刷新"""
    response = RefreshRuntResponse()

    if time.localtime(player.runt.refresh_times[1]).tm_year == time.localtime().tm_year \
            and time.localtime(player.refresh_times).tm_yday == time.localtime().tm_yday:
        if base_config.get('totemRefreshFreeTimes') > player.runt.refresh_times[0]:
            player.runt.refresh_times[0] += 1
        else:
            if player.finance.gold > base_config.get('totemRefreshPrice'):
                player.finance.gold -= base_config.get('totemRefreshPrice')
            else:
                response.res.result = False
                response.res.result_no = 102  # 充值币不足
                return response.SerializeToString()

    else:
        player.runt.refresh_times = [1, int(time.time())]

    while True:
        new_refresh_id = player.runt.build_refresh()
        if not player.runt.refresh_id == new_refresh_id:
            break

    player.finance.save_data()
    player.runt.save()

    response.refresh_id = new_refresh_id

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def refining_runt_845(data, player):
    """符文炼化"""
    args = RefiningRuntRequest()
    args.ParseFromString(data)
    runts = args.hero_no

    response = RefiningRuntResponse()

    stone1 = 0
    stone2 = 0
    runt = {}
    for (runt_id, num) in runts.items():
        if not player.runt.add_runt(runt_id, num):
            response.res.result = False
            response.res.result_no = 824
            return response.SerializeToString()

        runt_conf = stone_config.get('stones').get(runt_id)
        stone1 += runt_conf.stone1
        stone2 += runt_conf.stone2
        if random.random() < runt_conf.biggerStoneCri:
            get_runt_id = runt_conf.getbiggerStoneID[random.randint(0, len(runt_conf.biggerStoneId)-1)]
            if runt.get(get_runt_id):
                runt[get_runt_id] += runt_conf.biggerStoneNum

    for (runt_id, num) in runt.items():
        if not player.runt.add_runt(runt_id, num):
            response.res.result = False
            response.res.result_no = 824
            return response.SerializeToString()

    player.runt.stone1 += stone1
    player.runt.stone2 += stone2

    player.runt.save()

    for (runt_id, num) in runt.items():
        res_runt = response.runt.add()
        res_runt.runt_id = runt_id
        res_runt.num = num

    response.stone1 = stone1
    response.stone2 = stone2

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def build_runt_846(data, player):
    """打造刷新"""
    response = BuildRuntResponse()

    runt_id = player.runt.refresh_id
    runt_conf = stone_config.get('stones').get(runt_id)
    [need_stone1, need_stone2, need_coin] = runt_conf.price
    if player.runt.stone1 < need_stone1 or player.runt.stone2 < need_coin or player.finance.coin < need_coin:
        response.res.result = False
        response.res.result_no = 826
        return response.SerializeToString()

    player.runt.stone1 -= need_stone1
    player.runt.stone2 -= need_stone2
    player.finance.coin -= need_coin

    if not player.runt.add_runt(runt_id, 1):
        response.res.result = False
        response.res.result_no = 824
        return response.SerializeToString()

    player.runt.save()
    player.finance.save_data()

    response.res.result = True
    return response.SerializeToString()
