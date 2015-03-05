#!/usr/bin/env python
# -*- coding: utf-8 -*-
from shared.db_opear.configs_data import game_configs
from app.game.component.fight.stage_logic import stage_util, base_stage
from gfirefly.server.logobj import logger
import time
from app.game.component.achievement.user_achievement import EventType
from app.game.component.achievement.user_achievement import CountEvent


class StageLogic(base_stage.BaseStageLogic):
    """docstring for 普通关卡"""
    def __init__(self, player, stage_id):
        super(StageLogic, self).__init__(player, stage_id)

    def check(self):
        """校验关卡是否开启"""
        player = self._player
        stage_id = self._stage_id
        conf = self.get_stage_config()

        state = player.stage_component.check_stage_state(self._stage_id)
        if state == -2:
            logger.error("普通关卡%s开始战斗出错:%s" % (stage_id,803))
            return {'result': False, 'result_no': 803}  # 803 未开启
        if time.localtime(player.stage_component.stage_up_time).tm_yday == time.localtime().tm_yday:
            if player.stage_component.get_stage(stage_id).attacks >= conf.limitTimes:
                logger.error("本次关卡%s攻击次数不足: %s" % (stage_id,810))
                return {'result': False, 'result_no': 810}  # 810 本关卡攻击次数不足
        return {'result': True}

    def get_stage_config(self):
        """docstring for stage_config"""
        return stage_util.get_stage_config(game_configs.stage_config, "stages", self._stage_id)

    def settle(self, result, response):
        """
        战斗结算
        """
        player = self._player
        stage_id = self._stage_id
        conf = self.get_stage_config()

        # todo: 更新战斗次数
        # 体力
        if result:
            player.stamina.stamina -= conf.vigor
            player.stamina.save_data()

        # 活跃度
        lively_event = CountEvent.create_event(EventType.STAGE_1, 1, ifadd=True)
        # 结算
        stage_util.settle(player, result, response, lively_event, conf)
