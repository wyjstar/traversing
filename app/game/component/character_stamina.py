# -*- coding:utf-8 -*-
"""
created by server on 14-9-28上午10:59.
"""

from app.game.component.Component import Component
from shared.db_opear.configs_data.game_configs import vip_config
from app.game.redis_mode import tb_character_info
import cPickle
import time
from shared.db_opear.configs_data.game_configs import base_config


class CharacterStaminaComponent(Component):
    """体力组件"""

    def __init__(self, owner):
        super(CharacterStaminaComponent, self).__init__(owner)
        self._stamina = 0  # 体力
        self._get_stamina_times = 0  # 通过邮件获取体力次数
        self._buy_stamina_times = 0  # 购买体力次数
        self._last_gain_stamina_time = 0  # 上次获取体力时间

    def init_data(self):
        data = tb_character_info.getObjData(self.owner.base_info.id)
        stamina_data = data.get('stamina', None)
        if stamina_data:                  
            self._stamina = stamina_data.get('stamina')
            self._get_stamina_times = stamina_data.get('get_stamina_times')
            self._buy_stamina_times = stamina_data.get('buy_stamina_times')
            self._last_gain_stamina_time = stamina_data.get('last_gain_stamina_time')

            # 初始化体力
            current_time = int(time.time())
            stamina_add = (current_time-self._last_gain_stamina_time) / self.peroid_of_stamina_recover
            left_stamina = (current_time-self._last_gain_stamina_time) % self.peroid_of_stamina_recover

            if self._stamina < self.max_of_stamina:  # 如果原来的体力超出上限，则不添加体力
                self._stamina += int(stamina_add)
                if self._stamina > self.max_of_stamina:  # 如果体力超出上限， 则设为上限
                    self._stamina = self.max_of_stamina
            self._last_gain_stamina_time = current_time - left_stamina

        else:
            obj = tb_character_info.getObj(self.owner.base_info.id)
            obj.update_multi(
            {'stamina': {
                   'stamina': 120,
                   'get_stamina_times': 0,
                   'buy_stamina_times': 0,
                   'last_gain_stamina_time': 0,
            }})

    @property
    def peroid_of_stamina_recover(self):
        return base_config.get('peroid_of_vigor_recover', 300)

    @property
    def max_of_stamina(self):
        return base_config.get('max_of_vigor', 120)
    
    @property
    def stamina(self):
        """体力"""
        return self._stamina

    @stamina.setter
    def stamina(self, value):
        """体力"""
        self._stamina = value

    @property
    def get_stamina_times(self):
        """邮件中获取赠送体力次数"""
        return self._get_stamina_times

    @get_stamina_times.setter
    def get_stamina_times(self, value):
        """邮件中获取赠送体力次数"""
        self._get_stamina_times = value

    @property
    def buy_stamina_times(self):
        """已经购买的体力次数"""
        return self._buy_stamina_times

    @buy_stamina_times.setter
    def buy_stamina_times(self, value):
        """已经购买的体力次数"""
        self._buy_stamina_times = value

    @property
    def last_gain_stamina_time(self):
        """已经购买的体力次数"""
        return self._last_gain_stamina_time

    @last_gain_stamina_time.setter
    def last_gain_stamina_time(self, value):
        """已经购买的体力次数"""
        self._last_gain_stamina_time = value    

    def save_data(self):
        props = {'stamina':{
            'stamina': self._stamina,
            'get_stamina_times': self._get_stamina_times,
            'buy_stamina_times': self._buy_stamina_times,
            'last_gain_stamina_time': self._last_gain_stamina_time,              
        }}

        info = tb_character_info.getObj(self.owner.base_info.id)
        info.update_multi(props)