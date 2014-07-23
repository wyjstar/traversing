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
        self._name = ''
        self._g_id = 0
        self._p_num = 1
        self._level = 1
        self._exp = 0
        self._fund = 0
        self._call = ''
        self._p_list = {}
        self._apply = []

    def create_guild(self, p_id, name):
        self._name = name
        uuid = get_uuid()
        self._g_id = uuid
        self._p_list = {p_id: {'position': 1, \
                               'contribution': 0, \
                               'k_num': 0}}
        # fund 资金
        data = {'id': self._g_id, \
                'info': {'name': self._name, \
                         'p_num': self._p_num, \
                         'level': self._level, \
                         'exp': self._exp, \
                         'fund': self._fund, \
                         'call': self._call, \
                         'p_list': self._p_list, \
                         'apply': self._apply}}
        tb_guild_info.new(data)
        # 玩家id：公会id
        # 存入

    def save_data(self):
        data = {
            'info': {'name': self._name, \
                     'p_num': self._p_num, \
                     'level': self._level, \
                     'exp': self._exp, \
                     'fund': self._fund, \
                     'call': self._call, \
                     'p_list': self._p_list, \
                     'apply': self._apply}}
        print "cuick,###############,SAVE_DATA,info:", data
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

    def join_guild(self, p_id):
        if self._apply.count(p_id) >= 1:
            self._apply.remove(p_id)
        if len(self._apply) >= 50:
            self._apply.pop(0)
        self._apply.append(p_id)

    def get_p_num(self):
        return self._p_num











