# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午9:05.
"""
from app.game.redis_mode import tb_guild_info
from shared.utils.pyuuid import get_uuid


class Guild(object):
    """公会
    """
    def __init__(self, name, g_id=0, p_num=1, level=1, exp=0, fund=0, call='', p_list={}, apple={}):
        """创建一个角色
        """
        self._name = name
        self._g_id = g_id
        self._p_num = p_num
        self._level = level
        self._exp = exp
        self._fund = fund
        self._call = call
        self._p_list = p_list
        self._apple = apple

    def create_guild(self, p_id):
        uuid = get_uuid()
        self._g_id = uuid
        self._p_list = {p_id: {'position': 1, \
                               'contribution': 0, \
                               'k_num': 0}}
        print 'cuick,AAAAAAAAAAAAAAAAAA,03,core/guild,01,name:', self._name
        # tb_guild_info
        # tb_character_guild
        # fund 资金
        # position 职位 1会长 2副会长 3长老 4精英 5会员
        # data = {'id': uuid, \
        #         'base_info': {'name': self._name, \
        #                       'p_num': self._p_num, \
        #                       'level': self._level, \
        #                       'exp': self._exp, \
        #                       'fund': self._fund}, \
        #         'call': self._call, \
        #         'p_list': {p_id: {'position': 1, \
        #                           'contribution': 0, \
        #                           'k_num': 0}}, \
        #         'apply': self._apple}
        data = {'id': self._g_id, \
                'info': {'name': self._name, \
                         'p_num': self._p_num, \
                         'level': self._level, \
                         'exp': self._exp, \
                         'fund': self._fund, \
                         'call': self._call, \
                         'p_list': self._p_list, \
                         'apply': self._apple}}
        print 'cuick,AAAAAAAAAAAAAAAAAA,04,core/guild,02,data:', data
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
                     'apply': self._apple}}

        guild_data = tb_guild_info.getObj(self._g_id)
        guild_data.update_multi(data)

    def init_data(self):
        data = tb_guild_info.getObjData(self._g_id)
        print '==========data:', data, '================='










