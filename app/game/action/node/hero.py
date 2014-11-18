# -*- coding:utf-8 -*-
"""
created by wzp on 14-6-27下午2:05.
"""

from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import hero_request_pb2
from app.proto_file import hero_response_pb2
from app.proto_file.common_pb2 import CommonResponse
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data.game_configs import base_config, item_config,\
    hero_breakup_config, chip_config, hero_config
from app.game.core.item_group_helper \
    import is_afford, consume, gain, get_return
from shared.utils import log_action
from app.game.core.pack.item import Item


@remoteserviceHandle('gate')
def get_heros_101(pro_data, player):
    """取得武将列表 """
    response = hero_response_pb2.GetHerosResponse()
    for hero in player.hero_component.get_heros():
        hero_pb = response.heros.add()
        hero.update_pb(hero_pb)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def hero_upgrade_with_item_103(data, player):
    """武将升级，使用经验药水"""
    args = hero_request_pb2.HeroUpgradeWithItemRequest()
    args.ParseFromString(data)
    response = hero_response_pb2.HeroUpgradeResponse()
    hero_no = args.hero_no
    exp_item_no = args.exp_item_no
    exp_item_num = args.exp_item_num
    exp_item = player.item_package.get_item(exp_item_no)
    # 服务器验证
    if exp_item:
        if exp_item.num < exp_item_num:
            response.res.result = False
            response.res.result_no = 106
            response.res.message = u"经验药水道具不足！"
            return response.SerializeToString()
    else:
        logger.error('item package can not get item:%d' % exp_item_no)
    exp = item_config.get(exp_item_no).get('funcArg1')
    hero = player.hero_component.get_hero(hero_no)
    hero.upgrade(exp * exp_item_num)
    player.item_package.consume_item(exp_item_no, exp_item_num)
    # 返回
    response.res.result = True
    response.level = hero.level
    response.exp = hero.exp
    return response.SerializeToString()


@remoteserviceHandle('gate')
def hero_break_104(data, player):
    """武将突破"""
    args = hero_request_pb2.HeroBreakRequest()
    args.ParseFromString(data)
    hero_no = args.hero_no
    hero = player.hero_component.get_hero(hero_no)
    response = hero_response_pb2.HeroBreakResponse()

    # 验证武将是否突破到上限
    if hero.break_level == hero_config.get(hero_no).breakLimit:
        response.res.result = False
        response.res.result_no = 201
        return response.SerializeToString()

    _hero_breakup = hero_breakup_config.get(hero.hero_no)
    item_group = _hero_breakup.get_consume(hero.break_level)
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


@remoteserviceHandle('gate')
def hero_sacrifice_105(data, player):
    """武将献祭"""
    args = hero_request_pb2.HeroSacrificeRequest()
    args.ParseFromString(data)
    heros = player.hero_component.get_heros_by_nos(args.hero_nos)
    if len(heros) == 0:
        logger.error("hero %s is not exists." % str(args.hero_nos))
    response = hero_sacrifice_oper(heros, player)
    # remove hero
    player.hero_component.delete_heros_by_nos(args.hero_nos)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def hero_compose_106(data, player):
    """武将合成"""
    args = hero_request_pb2.HeroComposeRequest()
    args.ParseFromString(data)
    hero_chip_no = args.hero_chip_no
    response = hero_response_pb2.HeroComposeResponse()
    hero_no = chip_config.get("chips").get(hero_chip_no).combineResult
    need_num = chip_config.get("chips").get(hero_chip_no).needNum
    if not hero_no or not need_num:
        logger.error("chip_config数据不全!")
    hero_chip = player.hero_chip_component.get_chip(hero_chip_no)
    # 服务器校验
    if hero_chip.num < need_num:
        response.res.result = False
        response.res.message = u"碎片不足，合成失败！"
        return response.SerializeToString()
    if player.hero_component.contain_hero(hero_no):
        response.res.result = False
        response.res.result_no = 202
        response.res.message = u"武将已存在，合成失败！"
        return response.SerializeToString()
    hero = player.hero_component.add_hero(hero_no)
    hero_chip.consume_chip(need_num)  # 消耗碎片

    # tlog
    log_action.hero_flow(player, hero.hero_no, 1, 1)
    log_action.chip_flow(player, hero_chip.chip_no, 1, 0,
                         need_num, hero_chip.num, 1)
    # 3、返回
    response.res.result = True
    hero.update_pb(response.hero)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def hero_sell_107(data, player):
    """武将出售"""
    args = hero_request_pb2.HeroSellRequest()
    args.ParseFromString(data)
    hero_nos = args.hero_nos

    response = hero_response_pb2.HeroSellResponse()
    for hero_no in hero_nos:
        sell_gain = hero_config.get(hero_no).sellGain
        return_data = gain(player, sell_gain)
        get_return(player, return_data, response.gain)

    response.res.result = True
    return response


@remoteserviceHandle('gate')
def hero_refine_108(data, player):
    request = hero_request_pb2.HeroRefineRequest()
    request.ParseFromString(data)
    hero_no = request.hero_no
    hero = player.hero_component.get_hero(hero_no)
    hero.refine = request.refine
    response = CommonResponse()
    response.result = True
    return response.SerializePartialToString()


def hero_sacrifice_oper(heros, player):
    """
    武将献祭，返回总武魂、经验药水
    :param heros: 被献祭的武将
    :return total_hero_soul:总武魂数量, exp_item_no:经验药水编号, exp_item_num:经验药水数量
    """
    total_exp = 0
    exp_item_no = 0
    exp_item_num = 0

    response = hero_response_pb2.HeroSacrificeResponse()
    gain_response = response.gain
    for hero in heros:
        sacrifice_gain = hero_config.get(hero.hero_no).sacrificeGain
        return_data = gain(player, sacrifice_gain)
        get_return(player, return_data, gain_response)
        # 经验
        exp = hero.get_all_exp()
        total_exp += exp

    # baseconfig {1000000: 'item_id'}
    exp_items = base_config.get("sacrificeGainExp")

    keys = []
    try:
        keys = sorted([int(item) for item in list(exp_items)], reverse=True)
    except Exception:
        logger.error("base_config sacrificeGainExp key must be int type:%s.",
                     str(exp_items))
        return

    for exp in keys:
        exp = unicode(exp)
        item_no = exp_items.get(exp)
        config = item_config.get(item_no)
        exp = config.get("funcArg1")
        if total_exp/exp > 0:
            exp_item_no = item_no
            exp_item_num = total_exp/exp
            break

    player.item_package.add_item(Item(exp_item_no, exp_item_num))
    player.item_package.save_data()
    item_pb = gain_response.items.add()
    item_pb.item_no = exp_item_no
    item_pb.item_num = exp_item_num
    response.res.result = True
    return response
