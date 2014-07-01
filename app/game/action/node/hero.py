# -*- coding:utf-8 -*-
"""
created by wzp on 14-6-27下午2:05.
"""

from app.game.service.gatenoteservice import remote_service_handle
from shared.proto_file.hero_request_pb2 import HeroUpgradeRequest, HeroUpgradeRequest, HeroBreakRequest
from app.game.core.hero import Hero
from shared.proto_file.hero_response_pb2 import CommonResponse
from app.game.core.PlayersManager import PlayersManager


@remote_service_handle
def hero_upgrade(dynamicid, data):
    """武将升级"""
    args = HeroUpgradeRequest()
    args.ParseFromString(data)

    playerid = args.id
    hero_no = args.herono

    player = PlayersManager.get_player_by_id(playerid)
    hero = player.hero_list.get_hero_by_no(hero_no)
    hero.level = args.level
    hero.exp = args.exp

    # 返回
    response = CommonResponse()
    response.result = True
    return response.SerializeToString()


@remote_service_handle
def hero_compose(dynamicid, data):
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
def hero_break(dynamicid, data):
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
    hero.breaklevel = args.breaklevel
    # 2、消耗金币
    player.finance.consume(consume_coin)
    # 3、返回
    response.result = True
    return response.SerializeToString()


# def get_hero_list(hero_list, response):
#     """序列化武将列表"""
#     # arg = CommonRequest()
#     # arg.ParseFromString(data)
#     # playerid = arg.id
#     # player = PlayersManager.get_player_by_id(playerid)
#     # hero_list = player.hero_list
#     #
#     # hero_list_pb = HeroListResponse()
#     # hero_list_pb.result = True
#     for hero in hero_list:
#         hero_pb = response.hero_list.add()
#         hero_pb.no = hero.config['no']
#         hero_pb.level = hero.level
#         hero_pb.breaklevel = hero.breaklevel
#         hero_pb.starlevel = hero.starlevel






