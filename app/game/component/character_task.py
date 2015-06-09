# -*- coding:utf-8 -*-
"""
created by cui.
"""
from shared.db_opear.configs_data import game_configs
import time
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info


class CharacterTaskComponent(Component):
    def __init__(self, owner):
        super(CharacterTaskComponent, self).__init__(owner)
        self._conditions = {}  # 永久条件进度{条件ID:{}}
        self._conditions_day = {}  # 每日条件进度{条件ID:参数}
        self._tasks = {}  # 所有任务 {id:state} 1 未完成2完成未领取3已领取
        self._lively = 0  # 活跃度
        self._last_day = 1  # 最后刷新时间

    def init_data(self, character_info):
        self._conditions = character_info.get('conditions1')
        self._conditions_day = character_info.get('conditions_day1')
        self._tasks = character_info.get('tasks1')
        self._lively = character_info.get('lively1')
        self._last_day = character_info.get('last_day1')

    def save_data(self):
        data_obj = tb_character_info.getObj(self.owner.base_info.id)
        data_obj.hmset({'conditions1': self._conditions,
                        'conditions_day1': self._conditions_day,
                        'tasks1': self._tasks,
                        'lively': self._lively,
                        'last_day': self._last_day})

    def new_data(self):
        return {'conditions1': self._conditions,
                'conditions_day1': self._conditions_day,
                'tasks1': self._tasks,
                'lively1': self._lively,
                'last_day1': self._last_day}

    def update(self):
        if time.localtime(self._last_day).tm_yday == time.localtime().tm_yday:
            return
        for task_id, state in self._tasks.items():
            task_conf = game_configs.achievement_config. \
                get('tasks').get(task_id)
            if task_conf.type == 2:  # 日常类
                self._tasks[task_id] = 1
        # 每日刷新类型的  修改状态
        self._conditions_day = {}
        self._lively = 0
        self._last_day = int(time.time())

    @property
    def conditions(self):
        return self._conditions

    @conditions.setter
    def conditions(self, v):
        self._conditions = v

    @property
    def conditions_day(self):
        return self._conditions_day

    @conditions_day.setter
    def conditions_day(self, v):
        self._conditions_day = v

    @property
    def tasks(self):
        return self._tasks

    @tasks.setter
    def tasks(self, v):
        self._tasks = v

    @property
    def lively(self):
        return self._lively

    @lively.setter
    def lively(self, v):
        self._lively = v

    @property
    def last_day(self):
        return self._last_day

    @last_day.setter
    def last_day(self, v):
        self._last_day = v
