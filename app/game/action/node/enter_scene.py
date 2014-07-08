# -*- coding: utf-8 -*-
"""
created by wzp on 14-6-19下午7: 51.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.game.core.character.PlayerCharacter import PlayerCharacter
from app.game.core.PlayersManager import PlayersManager
from app.proto_file.player_response_pb2 import PlayerResponse



@remote_service_handle
def enter_scene_601(dynamic_id, character_id):
    """进入场景"""
    player = PlayerCharacter(character_id, dynamic_id=dynamic_id)

    PlayersManager().add_player(player)

    responsedata = PlayerResponse()
    for hero in player.hero_component.get_heros():
        hero_pb = responsedata.hero_list.add()
        hero_pb.hero_no = hero.hero_no
        hero_pb.level = hero.level
        hero_pb.break_level = hero.break_level
        hero_pb.hero_no = hero.hero_no
        hero_pb.exp = hero.exp
    responsedata.id = player.base_info.id
    responsedata.nickname = player.base_info.base_name
    return responsedata.SerializeToString()
