#!/usr/bin/env python
# -*- coding: utf-8 -*-
from shared.db_opear.configs_data import game_configs
from app.game.component.fight.stage_logic import stage_util, base_stage
from gfirefly.server.logobj import logger
from app.game.core.item_group_helper import gain
from shared.utils.const import const
from shared.tlog import tlog_action


xs = 100000


class TravelStageLogic(base_stage.BaseStageLogic):
    """docstring for StageLogic"""
    def __init__(self, player, stage_id):
        super(TravelStageLogic, self).__init__(player, stage_id)

    def check(self):
        """校验关卡是否开启"""
        return {'result': True}

    def get_stage_config(self):
        """docstring for stage_config"""
        return stage_util.get_stage_config(game_configs.stage_config, "travel_fight_stages", self._stage_id)

    def settle(self, result, response, star_num=0):
        """
        战斗结算
        """
        player = self._player
        stage_id = self._stage_id
        #conf = self.get_stage_config()
        if player.travel_component.fight_cache[0] and player.travel_component.fight_cache[1]:
            if player.travel_component.travel.get(player.travel_component.fight_cache[0]):
                stage_cache = player.travel_component.travel.get(player.travel_component.fight_cache[0])
            else:
                logger.error("travel stage id not found")
                response.res.result = False
                response.res.result_no = 800
                return

            event_cache = 0
            for event in stage_cache:
                if event[0] == player.travel_component.fight_cache[1]:
                    event_cache = event
                    break

            if not event_cache:
                logger.error("travel ：event id not found")
                response.res.result = False
                response.res.result_no = 813

                return

        if game_configs.travel_event_config.get('events').get(player.travel_component.fight_cache[1]%xs) and \
                stage_id == game_configs.travel_event_config.get('events').get(player.travel_component.fight_cache[1]%xs).parameter.items()[0][0]:
            if result:
                gain(player, event_cache[1], const.TRAVEL)
            stage_cache.remove(event_cache)
            player.travel_component.fight_cache = [0, 0]
            player.travel_component.save()

        else:
            logger.error('stageid != travel fight cache stage id ')
            response.res.result = False
            response.res.result_no = 817
            return
        tlog_action.log('RoundFlow', player, stage_id, 4, 0, result)
