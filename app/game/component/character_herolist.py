# -*- coding:utf-8 -*-
"""
created by server on 14-6-25下午7:00.
"""
from app.game.component.Component import Component
from app.game.core.hero import Hero
from app.game.redis_mode import tb_character_hero, tb_character_info
from gtwisted.utils import log


class CharacterHeroListComponent(Component):
    """武将列表类"""

    def __init__(self, owner):
        super(CharacterHeroListComponent, self).__init__(owner)
        self._heros = {}

    def init_hero_list(self, pid):
        character = tb_character_info.getObjData(pid)
        if not character:
            log.err('玩家角色为空！')
        hero_list_ids = character.get('hero_list', '').split(',')
        hero_list = tb_character_hero.getObjList(hero_list_ids)

        for hero_mmode in hero_list:
            hero = Hero(hero_mmode)
            hero.init_data()
            self.add_hero(hero)

    def get_hero_by_no(self, hero_no):
        return self._heros.get(hero_no)

    def get_heros(self):
        return self._heros.values()

    def add_hero(self, hero):
        self._heros[hero.hero_no] = hero

    def remove_hero(self, hero_id):
        del self._heros[hero_id]

    def contain_hero(self, hero_no):
        return hero_no in self._heros




