# -*- coding:utf-8 -*-
"""
created by server on 14-8-26
"""
from gfirefly.server.logobj import logger
from app.game.redis_mode import tb_character_info
from app.game.component.Component import Component
from shared.db_opear.configs_data import game_configs
from app.game.core.item_group_helper import gain, get_return
from shared.utils.const import const
from shared.utils.date_util import get_current_timestamp, days_to_current

PROTECT_ESCORT_ACT_PERIOD = 52002
PROTECT_ESCORT_ACT_EVERY_DAY = 52001
ROB_ESCORT_ACT_PERIOD = 53002
ROB_ESCORT_ACT_EVERY_DAY = 53001
GUILD_BOSS_ACT_PERIOD = 54002
GUILD_BOSS_ACT_EVERY_DAY = 54001

class CharacterGuildActivityComponent(Component):
    """CharacterGuildActivity"""

    def __init__(self, owner):
        super(CharacterGuildActivityComponent, self).__init__(owner)
        self._act_info = {}

    def init_data(self, character_info):
        self._act_info = character_info.get('guild_activity', {})
        logger.debug("guild_activity %s" % self._act_info)
        if not self._act_info:
            self.new_data()
        self.check_time()

        logger.debug(self._act_info)

    def check_time(self):
        """docstring for check_time"""
        for act_id, act_info in self._act_info.items():
            #act_item = game_configs.activity_config.get(act_id)
            if not self.owner.act.is_activiy_open(act_id):
                logger.debug("act %s not in the open time")
            # if act_item.timeStart > get_current_timestamp() or act_item.timeEnd < get_current_timestamp():
                # 如果不在活动期间内，则清空属性
                act_info["act_times"] = 0
                act_info["finished"] = False
                act_info["last_time"] = 0
            if act_id in [PROTECT_ESCORT_ACT_EVERY_DAY, ROB_ESCORT_ACT_EVERY_DAY, GUILD_BOSS_ACT_EVERY_DAY]:
                if days_to_current(act_info.get("last_time")) > 0:
                    act_info["act_times"] = 0
                    act_info["finished"] = False
                    act_info["last_time"] = 0

    def save_data(self):
        activity = tb_character_info.getObj(self.owner.base_info.id)
        activity.hset('guild_activity', self._act_info)

    def new_data(self):
        for act_type in [52, 53, 54]:
            acts = game_configs.activity_config.get(act_type, [])
            for act in acts:
                self._act_info[act.id] = dict(act_times=0, finished=False, last_time=0)
        self.save_data()

        return {'guild_activity': self._act_info}


    @property
    def act_info(self):
        return self._act_info

    @act_info.setter
    def act_info(self, value):
        self._act_info = value

    def get_reward(self, act_id, response):
        """docstring for get_reward"""

        act_item = game_configs.activity_config.get(act_id)
        act_info = self._act_info[act_id]
        if act_info.get("act_times") < int(act_item.parameterA):
            logger.error("activity times not enough!")
            return dict(result=False, result_no=250101)
        if act_info.get("finished"):
            logger.error("activity has finished!")
            return dict(result=False, result_no=250102)
        act_info["finished"] = True
        data = gain(self._owner, act_item.reward, const.GUILD_ACTIVITY)
        get_return(self._owner, data, response.gain)
        self.save_data()
        return dict(result=True)

    def add_protect_escort_times(self, arg):
        self.add_times(PROTECT_ESCORT_ACT_PERIOD, arg)
        self.add_times(PROTECT_ESCORT_ACT_EVERY_DAY, arg)
    def add_rob_escort_times(self, arg):
        self.add_times(ROB_ESCORT_ACT_PERIOD, arg)
        self.add_times(ROB_ESCORT_ACT_EVERY_DAY, arg)
    def add_guild_boss_times(self, arg):
        self.add_times(GUILD_BOSS_ACT_PERIOD, arg)
        self.add_times(GUILD_BOSS_ACT_EVERY_DAY, arg)

    def add_times(self, act_id, arg):
        """docstring for add_times"""
        if not self.owner.act.is_activiy_open(act_id):
            return
        act_item = game_configs.activity_config.get(act_id)
        if arg not in act_item.parameterC:
            logger.debug("cant meet the parameterC %s arg %s act_id %s" % (act_item.parameterC, arg, act_id))
            return
        act_info = self._act_info[act_id]
        act_info["act_times"] = act_info["act_times"] + 1
        act_info["last_time"] = int(get_current_timestamp())
        logger.debug("act_id %s act_info %s" % (act_id, act_info))
        self.save_data()

    def update_pb(self, response):
        """docstring for update_pb"""
        logger.debug("act_info %s" % self._act_info)
        for act_id, act_info in self._act_info.items():
            #act_item = game_configs.activity_config.get(act_id)
            # if act_item.timeStart < get_current_timestamp() and act_item.timeEnd > get_current_timestamp():
            if self.owner.act.is_activiy_open(act_id):
                act_pb = response.acts.add()
                act_pb.act_id = act_id
                act_pb.act_times = act_info.get("act_times")
                act_pb.finished = act_info.get("finished")




