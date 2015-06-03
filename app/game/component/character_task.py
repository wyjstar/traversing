# -*- coding:utf-8 -*-
"""
created by cui.
"""
from shared.db_opear.configs_data import game_configs
import time
from app.game.component.Component import Component


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

    def task_status(self, tid, response):
        unlock_conf = game_configs.achievement_config.get('unlock')
        task_res = response.tasks.add()
        task_res.tid = tid
        while True:
            task_conf = game_configs.achievement_config.get('tasks').get(t_id)
            state = self._tasks.get(tid)
            next_task = unlock_conf.get(tid)
            # TODO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if next_task and state and state == 3:  # 有后续，已领取
                tid = next_task
                continue
            else:
                if not next_task and state and state == 2:  # 无后续，已完成未领取
                    task_res.state = 2
                    break
                elif not next_task and state and state == 3:  # 无后续，已领取
                    task_res.state = 3
                    break
                # 无后续 或 无任务记录 或 未完成
                res = get_condition_info(task_conf)
                if res.get('state'):
                    self._tasks[tid] = 2
                    task_res.state = 2
                    break
                else:
                    condition_info = res.get('condition_info')
                    task_res.state = res.get('state')
                    condition_res = task_res.condition.add()
                    for x in condition_info:
                        condition_res.condition_no = x[0]
                        condition_res.state = x[1]
                        condition_res.current = x[2]
                    break

    def get_condition_info(self, task_conf):
        composition = task_conf.composition
        condition_info = []  # [[no, state, value]]
        task_type = task_conf.type
        for condition_no, condition_conf in task_conf.condition.items():
            # condition_conf [condition_id, v, v]
            condition_id = condition_conf[0]
            state = 0

            if condition_id == 1:
                if self.owner.stage_component. \
                        get_stage(condition_conf[1]).state == 1:
                    state = 1
            elif condition_id == 24:  # 活跃度
                value = self._lively
            else:
                if task_type == 1:  # 单次
                    value = 0
                    if self._conditions.get(condition_id):
                        value = self._conditions.get(condition_id)
                else:  # 2 每日
                    value = 0
                    if self._conditions_day.get(condition_id):
                        value = self._conditions.get(condition_id)
                if value >= condition_conf[1]:
                    state = 1
            condition_info.append([condition_no, state, value])
        if composition == 1:  # 且
            state = 1
            for x in condition_info:
                if x[1]:
                    continue
                state = 0
                break
        else:
            state = 0
            for x in condition_info:
                if not x[1]:
                    continue
                state = 1
                break
        return {'state': state, 'condition_info': condition_info}

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
