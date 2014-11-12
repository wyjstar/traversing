# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_travel
from shared.db_opear.configs_data import game_configs
import time
from gfirefly.server.logobj import logger


class CharacterTravelComponent(Component):
    """玩家游历组建
    """

    def __init__(self, owner):
        super(CharacterTravelComponent, self).__init__(owner)
        self._chapters = {}  # 游历章节
        self._shoes = 0  # 剩余鞋子
        self._chest_time = 1  # 上次领取宝箱时间

    def init_data(self):
        travel_data = tb_character_travel.getObjData(self.owner.base_info.id)
        if travel_data:
            self._chapters = travel_data.get('chapters')
            self._shoes = travel_data.get('shoes')
            self._chest_time = travel_data.get('chest_time')
        else:
            tb_character_travel.new({'id': self.owner.base_info.id,
                                     'chapters': {},
                                     'shoes': 0,
                                     'chest_time': 1})

    def save(self):
        data_obj = tb_character_travel.getObj(self.owner.base_info.id)
        data_obj.update({'chapters': self._chapters,
                        'shoes': self._shoes,
                        'chest_time': self._chest_time})



