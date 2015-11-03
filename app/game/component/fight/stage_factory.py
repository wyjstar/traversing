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


def get_stage_by_stage_type(stage_type, stage_id, player):
    """根据关卡类型返回对应的关卡对象"""
    if stage_type == 1:  # 普通关卡
        return StageLogic(player, stage_id)
    elif stage_type == 14:  # 普通关卡
        return StageLogic(player, stage_id)
    elif stage_type == 6:  # 精英关卡
        return EliteStageLogic(player, stage_id)
    elif stage_type == 4:  # coin 活动关卡
        return ActStageLogic(player, stage_id, 4)
    elif stage_type == 5:  # exp 活动关卡
        return ActStageLogic(player, stage_id, 5)
    elif stage_type == 10:  # 游历
        return TravelStageLogic(player, stage_id)
    elif stage_type == 8:  # 秘境
        return BaseStageLogic(player, stage_id)
    elif stage_type == 7:  # 世界boss
        return WorldBossStageLogic(player, stage_id)
    assert False, "stage type %s not defined." % stage_type
