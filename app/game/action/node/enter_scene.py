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
# from gfirefly.server.globalobject import GlobalObject


@remoteserviceHandle('gate')
def enter_scene_remote(dynamic_id, character_id):
    """进入场景"""
    is_new_character = 1
    player = PlayersManager().get_player_by_id(character_id)
    if not player:
        player = PlayerCharacter(character_id, dynamic_id=dynamic_id)
        is_new_character = init_player(player)
        PlayersManager().add_player(player)

    responsedata = GameLoginResponse()
    responsedata.res.result = True
    responsedata.id = player.base_info.id
    responsedata.nickname = player.base_info.base_name

    responsedata.level = player.base_info.level
    responsedata.exp = player.base_info.exp

    for i in player.finance._finances:
        responsedata.finances.append(i)

    responsedata.fine_hero = player.last_pick_time.fine_hero
    responsedata.excellent_hero = player.last_pick_time.excellent_hero
    responsedata.fine_equipment = player.last_pick_time.fine_equipment
    responsedata.excellent_equipment = player.last_pick_time.excellent_equipment

    responsedata.pvp_times = player.base_info.pvp_times
    responsedata.pvp_refresh_count = player.base_info.pvp_refresh_count

    responsedata.combat_power = player.line_up_component.combat_power
    responsedata.newbee_guide_id = player.base_info.newbee_guide_id

    if player.guild.g_id != 'no':
        responsedata.guild_id = player.guild.g_id

    responsedata.vip_level = player.base_info.vip_level
    # 体力
    responsedata.get_stamina_times = player.stamina.get_stamina_times
    responsedata.buy_stamina_times = player.stamina.buy_stamina_times
    responsedata.last_gain_stamina_time = player.stamina.last_gain_stamina_time
    responsedata.server_time = int(time.time())
    # responsedata.soul_shop_refresh_times = player.soul_shop.refresh_times
    if player.base_info.heads.head:
        for head in player.base_info.heads.head:
            responsedata.head.append(head)
    responsedata.now_head = player.base_info.heads.now_head

    logger.debug("character info:----------------------")
    logger.debug("vip_level:%d", player.base_info.vip_level)
    # logger.debug("stamina:%d", player.stamina.stamina)
    # logger.debug("coin:%d", player.finance.coin)
    # logger.debug("gold:%d", player.finance.gold)
    # logger.debug("hero_soul:%d", player.finance.hero_soul)
    # logger.debug("soul_shop_refresh_times:%d", player.soul_shop.refresh_times)

    return {'player_data': responsedata.SerializeToString(), 'is_new_character': is_new_character}
