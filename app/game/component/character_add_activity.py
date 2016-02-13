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

#PROTECT_ESCORT_ACT_PERIOD = 52002
#PROTECT_ESCORT_ACT_EVERY_DAY = 52001
#ROB_ESCORT_ACT_PERIOD = 53002
#ROB_ESCORT_ACT_EVERY_DAY = 53001
#GUILD_BOSS_ACT_PERIOD = 54002
#GUILD_BOSS_ACT_EVERY_DAY = 54001

class CharacterAddActivityComponent(Component):
    """累积活动"""

    def __init__(self, owner):
        super(CharacterAddActivityComponent, self).__init__(owner)
        self._add_act = {}
        #self._act = {}

    def init_data(self, character_info):
        self._add_act = character_info.get('add_act', {})
        logger.debug("add_act %s" % self._add_act)
        if not self._add_act:
            self.new_data()
        self.check_time()

        logger.debug("add_act %s" % self._add_act)

    def check_time(self):
        """docstring for check_time"""
        for act_type, act_info in self._add_act.items():
            for res_type, act_item in act_info.items():
                print(act_item.get("stages", {}))
                for act_id, finished in act_item.get("stages", {}).items():
                    act_config_item = game_configs.activity_config.get(act_id)
                    if not self._owner.act.is_activiy_open(act_id):
                        # 如果不在活动期间内，则清空属性
                        act_item["num"] = 0
                        act_item["finished"] = False
                        act_item["last_time"] = 0

    def save_data(self):
        activity = tb_character_info.getObj(self.owner.base_info.id)
        activity.hset('add_act', self._add_act)

    def new_data(self):
        for act_type in [64, 66]:
            self._add_act[act_type] = {}
            act_info = self._add_act[act_type]
            acts = game_configs.activity_config.get(act_type, [])
            for act in acts:
                res_type = act.parameterE.keys()[0]
                if res_type not in act_info:
                    act_item = dict(num=0, last_time=0)
                    act_item["stages"] = {}
                    act_item["stages"][act.id] = False
                    act_info[res_type] = act_item
                else:
                    act_item = act_info[res_type]
                    act_item["stages"][act.id] = False

        self.save_data()

        return {'add_act': self._add_act}

    @property
    def act_info(self):
        return self._add_act

    @act_info.setter
    def act_info(self, value):
        self._add_act = value

    def get_reward(self, act_id, response):
        """docstring for get_reward"""

        act_config_item = game_configs.activity_config.get(act_id)
        res_type = act_config_item.parameterE.keys()[0]
        act_item = self._add_act[act_config_item.type][res_type]
        logger.debug("act_item %s" % act_item)
        if act_item.get("num") < int(act_config_item.parameterA):
            logger.error("activity times not enough!")
            return dict(result=False, result_no=260101)
        stage_info = act_item["stages"]
        if act_id not in stage_info:
            logger.error("can not find activity!")
            return dict(result=False, result_no=260102)
        if stage_info.get(act_id):
            logger.error("activity has finished!")
            return dict(result=False, result_no=260103)
        stage_info[act_id] = True
        data = gain(self._owner, act_config_item.reward, const.ADD_ACTIVITY)
        get_return(self._owner, data, response.gain)
        self.save_data()
        return dict(result=True)

    def add_currency(self, res_type, num):
        """
        累积消耗货币:元宝，银两，等
        """
        self.add_num(64, res_type, num)

    def add_pick_card(self, res_type, num):
        """
        抽取武将，神将，良将等
        """
        self.add_num(66, res_type, num)

    def add_num(self, act_type, res_type, num):
        """docstring for add_times"""
        if res_type not in self._add_act[act_type]:
            self._add_act[act_type][res_type] = dict(num=0, last_time=0, stages={})

        act_item = self._add_act[act_type][res_type]
        logger.debug("act_item %s" % act_item)

        act_item["num"] = act_item.get("num", 0) + num
        act_item["last_time"] = int(get_current_timestamp())
        #acts = game_configs.activity_config.get(act_type, [])
        #for act in acts:
            #if act.parameterE.keys()[0] == res_type:
                #if act.id not in act_item["stages"]:
                    #act_item["stages"][act.id] = False
        #logger.debug("act_id %s act_info %s" % (act_id, act_info))
        self.save_data()

    def update_pb(self, response):
        """docstring for update_pb"""
        for act_type, act_info in self._add_act.items():
            act_pb = response.add_act_info.add()
            act_pb.act_type = act_type
            for res_type, act_item in act_info.items():
                detail_info_pb = act_pb.detail_info.add()
                detail_info_pb.res_type = int(res_type)
                print act_item.get('num'), '==================================act_item_num'
                detail_info_pb.num = int(act_item.get("num"))
                for act_id, finished in act_item.get("stages", {}).items():
                    act_item_pb = detail_info_pb.item.add()
                    act_item_pb.act_id = act_id
                    act_item_pb.finished = finished


    #required int32 act_type = 1; // 类型
    #required int32 res_type = 2; // 资源类型
    #required int32 num = 3;      // 当前数量
    #repeated AddActivityItem item = 4; //
