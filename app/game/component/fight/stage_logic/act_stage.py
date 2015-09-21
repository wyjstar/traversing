#!/usr/bin/env python
# -*- coding: utf-8 -*-
from shared.db_opear.configs_data import game_configs
from app.game.component.fight.stage_logic import stage_util, base_stage
from gfirefly.server.logobj import logger
import time
from shared.tlog import tlog_action
from app.game.core.task import hook_task, CONDITIONId

attr_type = {1:"hpHero",
             2:"atkHero",
             3:"physicalDefHero",
             4:"magicDefHero",
             5:"hitHero",
             6:"dodgeHero",
             7:"criHero",
             8:"criCoeffHero",
             9:"criDedCoeffHero",
             10:"blockHero",
             11:"ductilityHero"}

class ActStageLogic(base_stage.BaseStageLogic):
    """docstring for 活动关卡"""
    def __init__(self, player, stage_id, stage_type):
        super(ActStageLogic, self).__init__(player, stage_id)
        self.stage_type = stage_type

    def check(self):
        """校验关卡是否开启"""
        player = self._player
        conf = self.get_stage_config()
        if (self.stage_type == 4 and player.base_info.activity_copy_times1 - player.stage_component.act_stage_info[0] < conf.timesExpend) or\
            (self.stage_type == 5 and player.base_info.activity_copy_times2 - player.stage_component.act_stage_info[1] < conf.timesExpend):

            logger.error("活动关卡开始战斗出错: %s" % 805)
            return {'result': False, 'result_no': 805}  # 805 次数不足
        if conf.weeklyControl:
            if time.localtime().tm_wday == 6:
                wday = 0
            else:
                wday = time.localtime().tm_wday + 1

            if not conf.weeklyControl[wday]:
                logger.error('week error,804:%s', time.localtime().tm_wday)
                return {'result': False, 'result_no': 804}  # 804 不在活动时间内

        # 时间限制
        open_time = time.mktime(time.strptime(conf.open_time, '%Y-%m-%d %H:%M'))
        close_time = time.mktime(time.strptime(conf.close_time, '%Y-%m-%d %H:%M'))
        if not open_time <= time.time() <= close_time:
            logger.error('time error,804,:%s', time.time())
            return {'result': False, 'result_no': 804}  # 804 不在活动时间内
        return {'result': True}

    def get_stage_config(self):
        """get_stage_config"""
        return stage_util.get_stage_config(game_configs.special_stage_config, "act_stages", self._stage_id)

    def settle(self, result, response):
        """docstring for 结算"""
        player = self._player
        conf = self.get_stage_config()
        stage_id = self._stage_id
        if result:
            if self.stage_type == 4:
                player.stage_component.act_stage_info[0] += conf.timesExpend
            elif self.stage_type == 5:
                player.stage_component.act_stage_info[1] += conf.timesExpend
            stage_util.settle(player, result, response, conf)
            hook_task(player, CONDITIONId.STAGE, stage_id)
            hook_task(player, CONDITIONId.ANY_ACT_STAGE, 1)
            tlog_action.log('RoundFlow', player, stage_id, 3, 0, 1)
        else:
            tlog_action.log('RoundFlow', player, stage_id, 3, 0, 0)

    def update_hero_self_attr(self, hero_no, hero_self_attr, player):
        """
        update hero self attr, plus some attr
        """
        lucky_heros = player.stage_component._act_lucky_heros.get(self._stage_id, {}).get('heros', {})
        lucky_add = 0

        print("hero_self_attr_origin", hero_self_attr)
        for k, v in lucky_heros.items():
            if v.get("hero_no") == hero_no:
                lucky_hero_id = v.get("lucky_hero_info_id")
                logger.debug("lucky_hero_id %s %s" % (lucky_hero_id, hero_no))
                lucky_hero_info = game_configs.lucky_hero_config.get(lucky_hero_id)
                for attr_no, attr_info in lucky_hero_info.attr.items():
                    attr_name = attr_type.get(int(attr_no))
                    if attr_info[0] == 2:
                        lucky_add = hero_self_attr[attr_name] * attr_info[1]
                    elif attr_info[0] == 1:
                        lucky_add = attr_info[1]
                    logger.debug("===========%s %s" % (hero_self_attr[attr_name], lucky_add))
                    hero_self_attr[attr_name] = hero_self_attr[attr_name] + lucky_add
        print("hero_self_attr_after", hero_self_attr)

        return hero_self_attr
