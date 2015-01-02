# -*- coding:utf-8 -*-
"""
created by server on 14-6-25下午7:00.
"""
from app.game.component.Component import Component
from app.game.core.hero import Hero
from app.game.redis_mode import tb_character_hero
from gfirefly.server.logobj import logger


class CharacterHerosComponent(Component):
    """武将列表类"""

    def __init__(self, owner):
        super(CharacterHerosComponent, self).__init__(owner)
        self._heros = {}

    @property
    def heros(self):
        return self._heros

    @heros.setter
    def heros(self, heros):
        self._heros = heros

    def init_heros(self):
        pid = self.owner.base_info.id
        heros = tb_character_hero.getObjListByFk(pid)

        for hero_mmode in heros:
            data = hero_mmode.get('data')
            hero = Hero(pid)
            hero.init_data(data)
            self._heros[hero.hero_no] = hero

    def get_hero(self, hero_no):
        return self._heros.get(hero_no)

    def get_multi_hero(self, *args):
        return [self.get_hero(hero_no) for hero_no in args]

    def get_heros(self):
        return self._heros.values()

    def get_heros_by_nos(self, hero_no_list):
        heros = []
        for no in hero_no_list:
            hero = self._heros.get(no)
            if hero:
                heros.append(hero)
        return heros

    def add_hero(self, hero_no):
        hero = Hero(self.owner.base_info.id)
        hero.hero_no = hero_no
        self._heros[hero_no] = hero
        self.new_hero_data(hero)
        return hero

    def add_hero_without_save(self, hero_no):
        hero = Hero(self.owner.base_info.id)
        hero.hero_no = hero_no
        self._heros[hero_no] = hero
        return hero

    def delete_hero(self, hero_no):
        if self._heros.get(hero_no):
            del self._heros[hero_no]
            tb_character_hero.deleteMode(self.get_hero_id(hero_no))
        else:
            logger.debug("don't find hero_no from self._heros")

    def delete_heros_by_nos(self, hero_no_list):
        for no in hero_no_list:
            self.delete_hero(no)

    def contain_hero(self, hero_no):
        return hero_no in self._heros

    def get_hero_id(self, hero_no):
        character_id = self.owner.base_info.id
        return str(character_id)+'_'+str(hero_no)

    def new_hero_data(self, hero):
        character_id = self.owner.base_info.id
        hero_property = hero.hero_proerty_dict()
        hero_id = self.get_hero_id(hero.hero_no)
        hero = tb_character_hero.getObj(hero_id)
        if hero:
            logger.error("error:hero no %s has existed!" % hero_id)
            return
        data = {
            'id': hero_id,
            'character_id': character_id,
            'property': hero_property
        }
        tb_character_hero.new(data)

    def is_guard(self, hero_no):
        """
        是否在驻守中, 秘境相关
        """
        hero = self._heros.get(hero_no)
        assert hero!=None, ("hero %s not exists!" % hero_no)
        return hero.is_guard

