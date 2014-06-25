# -*- coding: utf-8 -*-
"""
created by wzp on 14-6-19下午7: 51.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.game.core.character.PlayerCharacter import PlayerCharacter
from app.game.core.PlayersManager import PlayersManager


@remote_service_handle
def enter_scene_601(dynamic_id, character_id):
    """进入场景"""


    player = PlayerCharacter(character_id, dynamic_id=dynamic_id)

    # PlayersManager().addPlayer(player)
    # playerinfo = player.formatInfo()
    # responsedata = {'result': True, 'message': '',
    #                 'data': {'cid': playerinfo['id'],
    #                         'name': playerinfo['nickname'],
    #                         'level': playerinfo['level'],
    #                         'exp': playerinfo['exp'],
    #                         'maxexp': playerinfo['maxExp'],
    #                         'coin': playerinfo['coin'],
    #                         'yuanbao': playerinfo['gold'],
    #                         'power': playerinfo['maxHp'],
    #                         'gas': playerinfo['energy'],
    #                         'profession': playerinfo['profession']}
    #                 }
    # return responsedata
    # return "I get to enter scene"