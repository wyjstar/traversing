# -*- coding:utf-8 -*-
"""
created by server on 14-6-27下午6:49.
"""
from shared.db_opear.configs_data import game_configs
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger
from shared.utils.const import const
from gfirefly.server.globalobject import GlobalObject
from shared.tlog import tlog_action


# const.COIN = 1
# const.GOLD = 2
# const.HERO_SOUL = 3
# const.JUNIOR_STONE = 4
# const.MIDDLE_STONE = 5
# const.HIGH_STONE = 6
# const.STAMINA = 7
# const.PVP = 8
# const.CONSUME_GOLD = 9
# const.GUILD2 = 11
# const.TEAM_EXPERIENCE = 12
# const.NECTAR = 13
# const.STONE1 = 14
# const.STONE2 = 15
# const.EQUIPMENT_ELITE = 21
# const.RESOURCE_MAX = 23

class CharacterFinanceComponent(Component):
    """货币"""

    def __init__(self, owner, coin=0, gold=0, hero_soul=0):
        super(CharacterFinanceComponent, self).__init__(owner)
        self._finances = [0] * const.RESOURCE_MAX

    def init_data(self, data):
        print("init data ============finance")
        self._finances = data['finances']
        while len(self._finances) < const.RESOURCE_MAX:
            self._finances.append(0)

    def save_data(self):
        character_obj = tb_character_info.getObj(self.owner.base_info.id)
        character_obj.hset('finances', self._finances)

    def new_data(self):
        self._finances = [0] * const.RESOURCE_MAX
        for t, v in game_configs.base_config.get('resource_for_InitUser').items():
            self._finances[t] = v
        return {'finances': self._finances}

    def __getitem__(self, res_type):
        if res_type >= len(self._finances):
            logger.error('get error resource type:%s', res_type)
            return None
        return self._finances[res_type]

    def __setitem__(self, res_type, value):
        if res_type >= len(self._finances):
            logger.error('set error resource type:%s', res_type)
            return
        self._finances[res_type] = value

    @property
    def coin(self):
        return self._finances[const.COIN]

    @coin.setter
    def coin(self, coin):
        self._finances[const.COIN] = coin

    @property
    def hero_soul(self):
        return self._finances[const.HERO_SOUL]

    @hero_soul.setter
    def hero_soul(self, value):
        self._finances[const.HERO_SOUL] = value

    @property
    def gold(self):
        """
        get gold num.
        """
        return self._finances[const.GOLD]

    @gold.setter
    def gold(self, gold):
        self._finances[const.GOLD] = gold

    @property
    def pvp_score(self):
        return self._finances[const.PVP]

    @pvp_score.setter
    def pvp_score(self, value):
        self._finances[const.PVP] = value

    def is_afford(self, fType, value):
        if fType >= len(self._finances):
            logger.error('afford error finance type:%s', fType)
            return False
        if self._finances[fType] < value:
            return False
        return True

    def consume(self, fType, num, reason):
        logger.debug("consume============= %s" % num)
        if fType >= len(self._finances):
            logger.error('consume error finance type:%s', fType)
            return False
        if num > self._finances[fType]:
            logger.error('not enough finance:%s:%s:%s',
                         fType, self._finances[fType], num)
            return False
        if fType != const.GOLD:
            self._finances[fType] -= int(num)
            self._owner.add_activity.add_currency(fType, num)
            self._owner.act.add_currency(fType, num)
            if reason:
                tlog_action.log('ItemFlow', self.owner, const.REDUCE, const.RESOURCE, num,
                                fType, 0, reason, self._finances[fType], '')
        return True

    def add(self, fType, num, reason=0):
        if fType >= len(self._finances):
            logger.error('consume error finance type:%s', fType)
            return False
        logger.debug("fType %s num %s" % (fType, num))
        if fType == const.GOLD:
            self.add_gold(num, reason)
        else:
            self._finances[fType] += int(num)
            if reason:
                tlog_action.log('ItemFlow', self.owner, const.ADD, const.RESOURCE, num,
                                fType, 0, reason, self._finances[fType], '')
        return True

    def add_coin(self, num, reason):
        self._finances[const.COIN] += num
        tlog_action.log('ItemFlow', self.owner, const.ADD, const.RESOURCE, num,
                        1, 0, reason, self._finances[const.COIN], '')
        tlog_action.log('MoneyFlow', self.owner, self._finances[const.COIN],
                        num, reason, const.ADD, 1)

    def consume_coin(self, num, reason):
        if num < self._finances[const.COIN]:
            return False
        self._finances[const.COIN] -= num
        tlog_action.log('ItemFlow', self.owner, const.REDUCE, const.RESOURCE, num,
                        1, 0, reason, self._finances[const.COIN], '')
        tlog_action.log('MoneyFlow', self.owner, self._finances[const.COIN],
                        num, reason, const.REDUCE, 1)
        return True

    def add_gold(self, num, reason):
        if self._owner.pay.REMOTE_DEPLOYED:
            self._owner.pay.present(num)
        else:
            self._finances[const.GOLD] += num
        if reason:
            tlog_action.log('ItemFlow', self.owner, const.ADD, const.RESOURCE, num,
                            2, 0, reason, self._finances[const.GOLD], '')
            tlog_action.log('MoneyFlow', self.owner, self._finances[const.GOLD],
                            num, reason, const.ADD, 2)

    def consume_gold(self, num, reason):
        """
        消耗元宝
        """
        logger.debug("consume_gold============= %s" % num)
        if num > self._finances[const.GOLD]:
            return False
        self._finances[const.CONSUME_GOLD] += num
        self._finances[const.GOLD] -= num
        self._owner.add_activity.add_currency(const.GOLD, num)
        self._owner.act.add_currency(const.GOLD, num)
        if reason:
            tlog_action.log('ItemFlow', self.owner, const.REDUCE, const.RESOURCE, num,
                            2, 0, reason, self._finances[const.GOLD], '')
            tlog_action.log('MoneyFlow', self.owner, self._finances[const.GOLD],
                            num, reason, const.REDUCE, 2)
        return True

    def add_hero_soul(self, num):
        self._finances[const.HERO_SOUL] += num

    def consume_hero_soul(self, num):
        self._finances[const.HERO_SOUL] -= num
