# -*- coding:utf-8 -*-
"""
created by lucas on 14-11-11下午4:05.
"""
import random
import time
from shared.db_opear.configs_data import game_configs
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger
from shared.utils.const import const

from app.game.core.item_group_helper import consume, get_consume_gold_num
from app.game.core.item_group_helper import get_return
from app.game.core.item_group_helper import is_afford

# base_config.get('cookingWineOpenLevel')
# base_config.get('cookingWineOutput')
# base_config.get('cookingWineOutputCrit')
# base_config.get('cookingWinePrice')


class CharacterBrewComponent(Component):
    def __init__(self, owner):
        super(CharacterBrewComponent, self).__init__(owner)
        self._brew_date = 0
        # self._nectar = 0
        self._nectar_cur = 0
        self._brew_times = 0
        self._brew_step = 1

    def init_data(self, character_data):
        brew = character_data.get('brew')
        self._brew_times = brew.get('brew_times')
        self._brew_date = brew.get('brew_data')
        self._nectar_cur = brew.get('nectar_cur')
        self._brew_step = brew.get('brew_step')
        self.check_time()

    def save_data(self):
        char_obj = tb_character_info.getObj(self.owner.base_info.id)
        if char_obj:
            brew = dict(brew_times=self._brew_times,
                        brew_data=self._brew_date,
                        nectar_cur=self._nectar_cur,
                        brew_step=self._brew_step)
            char_obj.hset('brew', brew)
        else:
            logger.error('cant find charinfo:%s', self.owner.base_info.id)

    def new_data(self):
        self.check_time()
        brew = dict(brew_times=self._brew_times,
                    brew_data=self._brew_date,
                    nectar_cur=self._nectar_cur,
                    brew_step=self._brew_step)
        return {'brew': brew}

    def do_brew(self, brew_type, response):
        vip_level = self.owner.base_info.vip_level
        brew_times_max = game_configs.vip_config.get(vip_level).get('cookingTimes')

        MAX_STEPS = len(game_configs.base_config.get('cookingWinePrice')[brew_type])

        self.check_time()
        if self._brew_step > MAX_STEPS:
            return False

        if self.owner.base_info.level < game_configs.base_config.get('cookingWineOpenLevel'):
            logger.error('char brew level error!!:%s',
                         self.owner.base_info.level)
            return False

        critical = game_configs.base_config.get('cookingWineOutputCrit')
        if brew_type not in critical:
            logger.error('base config error type:%s', brew_type)
            return False

        if self.brew_times >= brew_times_max:
            logger.error('there is no times to brew:%s', self.brew_times)
            return False

        brew_prices = game_configs.base_config.get('cookingWinePrice')
        if brew_type not in brew_prices:
            logger.error('base config error step:%s', brew_type)
            return False

        _consume = brew_prices[brew_type][self._brew_step - 1]
        result = is_afford(self.owner, _consume)  # 校验
        if not result.get('result'):
            logger.error('not enough gold to do brew:%s', _consume)
            return False

        need_gold = get_consume_gold_num(_consume)
        critical_type = critical[brew_type]

        def func():
            return_data = consume(self.owner, _consume, const.DREW)
            get_return(self.owner, return_data, response.consume)

            self._brew_step += 1
            rand = random.random()*sum(critical_type.values())
            for critical_num, rand_range in critical_type.items():
                if rand < rand_range:
                    increment = critical_num * game_configs.base_config.get('cookingWineOutput')
                    self._nectar_cur += int(increment)
                    break
                else:
                    rand -= rand_range
            logger.info('brew type:%s, rand:%s nectar:%s nectar\
    cur:%s time:%s cri:%s',
                        brew_type,
                        rand,
                        self.nectar,
                        self._nectar_cur,
                        self.brew_times,
                        critical_num)

            self.save_data()
        self.owner.pay.pay(need_gold, const.DREW, func)
        return True

    def taken_brew(self):
        self.check_time()
        vip_level = self.owner.base_info.vip_level
        brew_times_max = game_configs.vip_config.get(vip_level).get('cookingTimes')
        if self._brew_times >= brew_times_max:
            logger.error('not enough times to taken brew:%s', self._brew_times)
            return False
        # self._nectar += self._nectar_cur
        self.owner.finance[const.NECTAR] += self._nectar_cur
        self.owner.finance.save_data()
        self._nectar_cur = game_configs.base_config.get('cookingWineOutput')
        self._brew_step = 1
        self._brew_times += 1
        self.save_data()
        return True

    def check_time(self):
        tm = time.localtime(self._brew_date)
        local_tm = time.localtime()
        if local_tm.tm_year != tm.tm_year or local_tm.tm_yday != tm.tm_yday:
            self._brew_date = time.time()
            # vip_level = self.owner.base_info.vip_level
            self._brew_times = 0
        # logger.debug('brew times vip:%s :%s', vip_level, self._brew_times)
            self._nectar_cur = game_configs.base_config.get('cookingWineOutput')
            self._brew_step = 1

    def consume(self, value, reason):
        return self.owner.finance.consume(const.NECTAR, value, reason)

    @property
    def nectar(self):
        return self.owner.finance[const.NECTAR]

    @property
    def brew_times(self):
        return self._brew_times

    @property
    def nectar_cur(self):
        return self._nectar_cur

    @property
    def brew_step(self):
        return self._brew_step
