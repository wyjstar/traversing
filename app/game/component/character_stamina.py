# -*- coding:utf-8 -*-
"""
created by server on 14-9-28上午10:59.
"""

from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from shared.db_opear.configs_data import game_configs
from app.proto_file.db_pb2 import All_Stamina_DB
from gfirefly.server.logobj import logger
from shared.utils.const import const
import time
from shared.utils.date_util import is_next_day


def peroid_of_stamina_recover():
    return game_configs.base_config.get('peroid_of_vigor_recover')


def max_of_stamina():
    return game_configs.base_config.get('max_of_vigor')


class CharacterStaminaComponent(Component):
    """可恢复性资源组件: 体力，讨伐令，鞋子"""

    def __init__(self, owner):
        super(CharacterStaminaComponent, self).__init__(owner)
        self._stamina = All_Stamina_DB()

    def init_data(self, character_info):
        stamina_data = character_info.get('stamina')
        self._stamina.ParseFromString(stamina_data)
        for item in self._stamina.stamina:
            logger.debug("resource type %s" % item.resource_type)
            self.check_time(item.resource_type)
        self.save_data()

    def save_data(self):
        info = tb_character_info.getObj(self.owner.base_info.id)
        info.hset('stamina', self._stamina.SerializeToString())

    def new_data(self):
        stamina_pb = self._stamina.stamina.add()
        stamina_pb.resource_type = const.STAMINA         # 体力
        stamina_pb = self._stamina.stamina.add()         #
        stamina_pb.resource_type = const.HJQYFIGHTTOKEN  # 讨伐令
        stamina_pb = self._stamina.stamina.add()         #
        stamina_pb.resource_type = const.SHOE            # 鞋
        stamina_pb = self._stamina.stamina.add()
        stamina_pb.resource_type = const.ENERGY         # 精力
        stamina_pb = self._stamina.stamina.add()
        stamina_pb.resource_type = const.GUILD_ESCORT_ROB_TIMES # 公会劫运次数

        return dict(stamina=self._stamina.SerializeToString())

    def check_time_all(self):
        for item in self._stamina.stamina:
            logger.debug("refresh resource type %s" % item.resource_type)
            self.check_time(item.resource_type)
        self.save_data()

    def check_time(self, resource_type):
        """docstring for _check_time"""

        item = self.get_item(resource_type)
        info = self.get_info(resource_type, self._owner)
        current_time = int(time.time())
        logger.debug("info %s" % info)
        stamina_add = 0
        if info.get("recover_period"):
            stamina_add = (current_time - item.last_gain_stamina_time) / info.get("recover_period")
        # left_stamina = (current_time - item.last_gain_stamina_time) % info.get("recover_period")
        logger.debug("stamina_add %s " % (stamina_add,))
        if self.owner.finance[resource_type] < info.get("max_value"):
            # 如果原来的超出上限，则不添加
            _value = self.owner.finance[resource_type] + int(stamina_add)
            if _value < 0:
                _value = 0
            self.owner.finance._finances[resource_type] = min(_value, info.get("max_value"))
        if int(stamina_add) > 0 or int(stamina_add) < 0:
            item.last_gain_stamina_time = current_time

        if is_next_day(time.time(), item.last_buy_stamina_time):
            item.buy_stamina_times = 0

        self._owner.finance.save_data()
        logger.debug("check_time finance %s" % self.owner.finance._finances)
        if resource_type != const.STAMINA:
            return
        # 体力相关
        tm = time.localtime(item.last_mail_day)
        dateNow = int(time.time())
        local_tm = time.localtime(dateNow)
        if local_tm.tm_year != tm.tm_year or local_tm.tm_yday != tm.tm_yday:
            item.last_mail_day = dateNow
            item.get_stamina_times = 0
            item.ClearField('contributors')

    @property
    def stamina(self):
        """体力"""
        return self.owner.finance[const.STAMINA]

    @stamina.setter
    def stamina(self, value):
        """体力"""
        self.owner.finance[const.STAMINA] = value
        self.owner.finance.save_data()

    def get_item(self, resource_type):
        for item in self._stamina.stamina:
            if item.resource_type == resource_type:
                return item
        return None

    def get_info(self, resource_type, player, buy_stamina_times=0):
        max_value = 0
        one_buy_value = 0
        recover_period = 0
        recover_unit = 0
        can_buy_times = 0
        need_gold = 0
        logger.debug("resource_type %s %s" % (resource_type, const.STAMINA))
        logger.debug("%s %s" % (type(resource_type), type(const.STAMINA)))
        currency_info = game_configs.currency_config[resource_type]
        max_value = currency_info.get("storageMax")
        one_buy_value = currency_info.get("buyOneNumber")
        recover_period = currency_info.get("recoveryTime")
        recover_unit = currency_info.get("recoveryNumber")
        need_gold = 0
        if currency_info.get("buyPrice"):
            if -1 in currency_info.get("buyPrice"):
                need_gold = currency_info.get("buyPrice").get(-1)[1]
            else:
                need_gold = currency_info.get("buyPrice").get(buy_stamina_times+1)[1]

        if resource_type == const.STAMINA: # 体力
            can_buy_times = player.base_info.buy_stamina_max
        elif resource_type == const.HJQYFIGHTTOKEN: # 讨伐令
            can_buy_times = player.base_info.buy_hjqy_max
        elif resource_type == const.SHOE: # 鞋子
            can_buy_times = player.base_info.buy_shoe_max
        elif resource_type == const.ENERGY: # 精力
            can_buy_times = player.base_info.buy_energy_max
        elif resource_type == const.GUILD_ESCORT_ROB_TIMES: # 公会押运次数
            can_buy_times = player.base_info.guild_escort_rob_times_max
        return dict(max_value=max_value,
                one_buy_value=one_buy_value,
                recover_period=recover_period,
                recover_unit=recover_unit,
                can_buy_times=can_buy_times,
                need_gold=need_gold
                )

    @property
    def _open_receive(self):
        item = self.get_item(const.STAMINA)
        return item.open_receive

    def open_receive(self):
        item = self.get_item(const.STAMINA)
        item.open_receive = 1

    def close_receive(self):
        item = self.get_item(const.STAMINA)
        item.open_receive = 0

    def add_stamina(self, value):
        """ 添加体力, 保留原来的接口
        """
        item = self.get_item(const.STAMINA)
        info = self.get_info(const.STAMINA, self._owner)
        if not item.open_receive:
            return
        stamina = self.owner.finance[const.STAMINA] + value
        self.owner.finance[const.STAMINA] = min(stamina, info.get("max_value"))
        self.owner.finance.save_data()

    @property
    def get_stamina_times(self):
        """邮件中获取赠送体力次数"""
        self.check_time(const.STAMINA)
        item = self.get_item(const.STAMINA)
        return item.get_stamina_times

    @get_stamina_times.setter
    def get_stamina_times(self, value):
        """邮件中获取赠送体力次数"""
        item = self.get_item(const.STAMINA)
        item.get_stamina_times = value

    @property
    def buy_stamina_times(self):
        """已经购买的体力次数"""
        item = self.get_item(const.STAMINA)
        return item.buy_stamina_times

    @buy_stamina_times.setter
    def buy_stamina_times(self, value):
        """已经购买的体力次数"""
        item = self.get_item(const.STAMINA)
        item.buy_stamina_times = value

    @property
    def last_gain_stamina_time(self):
        """已经购买的体力次数"""
        item = self.get_item(const.STAMINA)
        return item.last_gain_stamina_time

    @last_gain_stamina_time.setter
    def last_gain_stamina_time(self, value):
        """已经购买的体力次数"""
        item = self.get_item(const.STAMINA)
        item.last_gain_stamina_time = value

    @property
    def contributors(self):
        self.check_time(const.STAMINA)
        item = self.get_item(const.STAMINA)
        return item.contributors

    @property
    def last_buy_stamina_time(self):
        """上次购买体力时间"""
        item = self.get_item(const.STAMINA)
        return item.last_buy_stamina_time

    @last_buy_stamina_time.setter
    def last_buy_stamina_time(self, value):
        """上次购买体力时间"""
        item = self.get_item(const.STAMINA)
        item.last_buy_stamina_time = value
