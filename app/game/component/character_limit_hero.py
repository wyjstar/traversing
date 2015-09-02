# -*- coding:utf-8 -*-
"""
created by server on 14-7-24下午6:32.
"""
from app.game.component.Component import Component
from shared.db_opear.configs_data import game_configs
from app.game.redis_mode import tb_character_info


class CharacterLimitHeroComponent(Component):
    """
    限时神将
    """

    def __init__(self, owner):
        super(CharacterLimitHeroComponent, self).__init__(owner)
        self._free_time = 1  # 最后免费抽取时间
        self._draw_times = 0  # 累计抽取次数
        self._integral_draw_times = 0  # 积分抽取次数
        self._activity_id = 0  # 活动ID

    def init_data(self, character_info):
        """
        初始化公会组件
        """
        self._free_time = character_info.get("free_time")
        self._draw_times = character_info.get("draw_times")
        self._integral_draw_times = \
            character_info.get("integral_draw_times")
        self._activity_id = character_info.get("activity_id")

    def save_data(self):
        data_obj = tb_character_info.getObj(self.owner.base_info.id)
        data_obj.hmset({'free_time': self._free_time,
                        'draw_times': self._draw_times,
                        'integral_draw_times': self._integral_draw_times,
                        'activity_id': self._activity_id})

    def new_data(self):
        data = {'free_time': self._free_time,
                'draw_times': self._draw_times,
                'integral_draw_times': self._integral_draw_times,
                'activity_id': self._activity_id}
        return data

    def update(self, activity_id):
        if self.activity_id == activity_id:
            return
        self._free_time = 1  # 最后免费抽取时间
        self._draw_times = 0  # 累计抽取次数
        self._integral_draw_times = 0  # 积分抽取次数
        self._activity_id = activity_id  # 活动ID

    @property
    def integral_draw_times(self):
        return self._integral_draw_times

    @integral_draw_times.setter
    def integral_draw_times(self, v):
        self._integral_draw_times = v

    @property
    def free_time(self):
        return self._free_time

    @free_time.setter
    def free_time(self, v):
        self._free_time = v

    @property
    def draw_times(self):
        return self._draw_times

    @draw_times.setter
    def draw_times(self, v):
        self._draw_times = v

    @property
    def activity_id(self):
        return self._activity_id

    @activity_id.setter
    def activity_id(self, v):
        self._activity_id = v
