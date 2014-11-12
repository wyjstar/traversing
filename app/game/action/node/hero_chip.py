# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午4:07.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file.hero_chip_pb2 import GetHeroChipsResponse


@remoteserviceHandle('gate')
def get_hero_chips_108(pro_data, player):
    """取得武将碎片列表 """
    response = GetHeroChipsResponse()
    for hero_chip in player.hero_chip_component.get_all():
        hero_chip_pb = response.hero_chips.add()
        hero_chip.update_pb(hero_chip_pb)
    return response.SerializePartialToString()
