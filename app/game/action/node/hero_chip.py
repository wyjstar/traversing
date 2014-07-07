# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午6:25.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.game.core.hero import Hero
from app.proto_file.hero_request_pb2 import HeroComposeRequest
from app.game.core.PlayersManager import PlayersManager
from app.proto_file.hero_response_pb2 import CommonResponse
from shared.db_opear.configs_data.game_configs import hero_chip_config


@remote_service_handle
def hero_compose_201(dynamicid, data):
    """武将合成"""
    args = HeroComposeRequest()
    args.ParseFromString(data)
    hero_chip_no = args.hero_chip_no

    player = PlayersManager().get_player_by_dynamic_id(dynamicid)
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