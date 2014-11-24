# -*- coding:utf-8 -*-
"""
created by server on 14-8-26
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_activity
from shared.db_opear.configs_data.game_configs import special_stage_config
from shared.utils.date_util import str_time_period_to_timestamp, get_current_timestamp


class CharacterWorldBoss(Component):
    """CharacterOnlineGift"""

    def __init__(self, owner):
        super(CharacterWorldBoss, self).__init__(owner)
        self._encourage_coin_num = 0
        self._encourage_gold_num = 0
        self._encourage_time = 0
        self._stage_id = 0

    def init_data(self):
        activity = tb_character_activity.getObjData(self.owner.base_info.id)

        if activity:
            data = activity.get('world_boss')
            if data:
                self._stage_id = data["stage_id"]
                self._encourage_coin_num = data['encourage_coin_num']
                self._encourage_gold_num = data['encourage_gold_num']
                self._encourage_time = data['encourage_time']
        else:
            data = {'encourage_coin_num': self._encourage_coin_num,
                    'encourage_gold_num': self._encourage_gold_num,
                    'encourage_time': self._encourage_time,
                    'stage_id': self._stage_id}
            tb_character_activity.new({'id': self.owner.base_info.id,
                                       'world_boss': data})


    def save_data(self):
        activity = tb_character_activity.getObj(self.owner.base_info.id)
        data = {'encourage_coin_num': self._encourage_coin_num,
                    'encourage_gold_num': self._encourage_gold_num,
                    'encourage_time': self._encourage_time,
                    'stage_id': self._stage_id}
        activity.update('world_boss', data)

    def get_encourage_num(self):
        stage_info = special_stage_config.get("boss_stages").get(self._stage_id)
        time_start, time_end = str_time_period_to_timestamp(stage_info.timeControl)
        if time_start > self._encourage_time or time_end < self._encourage_time:
            self._encourage_coin_num = 0
            self._encourage_gold_num = 0
            self._encourage_time = get_current_timestamp()
            self.save_data()
        return (self._encourage_coin_num, self._encourage_gold_num)

    @property
    def encourage_coin_num(self):
        return self.get_encourage_num()[0]

    @property
    def encourage_gold_num(self):
        return self.get_encourage_num()[1]

    @property
    def stage_id(self):
        return self._stage_id

    @stage_id.setter
    def stage_id(self, value):
        self._stage_id = value
        self.save_data()

