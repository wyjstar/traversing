# -*- coding: utf-8 -*-
"""
created by wzp on 14-6-19下午7: 51.
"""
from app.game.core.character.PlayerCharacter import PlayerCharacter
from app.game.core.PlayersManager import PlayersManager
from app.proto_file.game_pb2 import GameLoginResponse
import time
from app.game.action.node.player import init_player
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.logobj import logger


@remoteserviceHandle('gate')
def enter_scene(dynamic_id, character_id):
    """进入场景"""
    player = PlayersManager().get_player_by_id(character_id)
    if not player:
        player = PlayerCharacter(character_id, dynamic_id=dynamic_id)
        init_player(player)
        PlayersManager().add_player(player)

    responsedata = GameLoginResponse()
    responsedata.res.result = True
    responsedata.id = player.base_info.id
    responsedata.nickname = player.base_info.base_name

    responsedata.level = player.level.level
    responsedata.exp = player.level.exp

    responsedata.coin = player.finance.coin
    responsedata.gold = player.finance.gold
    responsedata.hero_soul = player.finance.hero_soul
    responsedata.junior_stone = player.finance.junior_stone
    responsedata.middle_stone = player.finance.middle_stone
    responsedata.high_stone = player.finance.high_stone

    responsedata.fine_hero = player.last_pick_time.fine_hero
    responsedata.excellent_hero = player.last_pick_time.excellent_hero
    responsedata.fine_equipment = player.last_pick_time.fine_equipment
    responsedata.excellent_equipment = player.last_pick_time.excellent_equipment

    responsedata.pvp_times = player.pvp_times

    responsedata.combat_power = player.line_up_component.combat_power

    if player.guild.g_id != 0:
        responsedata.guild_id = player.guild.g_id

    responsedata.vip_level = player.vip_component.vip_level
    # 体力
    responsedata.stamina = player.stamina.stamina
    responsedata.get_stamina_times = player.stamina.get_stamina_times
    responsedata.buy_stamina_times = player.stamina.buy_stamina_times
    responsedata.last_gain_stamina_time = player.stamina.last_gain_stamina_time
    responsedata.server_time = int(time.time())
    responsedata.soul_shop_refresh_times = player.soul_shop.refresh_times

    logger.debug("character info:----------------------")
    logger.debug("vip_level:%d", player.vip_component.vip_level)
    logger.debug("stamina:%d", player.stamina.stamina)
    logger.debug("coin:%d", player.finance.coin)
    logger.debug("gold:%d", player.finance.gold)
    logger.debug("hero_soul:%d", player.finance.hero_soul)
    logger.debug("soul_shop_refresh_times:%d", player.soul_shop.refresh_times)

    return responsedata.SerializeToString()
