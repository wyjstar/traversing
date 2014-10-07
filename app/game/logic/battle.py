# -*- coding:utf-8 -*-
"""
created by server on 14-9-15上午11:32.
"""
from app.game.logic.common.check import have_player
from app.proto_file.battle_round_pb2 import Round

@have_player
def get_round(dynamic_id, **kwargs):
    player = kwargs.get('player')
#     requ = Round()
#     for hero in player.hero_component.get_heros():
#         hero_pb = response.heros.add()
#         hero.update_pb(hero_pb)
#     return response.SerializePartialToString()