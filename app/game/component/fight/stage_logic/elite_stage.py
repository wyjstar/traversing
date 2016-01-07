#!/usr/bin/env python
# -*- coding: utf-8 -*-
from shared.db_opear.configs_data import game_configs
from app.game.component.fight.stage_logic import stage_util, base_stage
from gfirefly.server.logobj import logger
import time
from shared.tlog import tlog_action
from app.game.core.task import hook_task, CONDITIONId


class EliteStageLogic(base_stage.BaseStageLogic):
    """docstring for 精英关卡"""
    def __init__(self, player, stage_id):
        super(EliteStageLogic, self).__init__(player, stage_id)

    def check(self):
        """校验关卡是否开启"""
        player = self._player
        conf = self.get_stage_config()
        tm_time = time.localtime(player.stage_component.elite_stage_info[2])

        act_confs = game_configs.activity_config.get(24, [])
        is_open = 0
        add_times = 0
        act_conf1 = None
        for act_conf in act_confs:
            if player.act.is_activiy_open(act_conf.id):
                is_open = 1
                act_conf1 = act_conf
                break
        if is_open:
            add_times = act_conf1.parameterA

        max_times = game_configs.base_config.get('eliteDuplicateTime') + add_times
        shengxia_times = max_times - conf.timesExpend - player.stage_component.elite_stage_info[0]

        if tm_time.tm_yday == time.localtime().tm_yday \
                and shengxia_times < 0:
            logger.error("精英关卡开始战斗出错: %s" % 805)
            return {'result': False, 'result_no': 805}  # 805 次数不足
        return {'result': True}

    def get_stage_config(self):
        """get_stage_config"""
        return stage_util.get_stage_config(game_configs.special_stage_config, "elite_stages", self._stage_id)

    def settle(self, result, response, star_num=0):
        """docstring for 结算"""
        player = self._player
        stage_id = self._stage_id
        conf = self.get_stage_config()
        tm_time = time.localtime(player.stage_component.elite_stage_info[2])
        if result:
            if tm_time.tm_yday == time.localtime().tm_yday:
                player.stage_component.elite_stage_info[0] += conf.timesExpend
            else:
                player.stage_component.elite_stage_info = [conf.timesExpend, 0, int(time.time())]
            stage_util.settle(player, result, response, conf, star_num=star_num)
            # hook task
            hook_task(player, CONDITIONId.STAGE, stage_id)
            hook_task(player, CONDITIONId.ANY_ELITE_STAGE, 1)
            tlog_action.log('RoundFlow', player, stage_id, 2, 0, 1)
        else:
            tlog_action.log('RoundFlow', player, stage_id, 2, 0, 0)
