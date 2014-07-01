# -*- coding:utf-8 -*-
"""
created by server on 14-6-25下午7:00.
"""
from app.game.component.Component import Component
from app.game.core.hero import Hero
from app.game.redis_mode import tb_char_hero


class CharacterHeroListComponent(Component):
    """武将列表类"""

    def __init__(self, owner):
        super(CharacterHeroListComponent, self).__init__(owner)
        self._heros = {}

    def init_hero_list(self, pid):
        hero_id_list = tb_char_hero.getAllPkByFk(pid)
        hero_list = tb_char_hero.getObjList(hero_id_list)

        for hero_data in hero_list:
            hero = Hero(hero_data)
            self.add_hero(hero)


    def get_hero_by_no(self, hero_no):
        return self._heros.get(hero_no)

    def get_heros(self):
        return self._heros.values()

    def add_hero(self, hero):
        self._heros[hero.hero_no] = hero

    def contain_hero(self, hero_no):
        return hero_no in self._heros




