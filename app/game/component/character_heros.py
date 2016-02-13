# -*- coding:utf-8 -*-
"""
created by server on 14-6-25下午7:00.
"""
from app.game.component.Component import Component
from app.game.core.hero import Hero
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data import game_configs
from app.game.core.task import hook_task, CONDITIONId


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

    def init_data(self, c):
        pid = self.owner.base_info.id
        char_obj = tb_character_info.getObj(pid).getObj('heroes')
        heros = char_obj.hgetall()
        for hid, data in heros.items():
            hero = Hero(pid)
            hero.init_data(data)
            self._heros[hero.hero_no] = hero

    def save_data(self):
        pass

    def new_data(self):
        return {}

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
        self.save_hero_to_line_up(hero_no)

        hero_conf = game_configs.hero_config.get(hero_no)

        if hero_conf.color == 3:
            if not (hero_no in self.owner.base_info.heads.head):
                self.owner.base_info.heads.head.append(hero_no)
            self.owner.base_info.save_data()

        cid = 0
        color = hero_conf.color
        color_num = 0
        star6_num = 0
        if hero_conf.color == 1:
            cid = CONDITIONId.GREEN_HERO
        elif hero_conf.color == 2:
            cid = CONDITIONId.BLUE_HERO
        elif hero_conf.color == 3:
            cid = CONDITIONId.PURPLE_HERO
        for hero_no, hero_obj in self._heros.items():
            h_conf = game_configs.hero_config.get(hero_no)
            if h_conf.color == color:
                color_num += 1
            if h_conf.quality == 6:
                star6_num += 1
        if cid and color_num:
            hook_task(self.owner, cid, color_num)
        if star6_num:
            hook_task(self.owner, CONDITIONId.STAR6_HERO, star6_num)

        return hero

    def add_hero_without_save(self, hero_no):
        hero = Hero(self.owner.base_info.id)
        hero.hero_no = hero_no
        self._heros[hero_no] = hero
        self.save_hero_to_line_up(hero_no)
        return hero

    def save_hero_to_line_up(self, hero_no):
        """
        点亮武将
        """
        _ever_have_heros = self._owner.line_up_component._ever_have_heros
        if hero_no not in _ever_have_heros:
            _ever_have_heros.append(hero_no)
            self._owner.line_up_component.save_data(["ever_have_heros"])

    def delete_hero(self, hero_no):
        if self._heros.get(hero_no):
            hero = self._heros[hero_no]
            hero.delete()
            del self._heros[hero_no]
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
        pid = self.owner.character_id
        hero_property = hero.hero_proerty_dict()
        char_obj = tb_character_info.getObj(pid).getObj('heroes')
        result = char_obj.hsetnx(hero_property['hero_no'], hero_property)
        if not result:
            logger.error('new hero error!:%s', hero_property['hero_no'])

    def is_guard(self, hero_no):
        """
        是否在驻守中, 秘境相关
        """
        hero = self._heros.get(hero_no)
        assert hero is not None, ("hero %s not exists!" % hero_no)
        return hero.is_guard

    def get_quality_hero_count(self, quality):
        """
        :param quality: 品质类型
        :return: 返回指定品质武将数量
        """
        count = 0
        for hero_id in self._heros:
            hero = game_configs.hero_config[hero_id]
            if hero.quality >= quality:
                count += 1
        return count
