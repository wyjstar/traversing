# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午2:55.
"""

from app.game.logic.common.check import have_player
from app.proto_file.hero_request_pb2 import HeroUpgradeWithItemRequest,\
    HeroBreakRequest, HeroSacrificeRequest, HeroComposeRequest, HeroSellRequest
from app.proto_file.hero_response_pb2 import GetHerosResponse, HeroUpgradeResponse, \
    HeroBreakResponse, HeroComposeResponse
from shared.db_opear.configs_data.game_configs import base_config, item_config, \
    hero_breakup_config, chip_config, hero_config
from app.game.logic.item_group_helper import is_afford, consume, gain, get_return
from app.proto_file.hero_response_pb2 import HeroSacrificeResponse, HeroSellResponse


@have_player
def get_heros(dynamic_id, **kwargs):
    player = kwargs.get('player')
    response = GetHerosResponse()
    for hero in player.hero_component.get_heros():
        hero_pb = response.heros.add()
        hero.update_pb(hero_pb)
    return response.SerializePartialToString()


@have_player
def hero_upgrade_with_item(dynamicid, data, **kwargs):
    player = kwargs.get('player')

    args = HeroUpgradeWithItemRequest()
    args.ParseFromString(data)
    response = HeroUpgradeResponse()
    hero_no = args.hero_no
    exp_item_no = args.exp_item_no
    exp_item_num = args.exp_item_num
    exp_item = player.item_package.get_item(exp_item_no)
    # 服务器验证
    if exp_item.num < exp_item_num:
        response.res.result = False
        response.res.message = "经验药水道具不足！"
        return response.SerializeToString()
    exp = item_config.get(exp_item_no).get('funcArgs1')
    hero = player.hero_component.get_hero(hero_no)
    hero.upgrade(exp * exp_item_num)
    player.item_package.consume_item(exp_item_no, exp_item_num)
    # 返回
    response.res.result = True
    response.level = hero.level
    response.exp = hero.exp
    return response.SerializeToString()


@have_player
def hero_break(dynamicid, data, **kwargs):
    player = kwargs.get('player')
    args = HeroBreakRequest()
    args.ParseFromString(data)
    hero_no = args.hero_no
    hero = player.hero_component.get_hero(hero_no)
    response = HeroBreakResponse()
    # 验证武将是否突破到上限
    if hero.break_level == hero_config.get(hero_no).breakLimit:
        response.res.result = False
        response.res.result_no = 201
        return response.SerializeToString()

    item_group = hero_breakup_config.get(hero.hero_no).get_consume(hero.break_level)
    # 判断是否足够
    result = is_afford(player, item_group)  # 校验
    if not result.get('result'):
        response.res.result = False
        response.res.result_no = result.get('result_no')
        return response.SerializeToString()

    # 返回消耗
    return_data = consume(player, item_group)
    get_return(player, return_data, response.consume)

    hero.break_level += 1
    hero.save_data()
    # 3、返回
    response.res.result = True
    response.break_level = hero.break_level
    return response.SerializeToString()


@have_player
def hero_sacrifice(dynamicid, data, **kwargs):
    player = kwargs.get('player')
    args = HeroSacrificeRequest()
    args.ParseFromString(data)
    heros = player.hero_component.get_heros_by_nos(args.hero_nos)
    print args.hero_nos
    print heros, "heros++++++++"
    if len(heros) == 0:
        print "hero %s is not exists." % str(args.hero_nos)
    response = hero_sacrifice_oper(heros, player)
    # remove hero
    player.hero_component.delete_heros_by_nos(args.hero_nos)
    return response.SerializeToString()


def hero_sacrifice_oper(heros, player):
    """
    武将献祭，返回总武魂、经验药水
    :param heros: 被献祭的武将
    :return total_hero_soul:总武魂数量, exp_item_no:经验药水编号, exp_item_num:经验药水数量
    """
    total_exp = 0
    exp_item_no = 0
    exp_item_num = 0

    response = HeroSacrificeResponse()
    gain_response = response.gain
    for hero in heros:
        sacrifice_gain = hero_config.get(hero.hero_no).sacrificeGain
        return_data = gain(player, sacrifice_gain)
        get_return(player, return_data, gain_response)
        # 经验
        exp = hero.get_all_exp()
        total_exp += exp

    # baseconfig {1000000: 'item_id'}
    exp_items = base_config.get("exp_items")
    for item_no in exp_items:
        config = item_config.get(item_no)
        exp = config.get("funcArgs1")
        if total_exp/exp > 0:
            exp_item_no = item_no
            exp_item_num = total_exp/exp
            break
    item_pb = gain_response.items.add()
    item_pb.item_no = exp_item_no
    item_pb.item_num = exp_item_num
    response.res.result = True
    return response


@have_player
def hero_compose(dynamicid, data, **kwargs):
    player = kwargs.get('player')

    args = HeroComposeRequest()
    args.ParseFromString(data)
    hero_chip_no = args.hero_chip_no
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


@have_player
def hero_sell(dynamicid, data, **kwargs):
    """武将出售"""
    player = kwargs.get('player')

    args = HeroSellRequest()
    args.ParseFromString(data)
    hero_nos = args.hero_nos

    response = HeroSellResponse()
    for hero_no in hero_nos:
        sell_gain = hero_config.get(hero_no).sellGain
        return_data = gain(player, sell_gain)
        get_return(player, return_data, response.gain)

    response.res.result = True
    return response


