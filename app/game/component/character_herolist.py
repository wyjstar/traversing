# -*- coding:utf-8 -*-
"""
created by server on 14-6-25下午7:00.
"""
from app.game.component.Component import Component
from app.game.core.hero import Hero
from app.game.redis_mode import tb_character_hero, tb_character_heros
from gtwisted.utils import log
import cPickle


class CharacterHeroListComponent(Component):
    """武将列表类"""

    def __init__(self, owner):
        super(CharacterHeroListComponent, self).__init__(owner)
        self._heros = {}

    def init_hero_list(self, pid):
        character_heros = tb_character_heros.getObjData(pid)
        if not character_heros:
            "没有武将列表数据"
            data = {
                'id': pid,
                'hero_ids': cPickle.dumps([]),
            }
            tb_character_heros.new(data)
            return
        str_hero_ids = character_heros.get('hero_ids')
        hero_ids = cPickle.loads(str_hero_ids)
        heros = tb_character_hero.getObjList(hero_ids)

        for hero_mmode in heros:
            hero = Hero(hero_mmode)
            hero.init_data()
            self.add_hero(hero)

    def get_hero_by_no(self, hero_no):
        return self._heros.get(hero_no)

    def get_heros(self):
        return self._heros.values()

    def get_heros_by_nos(self, hero_no_list):
        heros = []
        for no in hero_no_list:
            heros.append(self._heros.get(no))
        return heros

    def add_hero(self, hero):
        self._heros[hero.hero_no] = hero
        mmode = self.new_hero_data(hero)
        hero.mmode = mmode
        self.save_data()

    def remove_hero(self, hero_no):
        del self._heros[hero_no]
        self.delete_data(hero_no)

    def remove_heros_by_nos(self, hero_no_list):
        for no in hero_no_list:
            self.remove_hero(no)

    def contain_hero(self, hero_no):
        return hero_no in self._heros

    def save_data(self):
        hero_ids = []
        character_id = self.owner.base_info.id
        for hero_no in self._heros:
            hero_ids.append(str(character_id)+'_'+str(hero_no))

        character_heros = tb_character_heros.getObjData(character_id)
        character_heros.update('hero_ids', hero_ids)

    def get_hero_id(self, hero_no):
        character_id = self.owner.base_info.id
        return str(character_id)+'_'+str(hero_no)

    def new_hero_data(self, hero):
        character_id = self.owner.base_info.id
        hero_property = {
            'hero_no': hero.hero_no,
            'level': hero.level,
            'exp': hero.exp,
            'break_level': hero.break_level,
            'equipment_ids': cPickle.dumps(hero.equipment_ids)
        }

        data = {
            'id': self.get_hero_id(hero.hero_no),
            'character_id': character_id,
            'property': hero_property
        }
        return tb_character_hero.new(data)

    def delete_data(self, hero_no):
        tb_character_hero.deleteMode(self.get_hero_id(hero_no))






