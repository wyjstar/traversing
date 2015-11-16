# -*- coding:utf-8 -*-
"""
@author: cui
"""
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
import random
import time


class Guild(object):
    """公会
    """
    def __init__(self, tb_guild_info):
        """
        """
        self._name = 0  # 名
        self._g_id = 0  # id
        self._p_num = 1  # 人数
        self._contribution = 0  # 当前建设值
        self._all_contribution = 0  # 总建设值
        self._call = ''  # 公告
        self._p_list = {}  # 成员信息
        self._apply = []  # 加入申请
        self._invite_join = {}  # {id:time, id:time}
        self._icon_id = 0  # 军团头像
        self._bless = [0, 0, 1]  # 祈福人数,福运,时间
        self._praise = [0, 0, 0, 1]  # 点赞次数,团长奖励领取状态，累计金钱，时间
        self._build = {}  # 建筑等级 {建筑类型：建筑等级}
        self._tb_guild_info = tb_guild_info

    @property
    def info(self):
        data = self._info()
        data['p_num'] = self.get_p_num()
        return data

    @property
    def _info(self):
        data = {'id': self._g_id,
                'name': self._name,
                'level': self._level,
                'exp': self._exp,
                'icon_id': self._icon_id,
                'bless': self._bless,
                'praise': self._praise,
                'call': self._call,
                'invite_join': self._invite_join,
                'p_list': self._p_list,
                'apply': self._apply}
        return data

    def create_guild(self, p_id, name, icon_id):
        g_id = self._tb_guild_info.getObj('incr').incr()

        self._name = name
        self._g_id = g_id
        self._icon_id = icon_id
        self._p_list = {1: [p_id]}

        guild_obj = self._tb_guild_info.getObj(self._g_id)
        guild_obj.new(self._info)
        return g_id

    def save_data(self):
        guild_data = self._tb_guild_info.getObj(self._g_id)
        guild_data.hmset(self._info)

    def init_data(self, data):
        self._g_id = data.get("id")
        self._name = data.get("name")
        self._level = data.get("level")
        self._exp = data.get("exp")
        self._icon_id = data.get("icon_id")
        self._bless = data.get("bless")
        self._praise = data.get("praise")
        self._call = data.get("call")
        self._invite_join = data.get("invite_join")
        self._p_list = data.get("p_list")
        self._apply = data.get("apply")

    def join_guild(self, p_id):
        if self._apply.count(p_id) >= 1:
            self._apply.remove(p_id)
        # if len(self._apply) >= 50:
        #     self._apply.pop(0)
        self._apply.append(p_id)

    def exit_guild(self, p_id, position):
        self._p_num -= 1
        position_p_list = self._p_list.get(position)
        position_p_list.remove(p_id)
        self._p_list.update({position: position_p_list})

    def delete_guild(self):
        guild_obj = self._tb_guild_info.getObj(self._g_id)
        guild_obj.delete()

    def editor_call(self, call):
        self._call = call

    def get_p_num(self):
        num = 0
        for p_list in self._p_list.values():
            num += len(p_list)
        return num

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
    def praise(self):
        return self._praise

    @praise.setter
    def praise(self, values):
        self._praise = values

    @property
    def praise_num(self):
        if time.localtime(self._praise[2]).tm_yday != time.localtime().tm_yday:
            self._praise = [0, 0, int(time.time())]
            self.save_data()
        return self._praise[0]

    @property
    def receive_praise_state(self):
        if time.localtime(self._praise[2]).tm_yday != time.localtime().tm_yday:
            self._praise = [0, 0, int(time.time())]
            self.save_data()
        return self._praise[1]

    @property
    def bless_luck_num(self):
        if time.localtime(self._bless[2]).tm_yday != time.localtime().tm_yday:
            self._bless = [0, 0, int(time.time())]
            self.save_data()
        return self._bless[1]

    @property
    def bless_num(self):
        if time.localtime(self._bless[2]).tm_yday != time.localtime().tm_yday:
            self._bless = [0, 0, int(time.time())]
            self.save_data()
        return self._bless[0]
