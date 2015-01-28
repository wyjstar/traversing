# -*- coding:utf-8 -*-
"""
created by server on 14-9-28上午10:59.
"""

from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from shared.db_opear.configs_data.game_configs import base_config
from app.proto_file.db_pb2 import Stamina_DB
from gfirefly.server.logobj import logger
from shared.utils.const import const
import time


def peroid_of_stamina_recover():
    return base_config.get('peroid_of_vigor_recover')


def max_of_stamina():
    return base_config.get('max_of_vigor')


class CharacterStaminaComponent(Component):
    """体力组件"""

    def __init__(self, owner):
        super(CharacterStaminaComponent, self).__init__(owner)
        self._stamina = Stamina_DB()

    def init_data(self, character_info):
        stamina_data = character_info.get('stamina')
        self._stamina.ParseFromString(stamina_data)
        _peroid = peroid_of_stamina_recover()

        # 初始化体力
        current_time = int(time.time())
        logger.debug("last_gain_stamina_time:%s",
                     self._stamina.last_gain_stamina_time)
        logger.debug("_peroid:%s", _peroid)

        stamina_add = (current_time - self._stamina.last_gain_stamina_time) / _peroid
        left_stamina = (current_time - self._stamina.last_gain_stamina_time) % _peroid

        if self.owner.finance[const.STAMINA] < max_of_stamina():
            # 如果原来的体力超出上限，则不添加体力
            _value = self.owner.finance[const.STAMINA] + int(stamina_add)
            self.owner.finance[const.STAMINA] = min(_value, max_of_stamina())
        self._stamina.last_gain_stamina_time = current_time - left_stamina

        self.check_time()

    def save_data(self):
        info = tb_character_info.getObj(self.owner.base_info.id)
        info.hset('stamina', self._stamina.SerializeToString())

    def new_data(self):
        return dict(stamina=self._stamina.SerializeToString())

    def check_time(self):
        tm = time.localtime(self.last_mail_day)
        dateNow = time.time()
        local_tm = time.localtime(dateNow)
        if local_tm.tm_year != tm.tm_year or local_tm.tm_yday != tm.tm_yday:
            self._stamina.last_mail_day = dateNow
            self._stamina.get_stamina_times = 0
            self._stamina.ClearField('contributors')
            self.save_data()

    @property
    def stamina(self):
        """体力"""
        return self.owner.finance[const.STAMINA]

    @stamina.setter
    def stamina(self, value):
        """体力"""
        self.owner.finance[const.STAMINA] = value
        self.owner.finance.save_data()

    def open_receive(self):
        self._stamina.open_receive = 1

    def close_receive(self):
        self._stamina.open_receive = 0

    def add_stamina(self, value):
        """ 添加体力
        """
        if not self._stamina.open_receive:
            return
        stamina = self.owner.finance[const.STAMINA] + value
        self.owner.finance[const.STAMINA] = min(stamina, max_of_stamina())
        self.owner.finance.save_data()

    @property
    def get_stamina_times(self):
        """邮件中获取赠送体力次数"""
        self.check_time()
        return self._stamina.get_stamina_times

    @get_stamina_times.setter
    def get_stamina_times(self, value):
        """邮件中获取赠送体力次数"""
        self._stamina.get_stamina_times = value

    @property
    def buy_stamina_times(self):
        """已经购买的体力次数"""
        return self._stamina.buy_stamina_times

    @buy_stamina_times.setter
    def buy_stamina_times(self, value):
        """已经购买的体力次数"""
        self._stamina.buy_stamina_times = value

    @property
    def last_gain_stamina_time(self):
        """已经购买的体力次数"""
        return self._stamina.last_gain_stamina_time

    @last_gain_stamina_time.setter
    def last_gain_stamina_time(self, value):
        """已经购买的体力次数"""
        self._stamina.last_gain_stamina_time = value

    @property
    def contributors(self):
        self.check_time()
        return self._contributors
