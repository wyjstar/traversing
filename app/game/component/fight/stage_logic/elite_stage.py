#!/usr/bin/env python
# -*- coding: utf-8 -*-
from shared.db_opear.configs_data.game_configs import special_stage_config, vip_config
from app.game.component.fight.stage_logic import stage_util, base_stage
from gfirefly.server.logobj import logger
import time
from app.game.component.achievement.user_achievement import EventType
from app.game.component.achievement.user_achievement import CountEvent


class EliteStageLogic(base_stage.BaseStageLogic):
    """docstring for 精英关卡"""
    def __init__(self, player, stage_id):
        super(EliteStageLogic, self).__init__(player, stage_id)

    def check(self):
        """校验关卡是否开启"""
        player = self._player
        conf = self.get_stage_config()
        tm_time = time.localtime(player.stage_component.elite_stage_info[1])
        if tm_time.tm_mday == time.localtime().tm_mday \
            and vip_config.get(player.base_info.vip_level).eliteCopyTimes - player.stage_component.elite_stage_info[0] < conf.timesExpend:
            logger.error("精英关卡开始战斗出错: %s" % 805)
            return {'result': False, 'result_no': 805}  # 805 次数不足
        return {'result': True}

    def get_stage_config(self):
        """get_stage_config"""
        return stage_util.get_stage_config(special_stage_config, "elite_stages", self._stage_id)

    def settle(self, result, response):
        """docstring for 结算"""
        player = self._player
        stage_id = self._stage_id
        conf = self.get_stage_config()
        tm_time = time.localtime(player.stage_component.elite_stage_info[1])
        if tm_time.tm_mday == time.localtime().tm_mday:
            player.stage_component.elite_stage_info[0] += conf.timesExpend
        else:
            player.stage_component.elite_stage_info = [conf.timesExpend, int(time.time())]
        lively_event = CountEvent.create_event(EventType.STAGE_2, 1, ifadd=True)
        stage_util.settle(player, result, response, lively_event, conf)

