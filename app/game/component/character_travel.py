# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from shared.db_opear.configs_data import game_configs
from shared.db_opear.configs_data.common_item import CommonItem
import time


class CharacterTravelComponent(Component):
    """玩家游历组建
    """

    def __init__(self, owner):
        super(CharacterTravelComponent, self).__init__(owner)
        self._travel = {}  # 游历章节缓存 {stage_id:[[event_id, drop, time]]}
        self._travel_item = {}  # 获得的风物志 {stage_id:[travel_item_id]}
        self._chest_time = 1  # 上次领取宝箱时间
        self._fight_cache = [0, 0]  # [stage_id, event_id]

        # {stage_id:[{start_tiem:0, continued_time:0,
        # 'events': [[state, event_id, drop, start_time]], already_times: 0}]}
        self._auto = {}

    def init_data(self, character_info):
        self._travel = character_info.get('travel')
        self._travel_item = character_info.get('travel_item')
        self._chest_time = character_info.get('chest_time')
        self._fight_cache = character_info.get('fight_cache')
        self._auto = character_info.get('auto')
        for travel_stage_id in game_configs.stage_config.get('travel_stages'):
            if not self._travel_item.get(travel_stage_id):
                self._travel_item[travel_stage_id] = []

    def save(self):
        data_obj = tb_character_info.getObj(self.owner.base_info.id)
        data_obj.hmset({'travel': self._travel,
                        'travel_item': self._travel_item,
                        'chest_time': self._chest_time,
                        'auto': self._auto,
                        'fight_cache': self._fight_cache})

    def new_data(self):
        for travel_stage_id in game_configs.stage_config.get('travel_stages'):
            self._travel_item[travel_stage_id] = []
        return {'travel': self._travel,
                'travel_item': self._travel_item,
                'chest_time': self._chest_time,
                'auto': self._auto,
                'fight_cache': self._fight_cache}

    def get_travel_item_groups(self):
        groups = []
        my_travel_items = []
        for stage_id, stage_items in self._travel_item.items():
            for [stage_item_id, stage_item_info] in stage_items:
                my_travel_items.append(stage_item_id)

        for (group_id, group_info) in game_configs.travel_item_config.get('groups').items():
            t_group = set(group_info)
            if t_group.issubset(set(my_travel_items)):
                groups.append(group_id)
        return groups

    def get_travel_item_attr(self):
        hp = 0
        atk = 0
        physical_def = 0
        magic_def = 0
        for group_id in self.get_travel_item_groups():
            conf = game_configs.travel_item_group_config.get(group_id)
            hp += conf.hp
            atk += conf.atk
            physical_def += conf.physicalDef
            magic_def += conf.magicDef

        return CommonItem(dict(hp=hp, atk=atk, physical_def=physical_def,
                               magic_def=magic_def))

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
        self._chest_time = value

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

    @property
    def auto(self):
        return self._auto

    @auto.setter
    def auto(self, value):
        self._auto = value

    def update_travel_item(self, response):
        """docstring for update_travel_item"""
        for (stage_id, item) in self.travel_item.items():
            travel_item_chapter = response.travel_item_chapter.add()
            travel_item_chapter.stage_id = stage_id
            for [travel_item_id, num] in item:
                travel_item = travel_item_chapter.travel_item.add()
                travel_item.id = travel_item_id
                travel_item.num = num
