# -*- coding:utf-8 -*-
"""
created by server on 14-7-24下午6:32.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info


class CharacterGuildComponent(Component):
    """
    公会组件类
    """

    def __init__(self, owner):
        super(CharacterGuildComponent, self).__init__(owner)
        self._g_id = 'no'  # 公会id
        self._position = 5  # 职务
        self._contribution = 0  # 贡献
        self._all_contribution = 0  # 总贡献
        self._k_num = 0  # 杀人数
        self._worship = 0  # 膜拜次数
        self._worship_time = 1  # 最后膜拜时间
        self._exit_time = 1  # 上次退出公会时间

    def init_data(self, character_info):
        """
        初始化公会组件
        """
        if character_info.get('g_id'):
            self._g_id = character_info.get("g_id")
            self._position = character_info.get("position")
            self._contribution = character_info.get("contribution")
            self._all_contribution = character_info.get("all_contribution")
            self._k_num = character_info.get("k_num")
            self._worship = character_info.get("worship")
            self._worship_time = character_info.get("worship_time")
            self._exit_time = character_info.get("exit_time")
        else:
            # 没有公会数据
            character_info_obj = tb_character_info.getObj(self.owner.base_info.id)
            character_info_obj.update_multi({'g_id': self._g_id,
                                             'position': self._position,
                                             'contribution': self._contribution,
                                             'all_contribution': self._all_contribution,
                                             'k_num': self._k_num,
                                             'worship': self._worship,
                                             'worship_time': self._worship_time,
                                             'exit_time': self._exit_time})

    def save_data(self):
        data_obj = tb_character_info.getObj(self.owner.base_info.id)
        data_obj.update_multi({'g_id': self._g_id,
                               'position': self._position,
                               'contribution': self._contribution,
                               'all_contribution': self._all_contribution,
                               'k_num': self._k_num,
                               'worship': self._worship,
                               'worship_time': self._worship_time,
                               'exit_time': self._exit_time})

    @property
    def g_id(self):
        return self._g_id

    @g_id.setter
    def g_id(self, g_id):
        self._g_id = g_id

    @property
    def position(self):
        return self._position

    @position.setter
    def position(self, position):
        self._position = position

    @property
    def exit_time(self):
        return self._exit_time

    @exit_time.setter
    def exit_time(self, exit_time):
        self._exit_time = exit_time

    @property
    def worship(self):
        return self._worship

    @worship.setter
    def worship(self, worship):
        self._worship = worship

    @property
    def worship_time(self):
        return self._worship_time

    @worship_time.setter
    def worship_time(self, worship_time):
        self._worship_time = worship_time

    @property
    def contribution(self):
        return self._contribution

    @contribution.setter
    def contribution(self, contribution):
        self._contribution = contribution

    @property
    def all_contribution(self):
        return self._all_contribution

    @all_contribution.setter
    def all_contribution(self, all_contribution):
        self._all_contribution = all_contribution
