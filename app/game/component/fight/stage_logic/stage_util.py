#!/usr/bin/env python
# -*- coding: utf-8 -*-
from app.game.core.lively import task_status
from gfirefly.server.globalobject import GlobalObject
from app.game.core.item_group_helper import gain, get_return


remote_gate = GlobalObject().remote['gate']

def get_stage_config(stage_config, stage_type, stage_id):
    """get stage config util
    stage_config: stage_config or special_stage_config
    stage_type: travel_stages,travel_fight_stages,mine_stages, stages,
                elite_stages,act_stages,boss_stages
    """
    print type(stage_id), stage_id
    stage_info = stage_config.get(stage_type).get(stage_id)
    assert stage_info!=None, ("can not find stage info by stage id %s in %s" % (stage_id, type(stage_config)))
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



