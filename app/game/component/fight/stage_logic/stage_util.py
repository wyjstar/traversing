#!/usr/bin/env python
# -*- coding: utf-8 -*-
from app.game.core.lively import task_status
from gfirefly.server.globalobject import GlobalObject
from app.game.core.item_group_helper import gain, get_return
from shared.utils.const import const


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
    player.stage_component.save_data()

    # 保存活跃度
    tstatus = player.tasks.check_inter(lively_event)
    if tstatus:
        task_data = task_status(player)
        remote_gate.push_object_remote(1234, task_data, [player.dynamic_id])

    # 增加玩家和武将经验，增加金币
    if not result:
        return

    for (slot_no, lineUpSlotComponent) in player.line_up_component.line_up_slots.items():
        print lineUpSlotComponent,
        hero = lineUpSlotComponent.hero_slot.hero_obj
        if hero:
            hero.upgrade(conf.HeroExp, player.base_info.level)
            hero.save_data()
    player.finance.coin += conf.currency
    player.base_info.addexp(conf.playerExp)
    player.base_info.save_data()

    # 更新等级相关属性
    player.line_up_component.update_slot_activation()
    player.line_up_component.save_data()

    # 构造掉落
    settlement_drops = player.fight_cache_component.fighting_settlement(result)
    data = gain(player, settlement_drops, const.STAGE)
    get_return(player, data, response.drops)






