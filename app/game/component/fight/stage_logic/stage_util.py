#!/usr/bin/env python
# -*- coding: utf-8 -*-
from gfirefly.server.globalobject import GlobalObject
from app.game.core.item_group_helper import gain, get_return
from shared.utils.const import const
import random
from app.game.core.hero_chip import HeroChip
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from shared.tlog import tlog_action


remote_gate = GlobalObject().remote.get('gate')


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


def settle(player, result, response, conf, stage_type=0, star_num=0):
    """docstring for settle"""
    # 保存关卡信息
    player.stage_component.save_data()

    # 保存活跃度

    # 增加玩家和武将经验，增加金币
    if not result and stage_type not in [4, 5]:
        return

    player.finance.coin += conf.currency
    player.finance.save_data()
    player.base_info.addexp(conf.playerExp, const.STAGE)
    player.base_info.save_data()
    for (slot_no, lineUpSlotComponent) in player.line_up_component.line_up_slots.items():
        hero = lineUpSlotComponent.hero_slot.hero_obj
        if hero:
            beforelevel = hero.level
            hero.upgrade(conf.HeroExp, player.base_info.level)
            afterlevel = hero.level
            changelevel = afterlevel-beforelevel
            hero.save_data()
            if changelevel:
                tlog_action.log('HeroUpgrade', player, hero.hero_no, changelevel, afterlevel)
            hero.save_data()

    # 更新等级相关属性

    # 构造掉落
    settlement_drops = player.fight_cache_component.fighting_settlement(result, star_num)

    is_open = 0
    if stage_type == 1:
        act_confs = game_configs.activity_config.get(27, [])
        part_multiple = []
        for act_conf in act_confs:
            if player.base_info.is_activiy_open(act_conf.id):
                is_open = 1
                part_multiple = [act_conf.parameterC, act_conf.parameterA]
                break
    if is_open:
        data = gain(player, settlement_drops, const.STAGE, part_multiple=part_multiple)
    else:
        data = gain(player, settlement_drops, const.STAGE)
    get_return(player, data, response.drops)

    # 乱入武将按概率获取碎片
    break_stage_id = player.fight_cache_component.break_stage_id
    if break_stage_id:
        break_stage_info = game_configs.stage_break_config.get(break_stage_id)
        ran = random.random()
        if ran <= break_stage_info.reward_odds:
            logger.debug("break_stage_info=============%s %s" % (break_stage_info.reward, 1))
            data = gain(player, break_stage_info.reward, const.STAGE)
            get_return(player, data, response.drops)
