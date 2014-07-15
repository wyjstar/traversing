# -*- coding:utf-8 -*-
"""
created by wzp on 14-6-27下午2:05.
"""

from app.game.service.gatenoteservice import remote_service_handle
from app.proto_file.hero_request_pb2 import HeroUpgradeWithItemRequest,\
    HeroBreakRequest, HeroSacrificeRequest, HeroComposeRequest
from app.proto_file.hero_response_pb2 import GetHerosResponse, HeroUpgradeResponse, \
    HeroSacrificeResponse, HeroBreakResponse, HeroComposeResponse
from app.game.core.PlayersManager import PlayersManager
from shared.db_opear.configs_data.game_configs import base_config, item_config, hero_breakup_config, chip_config
from app.game.core.hero import Hero
from shared.db_opear.configs_data.game_configs import hero_config
from app.game.logic.item_group_helper import is_afford, consume

@remote_service_handle
def get_hero_list_101(dynamic_id, pro_data=None):
    """取得武将列表
    """
    player = PlayersManager().get_player_by_dynamic_id(dynamic_id)
    response = GetHerosResponse()
    for hero in player.hero_component.get_heros():
        hero_pb = response.heros.add()
        hero.update_pb(hero_pb)
    response.res.result = True
    return response.SerializePartialToString()


@remote_service_handle
def hero_upgrade_with_item_103(dynamicid, data):
    """武将升级，使用经验药水"""
    args = HeroUpgradeWithItemRequest()
    args.ParseFromString(data)
    response = HeroUpgradeResponse()

    hero_no = args.hero_no
    exp_item_no = args.exp_item_no
    exp_item_num = args.exp_item_num

    player = PlayersManager().get_player_by_dynamic_id(dynamicid)
    exp_item = player.item_package.get_item(exp_item_no)
    # 服务器验证
    if exp_item.num < exp_item_num:
        response.res.result = False
        response.res.message = "经验药水道具不足！"
        return response.SerializeToString()

    exp = item_config.get(exp_item_no).get('func_args1')
    hero = player.hero_component.get_hero(hero_no)
    hero.upgrade(exp * exp_item_num)
    player.item_package.consume_item(exp_item_no, exp_item_num)

    # 返回
    response.res.result = True
    response.level = hero.level
    response.exp = hero.exp
    return response.SerializeToString()


@remote_service_handle
def hero_break_104(dynamicid, data):
    """武将突破"""
    args = HeroBreakRequest()
    args.ParseFromString(data)
    hero_no = args.hero_no
    player = PlayersManager().get_player_by_dynamic_id(dynamicid)

    hero = player.hero_component.get_hero(hero_no)
    response = HeroBreakResponse()

    item_group = hero_breakup_config.get(hero.hero_no).get_consume(hero.break_level)
    result = is_afford(player, item_group)  # 校验
    if not result.get('result'):
        response.res.result = False
        response.res.message = '消费不足！'
    consume(player, item_group)  # 消耗
    hero.break_level += 1
    hero.save_data()

    # 3、返回
    response.res.result = True
    response.break_level = hero.break_level
    return response.SerializeToString()


@remote_service_handle
def hero_sacrifice_105(dynamicid, data):
    """武将献祭"""
    args = HeroSacrificeRequest()
    args.ParseFromString(data)

    player = PlayersManager().get_player_by_dynamic_id(dynamicid)
    heros = player.hero_component.get_heros_by_nos(args.hero_nos)
    total_hero_soul, exp_item_no, exp_item_num = hero_sacrifice(heros)

    # remove hero
    player.hero_component.delete_heros_by_nos(args.hero_nos)
    response = HeroSacrificeResponse()
    response.res.result = True
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
        hero_soul = hero_config.get(hero.hero_no).sacrifice_hero_soul
        total_hero_soul += hero_soul
        exp = hero.get_all_exp()
        total_exp += exp

    exp_items = base_config.get("exp_items")
    for item_no in exp_items:
        config = item_config.get(item_no)
        exp = config.get("func_args1")
        if total_exp/exp > 0:
            exp_item_no = item_no
            exp_item_num = total_exp/exp
            break

    return total_hero_soul, exp_item_no, exp_item_num


@remote_service_handle
def hero_compose_106(dynamicid, data):
    """武将合成"""
    args = HeroComposeRequest()
    args.ParseFromString(data)
    hero_chip_no = args.hero_chip_no

    player = PlayersManager().get_player_by_dynamic_id(dynamicid)
    response = HeroComposeResponse()
    print 'combine', chip_config.get("chips").get(hero_chip_no)
    hero_no = chip_config.get("chips").get(hero_chip_no).combineResult

    need_num = chip_config.get("chips").get(hero_chip_no).need_num
    hero_chip = player.hero_chip_component.get_chip(hero_chip_no)

    # 服务器校验
    if hero_chip.num < need_num:
        response.res.result = False
        response.res.message = "碎片不足，合成失败！"
        return response.SerializeToString()

    print "hero_no", hero_no
    if player.hero_component.contain_hero(hero_no):
        response.res.result = False
        response.res.message = "武将已存在，合成失败！"
        return response.SerializeToString()

    hero = player.hero_component.add_hero(hero_no)
    hero_chip.consume_chip(need_num)  # 消耗碎片

    # 3、返回
    response.res.result = True
    hero.update_pb(response.hero)
    return response.SerializeToString()















