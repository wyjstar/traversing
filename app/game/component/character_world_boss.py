# -*- coding:utf-8 -*-
"""
created by server on 14-8-26
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_activity
from shared.db_opear.configs_data.game_configs import special_stage_config, base_config
from shared.utils.date_util import str_time_period_to_timestamp, get_current_timestamp


class CharacterWorldBoss(Component):
    """CharacterOnlineGift"""

    def __init__(self, owner):
        super(CharacterWorldBoss, self).__init__(owner)
        self._bosses = {}

    def init_data(self):
        activity = tb_character_activity.getObjData(self.owner.base_info.id)

        if activity:
            data = activity.get('world_boss')
            if data:
                for k, info in data.items():
                    if not info:
                        continue
                    boss = Boss()
                    boss.init_data(info)
                    self._bosses[boss.boss_id] = boss
        else:
            data = {}
            tb_character_activity.new({'id': self.owner.base_info.id,
                                       'world_boss': data})


    def save_data(self):
        activity = tb_character_activity.getObj(self.owner.base_info.id)
        data = {}
        for k, boss in self._bosses.items():
            data[k] = boss.get_data_dict()

        activity.update('world_boss', data)

    def get_boss(self, boss_id):
        boss = self._bosses.get(boss_id)
        if not boss:
            boss = Boss(boss_id)
            self._bosses[boss_id] = boss
        return boss

class Boss(object):
    """docstring for Boss"""
    def __init__(self, boss_id=""):
        super(Boss, self).__init__()
        self._boss_id = boss_id   # boss_id:世界boss(world_boss), mine_boss(...)
        self._encourage_coin_num = 0   # 金币鼓舞
        self._encourage_gold_num = 0   # 钻石鼓舞
        self._last_request_time = 0    # 上次请求时间
        self._fight_times = 0          # 战斗次数
        self._last_fight_time = 0      # 上次战斗结束时间
        self._stage_id = 0             # 当前关卡

    def init_data(self, data):
        """docstring for init_data"""
        self._boss_id = data.get("boss_id", "")
        self._stage_id = data.get("stage_id", 0)
        self._encourage_coin_num = data.get('encourage_coin_num', 0)
        self._encourage_gold_num = data.get('encourage_gold_num', 0)
        self._last_request_time = data.get('last_request_time', 0)
        self._last_fight_time = data.get('last_fight_time', 0)
        self._fight_times = data.get('fight_times', 0)

    def get_stage_info(self):
        stage_info = None
        if self._boss_id == "world_boss":
            stage_info = special_stage_config.get("world_boss_stages").get(self._stage_id)
        else:
            stage_info = special_stage_config.get("mine_boss_stages").get(self._stage_id)
        assert stage_info!=None, "can not get stage info by stageid %s %s" % (self._stage_id, self._boss_id)
        return stage_info

    def reset_info(self):
        """
        如果过期，则重设信息
        """
        stage_info  = self.get_stage_info()
        if self._boss_id != "world_boss":
            return
        time_start, time_end = str_time_period_to_timestamp(stage_info.timeControl)
        if time_start > self._last_request_time or time_end < self._last_request_time:
            self._encourage_coin_num = 0
            self._encourage_gold_num = 0
            self._fight_times = 0
            self._last_fight_time = 0
            self._last_request_time = get_current_timestamp()

    @property
    def boss_id(self):
        return self._boss_id

    @boss_id.setter
    def boss_id(self, value):
        self._boss_id = value

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

    def get_data_dict(self):
        """docstring for get_data_dict"""
        return {'encourage_coin_num': self._encourage_coin_num,
                    'encourage_gold_num': self._encourage_gold_num,
                    'last_request_time': self._last_request_time,
                    'last_fight_time': self._last_fight_time,
                    'fight_times': self._fight_times,
                    'stage_id': self._stage_id,
                    'boss_id': self._boss_id}

    def get_base_config(self):
        if self._boss_id == "world_boss":
            return base_config.get("world_boss")
        else:
            return base_config.get("mine_boss")
