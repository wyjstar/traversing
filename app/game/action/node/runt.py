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
    args = RuntSetRequest()
    args.ParseFromString(data)
    hero_no = args.hero_no
    runt_type = args.runt_type
    runt_po = args.runt_po
    runt_no = args.runt_no

    response = RuntSetResponse()

    hero = player.hero_component.get_hero(hero_no)

    if runt_po > base_config.get('totemSpaceNum'+str(runt_type)):
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

    hero.runt.get(runt_type)[runt_po] = [runt_no] + runt_info

    if not player.runt.reduce_runt(runt_no):
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()

    hero.save_data()
    player.runt.save()

    response.res.result = True
    return response.SerializeToString()


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

    if runt_po:
        if not hero.runt.get(runt_type) or not hero.runt.get(runt_type).get(runt_po):
            response.res.result = False
            response.res.result_no = 823  # 符文不存在
            return response.SerializeToString()
        runt_info = hero.runt.get(runt_type).get(runt_po)

        need_gold = stone_config.get('stones').get(runt_info[1]).PickPrice

        if not player.runt.pick_runt(runt_info):
            response.res.result = False
            response.res.result_no = 824
            return response.SerializeToString()

        del hero.runt[runt_type][runt_po]
    else:
        need_gold = 0
        for (_, runt_info) in hero.runt[runt_type].items():
            need_gold += stone_config.get('stones').get(runt_info[1]).PickPrice
            player.runt.pick_runt(runt_info):
        del hero.runt[runt_type]

    if player.finance.gold < need_gold:
        response.res.result = False
        response.res.result_no = 102  # 充值币不足
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

    for (runt_no, runt_info) in my_runt.items():
        mrunt = response.runt.add()
        mrunt.runt_no = runt_no
        [runt_id, main_attr, minor_attr] = runt_info
        mrunt.runt_id = runt_id
        for (attr_type, [attr_value_type, attr_value, attr_increment]) in main_attr.items():
            main_attr_pb = mrunt.main_attr.add()
            main_attr_pb.attr_type = attr_type
            main_attr_pb.attr_value_type = attr_value_type
            main_attr_pb.attr_value = attr_value
            main_attr_pb.attr_increment = attr_increment

        for (attr_type, [attr_value_type, attr_value, attr_increment]) in minor_attr.items():
            minor_attr_pb = mrunt.minor_attr.add()
            minor_attr_pb.attr_type = attr_type
            minor_attr_pb.attr_value_type = attr_value_type
            minor_attr_pb.attr_value = attr_value
            minor_attr_pb.attr_increment = attr_increment


    if time.localtime(player.runt.refresh_times[1]).tm_year == time.localtime().tm_year \
            and time.localtime(player.runt.refresh_times[1]).tm_yday == time.localtime().tm_yday:
        response.refresh_times = player.runt.refresh_times[0]
    else:
        response.refresh_times = 0

    response.stone1 = player.runt.stone1
    response.stone2 = player.runt.stone2
    response.refresh_id = player.runt.refresh_id

    logger.debug(response)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def refresh_runt_844(data, player):
    """打造刷新"""
    response = RefreshRuntResponse()

    if time.localtime(player.runt.refresh_times[1]).tm_year == time.localtime().tm_year \
            and time.localtime(player.runt.refresh_times[1]).tm_yday == time.localtime().tm_yday:
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
    runts = args.runt

    response = RefiningRuntResponse()

    stone1 = 0
    stone2 = 0
    runt = []
    for runt_no in runts:
        runt_info = player.runt.m_runt.get(runt_no)

        runt_conf = stone_config.get('stones').get(runt_info[1])
        stone1 += runt_conf.stone1
        stone2 += runt_conf.stone2
        if random.random() < runt_conf.biggerStoneCri:
            get_runt_id = runt_conf.getbiggerStoneID[random.randint(0, len(runt_conf.biggerStoneId)-1)]
            new_runt_no = player.runt.add_runt(runt_id)
            if new_runt_no:
                runt.append(new_runt_no)

    player.runt.stone1 += stone1
    player.runt.stone2 += stone2

    player.runt.save()

    for runt_no in runt:
        runt_info = player.runt.m_runt.get(runt_no)
        mrunt = response.runt.add()
        mrunt.runt_no = runt_no
        [runt_id, main_attr, minor_attr] = runt_info
        mrunt.runt_id = runt_id
        for (attr_type, [attr_value_type, attr_value, attr_increment]) in main_attr.items():
            main_attr_pb = mrunt.main_attr.add()
            main_attr_pb.attr_type = attr_type
            main_attr_pb.attr_value_type = attr_value_type
            main_attr_pb.attr_value = attr_value
            main_attr_pb.attr_increment = attr_increment

        for (attr_type, [attr_value_type, attr_value, attr_increment]) in minor_attr.items():
            minor_attr_pb = mrunt.minor_attr.add()
            minor_attr_pb.attr_type = attr_type
            minor_attr_pb.attr_value_type = attr_value_type
            minor_attr_pb.attr_value = attr_value
            minor_attr_pb.attr_increment = attr_increment

    response.stone1 = stone1
    response.stone2 = stone2

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def build_runt_846(data, player):
    """打造"""
    response = BuildRuntResponse()

    runt_id = player.runt.refresh_id
    if not runt_id:
        response.res.result = False
        response.res.result_no = 828
        return response.SerializeToString()

    runt_conf = stone_config.get('stones').get(runt_id)
    [need_stone1, need_stone2, need_coin] = runt_conf.price
    if player.runt.stone1 < need_stone1 or player.runt.stone2 < need_stone2 or player.finance.coin < need_coin:
        response.res.result = False
        response.res.result_no = 826
        return response.SerializeToString()

    player.runt.stone1 -= need_stone1
    player.runt.stone2 -= need_stone2
    player.finance.coin -= need_coin

    runt_no = player.runt.add_runt(runt_id)
    if not runt_no:
        response.res.result = False
        response.res.result_no = 824
        return response.SerializeToString()

    while True:
        new_refresh_id = player.runt.build_refresh()
        if not player.runt.refresh_id == new_refresh_id:
            break

    response.refresh_id = new_refresh_id
    runt_info = player.runt.m_runt.get(runt_no)
    mrunt = response.runt.add()
    mrunt.runt_no = runt_no
    [runt_id, main_attr, minor_attr] = runt_info
    mrunt.runt_id = runt_id
    for (attr_type, [attr_value_type, attr_value, attr_increment]) in main_attr.items():
        main_attr_pb = mrunt.main_attr.add()
        main_attr_pb.attr_type = attr_type
        main_attr_pb.attr_value_type = attr_value_type
        main_attr_pb.attr_value = attr_value
        main_attr_pb.attr_increment = attr_increment

    for (attr_type, [attr_value_type, attr_value, attr_increment]) in minor_attr.items():
        minor_attr_pb = mrunt.minor_attr.add()
        minor_attr_pb.attr_type = attr_type
        minor_attr_pb.attr_value_type = attr_value_type
        minor_attr_pb.attr_value = attr_value
        minor_attr_pb.attr_increment = attr_increment

    player.runt.save()
    player.finance.save_data()

    response.res.result = True
    return response.SerializeToString()
