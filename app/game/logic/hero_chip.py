# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午4:08.
"""
from app.proto_file.hero_chip_pb2 import GetHeroChipsResponse
from app.game.logic.common.check import have_player


@have_player
def get_hero_chips(dynamic_id, **kwargs):
    player = kwargs.get('player')
    print 'test'
    response = GetHeroChipsResponse()
    for hero_chip in player.hero_chip_component.get_all():
        hero_chip_pb = response.hero_chips.add()
        hero_chip.update_pb(hero_chip_pb)
    return response.SerializePartialToString()