# -*- coding:utf-8 -*-
"""
@author: cui
"""
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
import random
import time
from gfirefly.dbentrust.redis_mode import RedisObject

tb_guild_info = RedisObject('tb_guild_info')
from shared.common_logic.escort_task import EscortTask


class Guild(object):
    """公会
    """
    def __init__(self):
        """
        """
        self._name = 0  # 名
        self._g_id = 0  # id
        self._contribution = 99999999  # 当前建设值
        self._all_contribution = 99999999  # 总建设值
        self._call = ''  # 公告
        self._p_list = {}  # 成员信息
        self._apply = []  # 加入申请
        self._invite_join = {}  # {id:time, id:time} 邀请加入
        self._icon_id = 0  # 军团头像
        self._bless = [0, 0, 1]  # 祈福人数,福运,时间
        self._praise = [0, 0, 1]  # 点赞次数，累计金钱，时间
        self._build = {}  # 建筑等级 {建筑类型：建筑等级}
        self._escort_tasks = {}                # 粮草押运任务
        self._escort_tasks_can_rob = []        # 粮草押运任务中可被抢夺的任务
        self._escort_tasks_invite_protect = {} # 粮草押运任务邀请
        self._escort_tasks_invite_rob = {}     # 粮草押运任务邀请

    @property
    def info(self):
        data = self._info
        data['p_num'] = self.get_p_num()
        return data

    @property
    def _info(self):
        data = {'id': self._g_id,
                'name': self._name,
                'contribution': self._contribution,
                'all_contribution': self._all_contribution,
                'icon_id': self._icon_id,
                'bless': self._bless,
                'praise': self._praise,
                'call': self._call,
                'invite_join': self._invite_join,
                'p_list': self._p_list,
                'build': self.build,
                'apply': self._apply,
                'escort_tasks': self._escort_tasks,
                'escort_tasks_invite_protect': self._escort_tasks_invite_protect,
                'escort_tasks_invite_rob': self._escort_tasks_invite_rob,
                }
        return data

    def create_guild(self, p_id, name, icon_id):
        g_id = tb_guild_info.getObj('incr').incr()

        self._name = name
        self._g_id = g_id
        self._icon_id = icon_id
        self._p_list = {1: [p_id]}

        guild_obj = tb_guild_info.getObj(self._g_id)
        guild_obj.new(self._info)
        return g_id

    def save_data(self):
        guild_data = tb_guild_info.getObj(self._g_id)
        guild_data.hmset(self._info)

    def init_data(self, data):
        self._g_id = data.get("id")
        self._name = data.get("name")
        self._contribution = data.get("contribution")
        self._all_contribution = data.get("all_contribution")
        self._icon_id = data.get("icon_id")
        self._bless = data.get("bless")
        self._praise = data.get("praise")
        self._call = data.get("call")
        self._invite_join = data.get("invite_join")
        self._p_list = data.get("p_list")
        self._apply = data.get("apply")
        self._build = data.get("build")

        # 初始化粮草押运信息
        tb_guild_escort_tasks = tb_guild_info.getObj(self._g_id).getObj('escort_tasks')
        heros = tb_guild_escort_tasks.hgetall()
        for task_id, data in heros.items():
            task = EscortTask(self)
            task.init_data(data)
            self._escort_tasks[task.task_id] = task
        for k, task in self._escort_tasks:
            if task.state == 2:
                self._escort_tasks_can_rob.append(k)


    def join_guild(self, p_id):
        if self._apply.count(p_id) >= 1:
            self._apply.remove(p_id)
        # if len(self._apply) >= 50:
        #     self._apply.pop(0)
        self._apply.append(p_id)

    def get_position(self, p_id):
        for position, p_list in self._p_list.items():
            if p_id in p_list:
                return position
        else:
            return 0

    def exit_guild(self, p_id, position):
        # 人数减去1
        # position_p_list = self._p_list.get(position)
        # position_p_list.remove(p_id)
        # self._p_list.update({position: position_p_list})
        self._p_list.get(position).remote(p_id)

    def delete_guild(self):
        guild_obj = tb_guild_info.getObj(self._g_id)
        guild_obj.delete()

    def change_position(self, p_id, position, position1):
        '''
        position 原
        position1 后
        '''
        self._p_list.get(position).remote(p_id)
        self._p_list.get(position1).append(p_id)

    def editor_call(self, call):
        self._call = call

    def get_p_num(self):
        num = 0
        for p_list in self._p_list.values():
            num += len(p_list)
        return num

    @property
    def build(self):
        build_info = {}
        build_conf = game_configs.base_config.get('guild_level')
        for build_type, build_level in build_conf.items():
            if build_level >= 1:
                if self._build.get(build_type):
                    build_info[build_type] = self._build.get(build_type)
                else:
                    build_info[build_type] = build_level
        return build_info

    @build.setter
    def build(self, v):
        self._build = v

    @property
    def all_contribution(self):
        return self._all_contribution

    @all_contribution.setter
    def all_contribution(self, v):
        self._all_contribution = v

    @property
    def contribution(self):
        return self._contribution

    @contribution.setter
    def contribution(self, v):
        self._contribution = v

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, name):
        self._name = name

    @property
    def apply(self):
        return self._apply

    @apply.setter
    def apply(self, t_p_id):
        self._apply = t_p_id

    @property
    def p_list(self):
        return self._p_list

    @p_list.setter
    def p_list(self, p_list):
        self._p_list = p_list

    @property
    def exp(self):
        return self._exp

    @exp.setter
    def exp(self, exp):
        self._exp = exp

    @property
    def g_id(self):
        return self._g_id

    @g_id.setter
    def g_id(self, g_id):
        self._g_id = g_id

    @property
    def level(self):
        return self._level

    @level.setter
    def level(self, level):
        self._level = level

    @property
    def call(self):
        return self._call

    @call.setter
    def call(self, call):
        self._call = call

    @property
    def invite_join(self):
        return self._invite_join

    @invite_join.setter
    def invite_join(self, values):
        self._invite_join = values

    @property
    def icon_id(self):
        return self._icon_id

    @icon_id.setter
    def icon_id(self, values):
        self._icon_id = values

    @property
    def bless(self):
        return self._bless

    @bless.setter
    def bless(self, values):
        self._bless = values

    @property
    def escort_tasks(self):
        return self._escort_tasks

    @escort_tasks.setter
    def escort_tasks(self, values):
        self._escort_tasks = values

    @property
    def escort_tasks_can_rob(self):
        return self._escort_tasks_can_rob

    @escort_tasks_can_rob.setter
    def escort_tasks_can_rob(self, values):
        self._escort_tasks_can_rob = values

    @property
    def escort_tasks_invite_protect(self):
        return self._escort_tasks_invite_protect

    @escort_tasks_invite_protect.setter
    def escort_tasks_invite_protect(self, values):
        self._escort_tasks_invite_protect = values

    @property
    def escort_tasks_invite_rob(self):
        return self._escort_tasks_invite_rob

    @escort_tasks_invite_rob.setter
    def escort_tasks_invite_rob(self, values):
        self._escort_tasks_invite_rob = values

    @property
    def praise_num(self):
        if time.localtime(self._praise[2]).tm_yday != time.localtime().tm_yday:
            return 0
        return self._praise[0]

    @property
    def praise_money(self):
        if time.localtime(self._praise[2]).tm_yday != time.localtime().tm_yday:
            return 0
        return self._praise[1]

    # self._praise = [0, 0, 1]  # 点赞次数，累计金钱，时间
    def add_praise_money(self, num):
        now = int(time.time())
        if time.localtime(self._praise[2]).tm_yday != time.localtime(now).tm_yday:
            self._praise = [1, num, int(time.time())]
        else:
            self._praise[0] += 1
            self._praise[1] += num
            self._praise[2] = now

    def receive_praise_money(self):
        self._praise[1] = 0

    @property
    def bless_luck_num(self):
        if time.localtime(self._bless[2]).tm_yday != time.localtime().tm_yday:
            return 0
        return self._bless[1]

    @property
    def bless_num(self):
        if time.localtime(self._bless[2]).tm_yday != time.localtime().tm_yday:
            return 0
        return self._bless[0]

    def do_bless(self, v1, v2):
        self._contribution += v1
        self._all_contribution += v1
        if time.localtime(self._bless[2]).tm_yday != time.localtime().tm_yday:
            self._bless = [1, v2, int(time.time())]
        else:
            self._bless[0] += 1
            self._bless[1] += v2

    def get_task_by_id(self, task_id):
        return self._escort_tasks.get(task_id)

    def add_task(self, task_info):
        task = EscortTask(self)
        task.task_id = task_info.get("task_id")
        task.task_no = task_info.get("task_no")
        task.state = task_info.get("state")
        task.add_player(task_info.get("player_info"), 1, 0, self.guild_info())
        self._escort_tasks[task.task_id] = task
        return task

    def guild_info(self):
        data = {'id': self._g_id,
                'name': self._name,
                'icon_id': self._icon_id,
                'p_list': self._p_list,
                }
        return data
