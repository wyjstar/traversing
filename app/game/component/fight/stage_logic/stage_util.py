#!/usr/bin/env python
# -*- coding: utf-8 -*-
from app.game.core.lively import task_status
from gfirefly.server.globalobject import GlobalObject
from app.game.core.item_group_helper import gain, get_return
from app.game.component.fight.stage import StageLogic
from app.game.component.fight.elite_stage import EliteStageLogic
from app.game.component.fight.act_stage import ActStageLogic
from app.game.component.fight.travel_stage import TravelStageLogic
from app.game.component.fight.mine_stage import MineStageLogic

remote_gate = GlobalObject().remote['gate']

def get_stage_config(stage_config, stage_type, stage_id):
    """get stage config util
    stage_config: stage_config or special_stage_config
    stage_type: travel_stages,travel_fight_stages,mine_stages, stages,
                elite_stages,act_stages,boss_stages
    """
    stage_info = stage_config.get(stage_type).get(stage_id)
    assert stage_info==None, ("can not find stage info by stage id %s in %s" % (stage_id, stage_config.__class__))
    return stage_info

def settle(player, result, response, lively_event, conf):
    """docstring for settle"""
    # 保存关卡信息
    player.stage_component.update()

    # 增加玩家和武将经验，增加金币
    for (slot_no, lineUpSlotComponent) in player.line_up_component.line_up_slots.items():
        print lineUpSlotComponent,
        hero = lineUpSlotComponent.hero_slot.hero_obj
        if hero:
            hero.upgrade(conf.HeroExp)
    player.finance.coin += conf.currency
    player.level.addexp(conf.playerExp)
    player.save_data()

    # 构造掉落
    settlement_drops = player.fight_cache_component.fighting_settlement(result)
    data = gain(player, settlement_drops)
    get_return(player, data, response.drops)

    # 保存活跃度
    tstatus = player.tasks.check_inter(lively_event)
    if tstatus:
        task_data = task_status(player)
        remote_gate.push_object_remote(1234, task_data, [player.dynamic_id])


# 关卡类型:1.普通关卡2.精英关卡3.活动关卡4.游历关卡5.秘境关卡
COMMON_STAGE = 1
ELITE_STAGE = 2
ACT_STAGE = 3
TRAVEL_STAGE = 4
MINE_STAGE = 5

def get_stage_by_stage_type(stage_type, stage_id, player):
    """根据关卡类型返回对应的关卡对象"""
    if stage_type == COMMON_STAGE:
        return StageLogic(player, stage_id)
    elif stage_type == ELITE_STAGE:
        return EliteStageLogic(player, stage_id)
    elif stage_type == ACT_STAGE:
        return ActStageLogic(player, stage_id)
    elif stage_type == TRAVEL_STAGE:
        return TravelStageLogic(player, stage_id)
    elif stage_type == MINE_STAGE:
        return MineStageLogic(player, stage_id)
    assert False, "stage type %s not defined." % stage_type
