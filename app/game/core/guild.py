# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午9:05.
"""
from app.game.redis_mode import tb_guild_info
from shared.utils.pyuuid import get_uuid


class Guild(object):
    """公会
    """
    def __init__(self):
        """创建一个角色
        """
        self._name = ''  # 名
        self._g_id = 0  # id
        self._p_num = 1  # 人数
        self._level = 1  # 等级
        self._exp = 0  # 经验
        self._fund = 0  # 资金
        self._call = ''  # 公告
        self._p_list = {}  # 成员信息
        self._apply = []  # 加入申请
        self._record = 0  # 战绩

    def create_guild(self, p_id, name):
        self._name = name
        uuid = get_uuid()
        self._g_id = uuid
        self._p_list = {1: [p_id]}
        # fund 资金
        data = {'id': self._g_id,
                'info': {'name': self._name,
                         'p_num': self._p_num,
                         'level': self._level,
                         'exp': self._exp,
                         'fund': self._fund,
                         'call': self._call,
                         'record': self._record,
                         'p_list': self._p_list,
                         'apply': self._apply}}
        tb_guild_info.new(data)

    def save_data(self):
        data = {
            'info': {'name': self._name,
                     'p_num': self._p_num,
                     'level': self._level,
                     'exp': self._exp,
                     'fund': self._fund,
                     'call': self._call,
                     'record': self._record,
                     'p_list': self._p_list,
                     'apply': self._apply}}
        print "cuick,###############,SAVE_DATA,guild info:", data
        guild_data = tb_guild_info.getObj(self._g_id)
        guild_data.update_multi(data)

    def init_data(self, data):
        self._g_id = data.get("id")
        info = data.get("info")
        self._name = info.get("name")
        self._p_num = info.get("p_num")
        self._level = info.get("level")
        self._exp = info.get("exp")
        self._fund = info.get("fund")
        self._call = info.get("call")
        self._p_list = info.get("p_list")
        self._apply = info.get("apply")
        self._record = info.get("record")

    def join_guild(self, p_id):
        if self._apply.count(p_id) >= 1:
            self._apply.remove(p_id)
        if len(self._apply) >= 50:
            self._apply.pop(0)
        self._apply.append(p_id)

    def exit_guild(self, p_id, position):
        self._p_num -= 1
        position_p_list = self._p_list.get(position)
        position_p_list.remove(p_id)
        print "cuick,###############???????????????????????" \
              "???????????????????????????????????????,TEST,info:", p_id

    def delete_guild(self):
        guild_info_obj = tb_guild_info.getObj(self._g_id)
        guild_info_obj.delete()

    def editor_call(self, call):
        self._call = call

    def get_p_num(self):
        return self._p_num

    def get_g_id(self):
        return self._g_id

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
    def p_num(self):
        return self._p_num

    @p_num.setter
    def p_num(self, p_num):
        self._p_num = p_num

    @property
    def fund(self):
        return self._fund

    @fund.setter
    def fund(self, fund):
        self._fund = fund

    @property
    def exp(self):
        return self._exp

    @exp.setter
    def exp(self, exp):
        self._exp = exp

