# -*- coding:utf-8 -*-
"""
created by server on 14-6-25下午7:00.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
#from gfirefly.server.logobj import logger
from shared.db_opear.configs_data import game_configs
from shared.utils.date_util import str_time_to_timestamp, get_current_timestamp
from shared.utils.random_pick import random_multi_pick
from shared.utils.pyuuid import get_uuid


class CharacterEscortComponent(Component):
    """粮草押运组件"""

    def __init__(self, owner):
        super(CharacterEscortComponent, self).__init__(owner)
        self._tasks = {}          # 押运任务列表
        self._protect_records = {}     # 我的押运记录
        self._rob_records = {}         # 我的劫运记录
        self._can_rob_tasks = {}       # 可劫运的任务
        self._start_protect_times = 0; # 开始押运次数
        self._protect_times = 0;       # 保护押运次数
        self._rob_times = 0;           # 参与劫运次数
        self._refresh_times = 0;       # 刷新押运列表
        self._refresh_task_time = 0;   # 刷新押运任务列表时间
        self._last_reset_time = 0;     # 重置次数

    def init_data(self, character_info):
        data = character_info.get('escort_task')
        self._tasks = data.get("tasks")
        self._protect_records = data.get("protect_records")
        self._rob_records = data.get("rob_records")
        self._can_rob_tasks = data.get("can_rob_tasks")
        self._start_protect_times = data.get("start_protect_times")
        self._protect_times = data.get("protect_times")
        self._rob_times = data.get("rob_times")
        self._refresh_times = data.get("refresh_times")
        self._refresh_task_time = data.get("refresh_task_time")
        self._last_reset_time = data.get("last_reset_time")
        self.check_time()

    def save_data(self):
        character_info = tb_character_info.getObj(self.owner.base_info.id)
        character_info.hmset({"escort_task": self.property_dict()})

    def new_data(self):
        return {'escort_task': self.property_dict()}

    def property_dict(self):
        data = {}
        data['tasks'] = self._tasks
        data['protect_records'] = self._protect_records
        data['rob_records'] = self._rob_records
        data['can_rob_tasks'] = self._can_rob_tasks
        data['start_protect_times'] = self._start_protect_times
        data['protect_times'] = self._protect_times
        data['rob_times'] = self._rob_times
        data['refresh_times'] = self._refresh_times
        data['refresh_task_time'] = self._refresh_task_time
        data['last_reset_time'] = self._last_reset_time
        return data

    @property
    def tasks(self):
        if not len(self._tasks):
            self.check_time()
        return self._tasks

    @tasks.setter
    def tasks(self, value):
        self._tasks = value

    @property
    def protect_records(self):
        return self._protect_records

    @protect_records.setter
    def protect_records(self, value):
        self._protect_records = value

    @property
    def rob_records(self):
        return self._rob_records

    @rob_records.setter
    def rob_records(self, value):
        self._rob_records = value

    @property
    def can_rob_tasks(self):
        return self._can_rob_tasks

    @can_rob_tasks.setter
    def can_rob_tasks(self, value):
        self._can_rob_tasks = value

    @property
    def start_protect_times(self):
        return self._start_protect_times

    @start_protect_times.setter
    def start_protect_times(self, value):
        self._start_protect_times = value

    @property
    def protect_times(self):
        return self._protect_times

    @protect_times.setter
    def protect_times(self, value):
        self._protect_times = value

    @property
    def rob_times(self):
        return self._rob_times

    @rob_times.setter
    def rob_times(self, value):
        self._rob_times = value

    @property
    def refresh_times(self):
        return self._refresh_times

    @refresh_times.setter
    def refresh_times(self, value):
        self._refresh_times = value

    @property
    def refresh_task_time(self):
        return self._refresh_task_time

    @refresh_task_time.setter
    def refresh_task_time(self, value):
        self._refresh_task_time = value


    def check_time(self):
        escort_refresh = game_configs.base_config.get("EscortFresh")
        escort_refresh = str_time_to_timestamp(escort_refresh)
        if self._refresh_task_time < escort_refresh:
            self.refresh_tasks()
            self._refresh_task_time = int(get_current_timestamp())
            self._start_protect_times = 0
            self._refresh_times = 0
            self._protect_times = 0
            self._rob_times = 0
            self.save_data()

    def refresh_tasks(self):
        """刷新押运列表"""
        items = {}
        self._tasks = {}
        for _, item in game_configs.guild_task_config.items():
            items[item.id] = item.weights

        task_num = game_configs.base_config.get('EscortTaskShowQuantity')
        task_nos = random_multi_pick(items, task_num)
        for task_no in task_nos:
            task = {}
            task_id = get_uuid()
            task["task_id"] = task_id
            task["task_no"] = task_no
            task["state"] = 0
            self._tasks[task_id] = task

    def reset(self):
        """docstring for reset"""
        self._tasks = {}          # 押运任务列表
        self._protect_records = {}     # 我的押运记录
        self._rob_records = {}         # 我的劫运记录
        self._can_rob_tasks = {}       # 可劫运的任务
        self._start_protect_times = 0; # 开始押运次数
        self._protect_times = 0;       # 保护押运次数
        self._rob_times = 0;           # 参与劫运次数
        self._refresh_times = 0;       # 刷新押运列表
        self._refresh_task_time = 0;   # 刷新押运任务列表时间
        self._last_reset_time = 0;     # 重置次数
