# -*- coding:utf-8 -*-
"""
created by server on 14-9-28上午10:59.
"""

from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from shared.db_opear.configs_data.game_configs import base_config
from gfirefly.server.logobj import logger
from shared.utils.const import const
import datetime
import time


class CharacterStaminaComponent(Component):
    """体力组件"""

    def __init__(self, owner):
        super(CharacterStaminaComponent, self).__init__(owner)
        self._open_receive = 1  # 开启接收活力
        self._get_stamina_times = 0  # 通过邮件获取体力次数
        self._buy_stamina_times = 0  # 购买体力次数
        self._last_gain_stamina_time = 0  # 上次获取体力时间
        self._last_mail_day = ''  # 上次通过邮件获取的体力的日期-周期

    def init_stamina(self, stamina_data):
        if stamina_data:
            self._open_receive = stamina_data.get('open_receive')
            if self._open_receive is None:
                self._open_receive = 1
            self._get_stamina_times = stamina_data.get('get_stamina_times')
            self._buy_stamina_times = stamina_data.get('buy_stamina_times')
            self._last_gain_stamina_time = stamina_data.get('last_gain_stamina_time')
            self._last_mail_day = stamina_data.get('last_mail_day', '')

            # 初始化体力
            current_time = int(time.time())
            logger.debug("last_gain_stamina_time:" + str(self._last_gain_stamina_time))
            logger.debug("peroid_of_stamina_recover:" + str(self.peroid_of_stamina_recover))

            stamina_add = (current_time - self._last_gain_stamina_time) / self.peroid_of_stamina_recover
            left_stamina = (current_time - self._last_gain_stamina_time) % self.peroid_of_stamina_recover

            if self.owner.finance[const.STAMINA] < self.max_of_stamina:  # 如果原来的体力超出上限，则不添加体力
                self.owner.finance[const.STAMINA] += int(stamina_add)
                if self.owner.finance[const.STAMINA] > self.max_of_stamina:  # 如果体力超出上限， 则设为上限
                    self.owner.finance[const.STAMINA] = self.max_of_stamina
            self._last_gain_stamina_time = current_time - left_stamina

    @property
    def detail_data(self):
        """stamina detail data"""
        return  {
            'open_receive': self._open_receive,
            'get_stamina_times': self._get_stamina_times,
            'buy_stamina_times': self._buy_stamina_times,
            'last_gain_stamina_time': self._last_gain_stamina_time,
            'last_mail_day':self._last_mail_day,
        }

    @property
    def peroid_of_stamina_recover(self):
        return base_config.get('peroid_of_vigor_recover', 300)

    @property
    def max_of_stamina(self):
        return base_config.get('max_of_vigor', 120)

    @property
    def stamina(self):
        """体力"""
        return self.owner.finance[const.STAMINA]

    @stamina.setter
    def stamina(self, value):
        """体力"""
        self.owner.finance[const.STAMINA] = value

    def open_receive(self):
        self._open_receive = 1

    def close_receive(self):
        self._open_receive = 0

    def add_stamina(self, value):
        """ 添加体力
        """
        if not self._open_receive:
            return
        self.owner.finance[const.STAMINA] += value
        self.owner.finance[const.STAMINA] = min(self.owner.finance[const.STAMINA], self.max_of_stamina)
        self.owner.finance.save_data()

    @property
    def get_stamina_times(self):
        """邮件中获取赠送体力次数"""
        date_now = datetime.datetime.now().date()
        if self._last_mail_day != date_now:
            self._last_mail_day = date_now
            self._get_stamina_times = 0

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
        props = dict(stamina=self.detail_data)
        info = tb_character_info.getObj(self.owner.base_info.id)
        logger.debug(str(props))
        info.update_multi(props)
