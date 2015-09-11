# -*- coding:utf-8 -*-
"""
created by server on 14-12-9下午6:00.
"""

from app.game.component.fight.stage_logic.stage import StageLogic
from app.game.component.fight.stage_logic.elite_stage import EliteStageLogic
from app.game.component.fight.stage_logic.act_stage import ActStageLogic
from app.game.component.fight.stage_logic.travel_stage import TravelStageLogic
from app.game.component.fight.stage_logic.base_stage import BaseStageLogic
from app.game.component.fight.stage_logic.world_boss_stage import WorldBossStageLogic

# 关卡类型:1.普通关卡2.精英关卡3.活动关卡4.游历关卡5.秘境关卡
COMMON_STAGE = 1
ELITE_STAGE = 2
ACT_STAGE = 3
TRAVEL_STAGE = 4
MINE_STAGE = 5
BOSS_STAGE = 6
ACT_COIN_STAGE = 7
ACT_EXP_STAGE = 8

def get_stage_by_stage_type(stage_type, stage_id, player):
    """根据关卡类型返回对应的关卡对象"""
    if stage_type == COMMON_STAGE:
        return StageLogic(player, stage_id)
    elif stage_type == ELITE_STAGE:
        return EliteStageLogic(player, stage_id)
    elif stage_type == ACT_COIN_STAGE:
        return ActStageLogic(player, stage_id, 4)
    elif stage_type == ACT_EXP_STAGE:
        return ActStageLogic(player, stage_id, 5)
    elif stage_type == TRAVEL_STAGE:
        return TravelStageLogic(player, stage_id)
    elif stage_type == MINE_STAGE:
        return BaseStageLogic(player, stage_id)
    elif stage_type == BOSS_STAGE:
        return WorldBossStageLogic(player, stage_id)
    assert False, "stage type %s not defined." % stage_type
