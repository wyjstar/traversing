# -*- coding:utf-8 -*-
"""
created by wzp on 14-6-27下午2:05.
"""

from app.game.service.gatenoteservice import remote_service_handle
from app.proto_file.hero_request_pb2 import HeroUpgradeRequest, HeroUpgradeWithItemRequest,\
    HeroBreakRequest, HeroSacrificeRequest, HeroComposeRequest
from app.game.core.hero import Hero
from app.proto_file.hero_response_pb2 import CommonResponse, HeroListResponse, HeroSacrificeResponse
from app.game.core.PlayersManager import PlayersManager
from shared.db_opear.configs_data.game_configs import base_config, item_config, hero_breakup_config, hero_chip_config


@remote_service_handle
def get_hero_list_101(dynamic_id, pro_data):
    """取得武将列表
    """
    player = PlayersManager().get_player_by_dynamic_id(dynamic_id)
    response = HeroListResponse()
    for hero in player.hero_list.get_heros():
        hero_pb = response.hero_list.add()
        hero_pb.hero_no = hero.hero_no
        hero_pb.level = hero.level
        hero_pb.break_level = hero.break_level
        hero_pb.hero_no = hero.hero_no
        hero_pb.exp = hero.exp

    return response.SerializePartialToString()


@remote_service_handle
def hero_upgrade_102(dynamicid, data):
    """武将升级"""
    args = HeroUpgradeRequest()
    args.ParseFromString(data)

    hero_no_list = args.hero_no_list
    exp_list = args.exp_list
    player = PlayersManager.get_player_by_dynamic_id(dynamicid)

    for i in range(len(hero_no_list)):
        hero = player.hero_list.get_hero_by_no(hero_no_list[i])
        exp = exp_list[i]
        hero.upgrade(exp)

    # 返回
    response = CommonResponse()
    response.result = True
    return response.SerializeToString()


@remote_service_handle
def hero_upgrade_with_item_103(dynamicid, data):
    """武将升级，使用经验药水"""
    args = HeroUpgradeWithItemRequest()
    args.ParseFromString(data)
    response = CommonResponse()

    hero_no = args.hero_no
    exp_item_no = args.exp_item_no
    exp_item_num = args.exp_item_num

    player = PlayersManager.get_player_by_dynamic_id(dynamicid)
    exp_item = player.item_package.get_item(exp_item_no)
    # 服务器验证
    if exp_item.num < exp_item_num:
        response.result = False
        response.message = "经验药水道具不足！"
        return response.SerializeToString()

    exp = item_config.get(exp_item_no).get('func_args')
    hero = player.hero_list.get_hero_by_no(hero_no)
    hero.upgrade(exp * exp_item_num)
    player.item_package.consume_item(exp_item_no, exp_item_num)

    # 返回
    response.result = True
    return response.SerializeToString()


@remote_service_handle
def hero_break_104(dynamicid, data):
    """武将突破"""
    args = HeroBreakRequest()
    args.ParseFromString(data)
    hero_no = args.hero_no
    player = PlayersManager.get_player_by_dynamic_id(dynamicid)

    hero = player.hero_list.get_hero_by_no(hero_no)
    response = CommonResponse()
    # 获取该武将突破所需的消耗
    coin = hero_breakup_config.get(hero.hero_no).get(hero.level, 'coin')
    break_pill_no, break_pill_num = hero_breakup_config.get(hero.hero_no).get(hero.level, 'break_pill')
    hero_chip_no, hero_chip_num = hero_breakup_config.get(hero.hero_no).get(hero.level, 'hero_chip')

    # 服务器校验
    if not player.finance.is_afford(coin):
        response.result = False
        response.message = "金币不足！"
        return response.SerializeToString()

    break_pill = player.item_package.get_item(break_pill_no)
    if not break_pill or break_pill_num > break_pill.num:
        response.result = False
        response.message = "突破丹不足！"
        return response.SerializeToString()

    hero_chip = player.item_package.get_item(hero_chip_no)
    if not hero_chip or hero_chip_num > hero_chip.num:
        response.result = False
        response.message = "武将碎片不足！"
        return response.SerializeToString()

    player.finance.consume_coin(coin)  # 消耗金币
    player.item_package.consume_item(break_pill_no, break_pill_num)  # 消耗突破丹
    hero_chip.consume(hero_chip_num)  # 消耗碎片

    # 3、返回
    response.result = True
    return response.SerializeToString()


@remote_service_handle
def hero_compose_105(dynamicid, data):
    """武将合成"""
    args = HeroComposeRequest()
    args.ParseFromString(data)
    hero_chip_no = args.hero_chip_no

    player = PlayersManager.get_player_by_dynamic_id(dynamicid)
    response = CommonResponse()

    hero_no = hero_chip_config.get(hero_chip_no).hero_no
    hero_chip_num = hero_chip_config.get(hero_chip_no).hero_chip_num
    hero_chip = player.hero_chip_list.get(hero_chip_no)

    # 服务器校验
    if hero_chip.num < hero_chip_num:
        response.result = False
        response.message = "碎片不足，合成失败！"
        return response.SerializeToString()

    if not player.hero_list.contain_hero(hero_no):
        response.result = False
        response.message = "武将已存在，合成失败！"
        return response.SerializeToString()

    hero = Hero()
    hero.init_data()
    hero.hero_no = hero_no
    player.hero_list.add_hero(hero)

    hero_chip.consume(hero_chip_num)  # 消耗碎片

    # 3、返回
    response.result = True
    return response.SerializeToString()


@remote_service_handle
def hero_sacrifice_106(dynamicid, data):
    """武将献祭"""
    args = HeroSacrificeRequest()
    args.ParseFromString(data)

    player = PlayersManager.get_player_by_dynamic_id(dynamicid)
    heros = player.hero_list.get_heros_by_nos(args.hero_no_list)
    total_hero_soul, exp_item_no, exp_item_num = hero_sacrifice(heros)

    # remove hero
    player.hero_list.remove_heros_by_nos(args.hero_no_list)
    response = HeroSacrificeResponse()
    response.hero_soul = total_hero_soul
    response.exp_item_no = exp_item_no
    response.exp_item_num = exp_item_num
    return response.SerializeToString()


def hero_sacrifice(heros):
    """
    武将献祭，返回总武魂、经验药水
    :param heros: 被献祭的武将
    :return total_hero_soul:总武魂数量, exp_item_no:经验药水编号, exp_item_num:经验药水数量
    """
    total_exp = 0
    total_hero_soul = 0
    exp_item_no = 0
    exp_item_num = 0

    for hero in heros:
        print "sacrifice_hero_soul", hero.config
        hero_soul = hero.config.sacrifice_hero_soul
        total_hero_soul += hero_soul
        exp = hero.get_all_exp()
        total_exp += exp

    exp_items = base_config.get("exp_items")
    for item_no in exp_items:
        item_config = item_config.get(item_no)
        exp = item_config.get("func_args")
        if total_exp/exp > 0:
            exp_item_no = item_no
            exp_item_num = total_exp/exp
            break

    return total_hero_soul, exp_item_no, exp_item_num















