# -*- coding: utf-8 -*-
"""
created by wzp on 14-6-19下午7: 51.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.game.core.character.PlayerCharacter import PlayerCharacter
from app.game.core.PlayersManager import PlayersManager
from app.proto_file.game_pb2 import GameLoginResponse
from test.init_data.init_data import init
import time


@remote_service_handle
def enter_scene_601(dynamic_id, character_id, is_new_character):
    """进入场景"""
    player = PlayerCharacter(character_id, dynamic_id=dynamic_id)
    PlayersManager().add_player(player)
    # player = mock_player(player)
    if is_new_character:
        print ("mock player info.....", is_new_character)
        init(player)

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
    responsedata.stamina = player.stamina
    responsedata.pvp_times = player.pvp_times
    # TODO vip_level
    responsedata.vip_level = 1
    responsedata.server_time = int(time.time())

    return responsedata.SerializeToString()


def mock_player(player):
    if player.base_info.id != 1:
        PlayersManager().drop_player(player)

    player1 = PlayersManager().get_player_by_id(1)
    player1.dynamic_id = player.dynamic_id
    player1.base_info.base_name = player.base_info.base_name
    return player1
