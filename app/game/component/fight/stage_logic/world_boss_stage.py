#!/usr/bin/env python
# -*- coding: utf-8 -*-
from shared.db_opear.configs_data import game_configs
from app.game.component.fight.stage_logic import stage_util, base_stage
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import GlobalObject
import cPickle
from shared.utils.const import const

remote_gate = GlobalObject().remote.get('gate')


class WorldBossStageLogic(base_stage.BaseStageLogic):
    """docstring for 世界boss"""
    def __init__(self, player, stage_id):
        super(WorldBossStageLogic, self).__init__(player, stage_id)
    def check(self):
        """校验关卡是否开启"""
        return {'result': True}
    def get_stage_config(self):
        """get_stage_config"""
        return stage_util.get_stage_config(game_configs.special_stage_config, "elite_stages", self._stage_id)
    def update_hero_self_attr(self, hero_no, hero_self_attr, player):
        """
        update hero self attr, plus some attr
        """
        lucky_heros = cPickle.loads(remote_gate['world'].get_lucky_heros_remote())
        lucky_add = 0

        print("hero_self_attr_origin", hero_self_attr)
        for k, v in lucky_heros.items():
            if v.get("hero_no") == hero_no:
                lucky_hero_id = v.get("lucky_hero_info_id")
                logger.debug("lucky_hero_id %s %s" % (lucky_hero_id, hero_no))
                lucky_hero_info = game_configs.lucky_hero_config.get(lucky_hero_id)
                for attr_no, attr_info in lucky_hero_info.attr.items():
                    attr_name = const.ATTR_TYPE.get(int(attr_no))
                    if attr_info[0] == 2:
                        lucky_add = hero_self_attr[attr_name] * attr_info[1]
                    elif attr_info[0] == 1:
                        lucky_add = attr_info[1]
                    logger.debug("===========%s %s" % (hero_self_attr[attr_name], lucky_add))
                    hero_self_attr[attr_name] = hero_self_attr[attr_name] + lucky_add
        print("hero_self_attr_after", hero_self_attr)

        return hero_self_attr
