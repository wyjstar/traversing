# -*- coding:utf-8 -*-
"""
created by server on 14-6-25下午7:00.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_hero
from app.game.core.hero import Hero


class HeroListComponent(Component):
    """武将信息类"""

    def __init__(self, owner, characterid):
        super(HeroListComponent, self).__init__(owner)
        self._heros = {}

    def init(self, characterid):
        hero_id_list = tb_hero.getAllPkByFk(self._owner.base_info.id)
        hero_objcet_list = tb_hero.getObjList(hero_id_list)
        for hero_mode in hero_objcet_list:
            hero_id = hero_mode.getid()
            hero = Hero(hero_id, )


    def get_hero_byid(self, hero_id):
        return self._heros.get(hero_id)

    def get_heros(self):
        return self._heros.values()


