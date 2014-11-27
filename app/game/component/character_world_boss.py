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
        self._encourage_coin_num = 0   # 金币鼓舞
        self._encourage_gold_num = 0   # 钻石鼓舞
        self._last_request_time = 0    # 上次请求时间
        self._fight_times = 0          # 战斗次数
        self._last_fight_time = 0 # 上次战斗结束时间
        self._stage_id = 0             # 当前关卡

    def init_data(self):
        activity = tb_character_activity.getObjData(self.owner.base_info.id)

        if activity:
            data = activity.get('world_boss')
            if data:
                self._stage_id = data.get("stage_id", 0)
                self._encourage_coin_num = data.get('encourage_coin_num', 0)
                self._encourage_gold_num = data.get('encourage_gold_num', 0)
                self._last_request_time = data.get('last_request_time', 0)
                self._last_fight_time = data.get('last_fight_time', 0)
                self._fight_times = data.get('fight_times', 0)
                self._stage_id = data.get('stage_id', 0)
        else:
            data = {'encourage_coin_num': self._encourage_coin_num,
                    'encourage_gold_num': self._encourage_gold_num,
                    'last_request_time': self._last_request_time,
                    'last_fight_time': self._last_fight_time,
                    'fight_times': self._fight_times,
                    'stage_id': self._stage_id}
            tb_character_activity.new({'id': self.owner.base_info.id,
                                       'world_boss': data})


    def save_data(self):
        activity = tb_character_activity.getObj(self.owner.base_info.id)
        data = {'encourage_coin_num': self._encourage_coin_num,
                    'encourage_gold_num': self._encourage_gold_num,
                    'last_request_time': self._last_request_time,
                    'last_fight_time': self._last_fight_time,
                    'fight_times': self._fight_times,
                    'stage_id': self._stage_id}
        activity.update('world_boss', data)

    def reset_info(self):
        """
        如果过期，则重设信息
        """
        stage_info = special_stage_config.get("boss_stages").get(self._stage_id)
        time_start, time_end = str_time_period_to_timestamp(stage_info.timeControl)
        if time_start > self._last_request_time or time_end < self._last_request_time:
            self._encourage_coin_num = 0
            self._encourage_gold_num = 0
            self._fight_times = 0
            self._last_fight_time = 0
            self._stage_id = 0
            self._last_request_time = get_current_timestamp()
            self.save_data()

    @property
    def encourage_coin_num(self):
        return self._encourage_coin_num

    @encourage_coin_num.setter
    def encourage_coin_num(self, value):
        self._encourage_coin_num = value

    @property
    def encourage_gold_num(self):
        return self._encourage_gold_num

    @encourage_gold_num.setter
    def encourage_gold_num(self, value):
        self._encourage_gold_num = value

    @property
    def stage_id(self):
        return self._stage_id

    @stage_id.setter
    def stage_id(self, value):
        self._stage_id = value

    @property
    def fight_times(self):
        return self._fight_times

    @fight_times.setter
    def fight_times(self, value):
        self._fight_times = value

    @property
    def last_fight_time(self):
        return self._last_fight_time

    @last_fight_time.setter
    def last_fight_time(self, value):
        self._last_fight_time = value

