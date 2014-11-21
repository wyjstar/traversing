# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_travel
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger


class CharacterTravelComponent(Component):
    """玩家游历组建
    """

    def __init__(self, owner):
        super(CharacterTravelComponent, self).__init__(owner)
        self._travel = {}  # 游历章节缓存
        self._travel_item = {}  # 获得的风物志
        self._shoes = [0, 0, 0, 0, 0]  # 剩余鞋子[1,2,3,正在消耗，已消耗个数]
        self._chest_time = 1  # 上次领取宝箱时间
        self._fight_cache = [0, 0]
        for travel_stage_id in game_configs.stage_config.get('travel_stages'):
            self._travel_item[travel_stage_id] = []

    def init_data(self):
        travel_data = tb_character_travel.getObjData(self.owner.base_info.id)
        if travel_data:
            self._travel = travel_data.get('travel')
            self._travel_item = travel_data.get('travel_item')
            self._shoes = travel_data.get('shoes')
            self._chest_time = travel_data.get('chest_time')
            self._fight_cache = travel_data.get('fight_cache')
        else:
            for travel_stage_id in game_configs.stage_config.get('travel_stages'):
                self._travel_item[travel_stage_id] = []
            tb_character_travel.new({'id': self.owner.base_info.id,
                                     'travel': self._travel,
                                     'travel_item': self._travel_item,
                                     'shoes': self._shoes,
                                     'chest_time': self._chest_time,
                                     'fight_cache': self._fight_cache})

    def save(self):
        data_obj = tb_character_travel.getObj(self.owner.base_info.id)
        data_obj.update({'travel': self._travel,
                         'travel_item': self._travel_item,
                         'shoes': self._shoes,
                         'chest_time': self._chest_time,
                         'fight_cache': self._fight_cache})

    @property
    def shoes(self):
        return self._shoes

    @shoes.setter
    def shoes(self, shoes):
        self._shoes = shoes

    @property
    def travel(self):
        return self._travel

    @travel.setter
    def travel(self, travel):
        self._travel = travel

    @property
    def chest_time(self):
        return self._chest_time

    @chest_time.setter
    def chest_time(self, value):
        self._travel = value

    @property
    def travel_item(self):
        return self._travel_item

    @travel_item.setter
    def travel_item(self, value):
        self._travel_item = value

    @property
    def fight_cache(self):
        return self._fight_cache

    @fight_cache.setter
    def fight_cache(self, value):
        self._fight_cache = value
