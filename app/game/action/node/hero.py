# -*- coding:utf-8 -*-
"""
created by wzp on 14-6-27下午2:05.
"""

from app.game.service.gatenoteservice import remote_service_handle
from app.proto_file.hero_request_pb2 import HeroUpgradeRequest, HeroBreakRequest, HeroSacrificeRequest
from app.game.core.hero import Hero
from app.proto_file.hero_response_pb2 import CommonResponse, HeroSacrificeResponse
from app.game.core.PlayersManager import PlayersManager
from shared.db_opear.configs_data.game_configs import base_config, item


@remote_service_handle
def hero_upgrade_101(dynamicid, data):
    """武将升级"""
    args = HeroUpgradeRequest()
    args.ParseFromString(data)

    playerid = args.id
    hero_no = args.hero_no

    player = PlayersManager.get_player_by_id(playerid)
    hero = player.hero_list.get_hero_by_no(hero_no)
    hero.level = args.level
    hero.exp = args.exp

    # 返回
    response = CommonResponse()
    response.result = True
    return response.SerializeToString()


@remote_service_handle
def hero_break_102(dynamicid, data):
    """武将突破"""
    args = HeroBreakRequest()
    args.ParseFromString(data)
    playerid = args.id
    hero_no = args.hero_no
    consume_coin = args.coin

    player = PlayersManager.get_player_by_id(playerid)
    hero = player.hero_list.get_hero_by_no(hero_no)
    response = CommonResponse()

    #服务器校验
    if not player.finance.is_afford(consume_coin):
        response.result = False
        response.message = "金币不足！"
        return response.SerializeToString()

    # 1、设置突破等级
    hero.break_level = args.break_level
    # 2、消耗金币
    player.finance.consume(consume_coin)
    # 3、返回
    response.result = True
    return response.SerializeToString()


@remote_service_handle
def hero_compose_103(dynamicid, data):
    """武将合成"""
    args = HeroUpgradeRequest()
    args.ParseFromString(data)
    playerid = args.id
    hero_no = args.hero_no
    consume_coin = args.coin
    consume_chipids = args.chipids

    player = PlayersManager.get_player_by_id(playerid)
    response = CommonResponse()

    # 服务器校验
    if not player.finance.is_afford(consume_coin):
        response.result = False
        response.message = "金币不足！"
        return response.SerializeToString()

    if not player.hero_list.contain_hero(hero_no):
        response.result = False
        response.message = "武将已存在，合成失败！"
        return response.SerializeToString()

    # 1、添加武将
    hero = Hero()
    hero.hero_no = hero_no
    player.hero_list.add_hero(hero)
    # 2、消耗碎片、金币
    player.finance.consume_coin(consume_coin)
    player.chip.consume_chip(consume_chipids)

    # 3、返回
    response.result = True
    return response.SerializeToString()


@remote_service_handle
def hero_sacrifice_104(dynamicid, data):
    """武将献祭"""
    args = HeroSacrificeRequest()
    args.ParseFromString(data)

    player = PlayersManager.get_player_by_dynamic_id(dynamicid)

    total_exp = 0
    total_hero_soul = 0
    exp_item_no = 0
    exp_item_num = 0

    for hero_no in args.hero_no_list:
        hero = player.hero_list.get_hero_by_no(hero_no)
        hero_soul = hero.config.sacrifice_hero_soul
        total_hero_soul += hero_soul
        exp = hero.get_all_exp()
        total_exp += exp

    exp_items = base_config.get("sacrifice_exp")
    for item_no in exp_items:
        item_config = item.get(item_no)
        exp = item_config.get("exp")
        if total_exp/exp > 0:
            exp_item_no = item_no
            exp_item_num = total_exp/exp

    response = HeroSacrificeResponse()
    response.hero_soul = total_hero_soul
    response.exp_item_no = exp_item_no
    response.exp_item_num = exp_item_num
    return response.SerializeToString()














