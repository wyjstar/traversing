# -*- coding:utf-8 -*-
"""
created by server on 15-5-29下午5:21.
"""
import time
import random
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from shared.db_opear.configs_data import game_configs


class CharacterPvpComponent(Component):
    def __init__(self, owner):
        """
        Constructor
        """
        Component.__init__(self, owner)
        self._pvp_overcome = []
        self._pvp_overcome_current = 0
        self._pvp_overcome_refresh_time = 0
        self._pvp_overcome_refresh_count = 0

        self._pvp_times = 0  # pvp次数
        self._pvp_refresh_time = 0
        self._pvp_refresh_count = 0
        self._pvp_high_rank = 999999  # 玩家pvp最高排名
        self._pvp_high_rank_award = []  # 已经领取的玩家pvp排名奖励

    def init_data(self, character_info):
        self._pvp_overcome = character_info['pvp_overcome']
        self._pvp_overcome_current = character_info['pvp_overcome_current']
        self._pvp_overcome_refresh_time = character_info['pvp_overcome_refresh_time']
        self._pvp_overcome_refresh_count = character_info['pvp_overcome_refresh_count']

        self._pvp_times = character_info['pvp_times']
        self._pvp_refresh_time = character_info['pvp_refresh_time']
        self._pvp_refresh_count = character_info['pvp_refresh_count']

        self._pvp_high_rank = character_info['pvp_high_rank']
        self._pvp_high_rank_award = character_info['pvp_high_rank_award']

        self.check_time()

        self.save_data()
        print self.__dict__

    def save_data(self):
        character_info = tb_character_info.getObj(self.owner.base_info.id)

        data = dict(pvp_overcome=self._pvp_overcome,
                    pvp_overcome_current=self._pvp_overcome_current,
                    pvp_overcome_refresh_time=self._pvp_overcome_refresh_time,
                    pvp_overcome_refresh_count=self.pvp_refresh_count,
                    pvp_high_rank=self._pvp_high_rank,
                    pvp_high_rank_award=self._pvp_high_rank_award,
                    pvp_times=self._pvp_times,
                    pvp_refresh_time=self._pvp_refresh_time,
                    pvp_refresh_count=self._pvp_refresh_count)
        character_info.hmset(data)

    def new_data(self):
        all_ids = tb_character_info.smem('all')
        for _ in range(12):
            self._pvp_overcome.append(random.choice(all_ids))

        data = dict(pvp_overcome=self._pvp_overcome,
                    pvp_overcome_current=self._pvp_overcome_current,
                    pvp_overcome_refresh_time=self.pvp_refresh_time,
                    pvp_overcome_refresh_count=self.pvp_refresh_count,
                    pvp_high_rank=self._pvp_high_rank,
                    pvp_high_rank_award=self._pvp_high_rank_award,
                    pvp_times=self._pvp_times,
                    pvp_refresh_time=self._pvp_refresh_time,
                    pvp_refresh_count=self._pvp_refresh_count)
        return data

    def check_time(self):
        tm = time.localtime(self._pvp_refresh_time)
        local_tm = time.localtime()
        if local_tm.tm_year != tm.tm_year or local_tm.tm_yday != tm.tm_yday:
            self._pvp_times += game_configs.base_config.get('arena_free_times')
            self._pvp_refresh_count = 0
            self._pvp_refresh_time = time.time()
            self.save_data()

    def get_overcome_id(self, index):
        if index > len(self._pvp_overcome):
            return 0

        return self._pvp_overcome[index]

    @property
    def pvp_overcome(self):
        return self._pvp_overcome

    @pvp_overcome.setter
    def pvp_overcome(self, value):
        self._pvp_overcome = value

    @property
    def pvp_overcome_current(self):
        return self._pvp_overcome_current

    @pvp_overcome_current.setter
    def pvp_overcome_current(self, value):
        self._pvp_overcome_current = value

    @property
    def pvp_times(self):
        return self._pvp_times

    @pvp_times.setter
    def pvp_times(self, value):
        self._pvp_times = value

    @property
    def pvp_refresh_time(self):
        return self._pvp_refresh_time

    @pvp_refresh_time.setter
    def pvp_refresh_time(self, value):
        self._pvp_refresh_time = value

    @property
    def pvp_refresh_count(self):
        return self._pvp_refresh_count

    @pvp_refresh_count.setter
    def pvp_refresh_count(self, value):
        self._pvp_refresh_count = value

    @property
    def pvp_high_rank(self):
        return self._pvp_high_rank

    @pvp_high_rank.setter
    def pvp_high_rank(self, value):
        self._pvp_high_rank = value

    @property
    def pvp_high_rank_award(self):
        return self._pvp_high_rank_award

    @pvp_high_rank_award.setter
    def pvp_high_rank_award(self, value):
        self._pvp_high_rank_award = value

    @property
    def pvp_overcome_refresh_time(self):
        return self._pvp_overcome_refresh_time

    # @pvp_overcome_refresh_time.setter
    # def pvp_overcome_refresh_time(self, value):
    #     self._pvp_overcome_refresh_time = value

    @property
    def pvp_overcome_refresh_count(self):
        return self._pvp_overcome_refresh_count

    # @pvp_overcome_refresh_count.setter
    # def pvp_overcome_refresh_count(self, value):
    #     self._pvp_overcome_refresh_count = value
