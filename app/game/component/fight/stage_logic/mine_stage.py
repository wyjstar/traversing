#!/usr/bin/env python
# -*- coding: utf-8 -*-
from shared.db_opear.configs_data.game_configs import special_stage_config
from app.game.component.fight.stage_logic import stage_util, base_stage
#from gfirefly.server.logobj import logger
import time
from app.game.component.achievement.user_achievement import EventType
from app.game.component.achievement.user_achievement import CountEvent

class MineStageLogic(base_stage.BaseStage):
    """docstring for 精英关卡"""
    def __init__(self, player, stage_id):
        super(MineStageLogic, self).__init__(player, stage_id)

    def check(self):
        """校验关卡是否开启"""
        return {'result': True}

    def get_stage_config(self, stage_id):
        """get_stage_config"""
        return stage_util.get_stage_config(special_stage_config, "elite_stages", stage_id)

    def settle(self, result, response):
        """docstring for 结算"""
        player = self._player
        stage_id = self._stage_id
        conf = self.get_stage_config(stage_id)
