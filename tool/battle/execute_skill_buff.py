#!/usr/bin/env python
# -*- coding: utf-8 -*-

import random
from configs_data.game_configs import base_config



skill_types = {}

def perform_hit(skill_buff_info, hit, dodge):
    """
    当主技能为攻击技能时，才计算命中率
    hit: 攻方命中率
    dodge: 守方闪避率
    """
    if skill_buff_info.effectId in [1, 2, 3]:
        if get_random_int(1, 100) < hit - dodge:
            return True
    return False


def execute_skill_buff(attacker, target, skill_buff_info):
    """
    执行技能［1，2，3，26］
    """
    print "    攻方 no(%d), hero_no(%d), name(%s), hp(%f), mp(%f), buff(%s)" % (attacker.slot_no, attacker.hero_no, attacker.hero_name, attacker.hp, attacker.mp, attacker.buff_manager)
    print "    守方 no(%d), hero_no(%d), name(%s), hp(%f), mp(%f), buff(%s)" % (target.slot_no, target.hero_no, target.hero_name, target.hp, target.mp, target.buff_manager)

    is_cri = False # 是否暴击
    is_block = False # 是否格挡

    if get_random_int(1, 100) < attacker.cri - target.ductility:
        is_cri = True

    if get_random_int(1, 100) < attacker.block:
        is_block = True

    k1 = attacker.atk # 攻方总实际攻击力
    k2 = 0            # 守方总物理或者魔法防御
    if skill_buff_info.effectId == 1:
        k2 = target.physical_def
    elif skill_buff_info.effectId == 2:
        k2 = target.magic_def

    k3_k4 = base_config.get("a3") # 基础伤害值调整参数
    k3 = k3_k4[0]
    k4 = k3_k4[1]

    base_demage_value = (k1*k1/(k1+k3*k2))*k4              # 基础伤害值
    cri_coeff = (attacker.cri_coeff - target.cri_ded_coeff)/100  # 暴击伤害系数
    block_demage_coeff = base_config.get("a4")             # 格挡受伤比参数
                                                           #
    level_coeff = 1                                        # 等级压制系数
    k1 = attacker.level                                    # 攻方等级
    k2 = target.level                                      # 守方等级
    temp = base_config.get("a5")                           # 等级压制调整参数
    k3, k4, k5 = temp[0], temp[1], temp[2]                 # 等级压制调整参数
    if (k2-k1) > 5:
        if (1-k3/k4*((k2-k1)*(k2-k1)+(k2-k1)+k5))>0.1:
            level_coeff = 1-k3/k4*((k2-k1)*(k2-k1)+(k2-k1)+k5)
        else:
            level_coeff = 0.1
    else:
        level_coeff = 1
                                                           #
    temp = base_config.get("a6")                           # 伤害浮动调整参数
    k1, k2 = temp[0], temp[1]                              #
    demage_fluct_coeff = random.uniform(k1, k2)            # 伤害浮动系数

    if not is_cri:
        cri_coeff = 1

    if not is_block:
        block_demage_coeff = 1

    total_demage = base_demage_value * cri_coeff * block_demage_coeff * level_coeff * demage_fluct_coeff  # 总伤害值
    total_treat = base_demage_value * cri_coeff                                                           # 总治疗值
                                                                                                          #
    actual_demage = 0                                                                                     # 实际伤害值
    actual_treat = 0                                                                                      # 实际治疗值

    if (skill_buff_info.effectId == 1 or skill_buff_info.effectId == 2) and skill_buff_info.valueType == 1:
        actual_demage = total_demage + skill_buff_info.valueEffect + skill_buff_info.levelEffectValue * attacker.level
        #print actual_demage, total_demage, skill_buff_info.valueEffect, skill_buff_info.levelEffectValue, attacker.level, type(skill_buff_info.valueType)

    elif skill_buff_info.effectId == 26 and skill_buff_info.valueType == 1:
        actual_treat = total_treat + skill_buff_info.valueEffect + skill_buff_info.levelEffectValue * attacker.level

    elif (skill_buff_info.effectId == 1 or skill_buff_info.effectId == 2) and skill_buff_info.valueType == 2:
        actual_demage = total_demage * (skill_buff_info.valueEffect/100 + skill_buff_info.levelEffectValue/100 * attacker.level)
        #print actual_demage, total_demage, skill_buff_info.valueEffect, skill_buff_info.levelEffectValue, attacker.level, skill_buff_info.valueType
        #print skill_buff_info.valueEffect/100 + skill_buff_info.levelEffectValue/100 * attacker.level

    elif skill_buff_info.effectId == 26 and skill_buff_info.valueType == 2:
        actual_treat  = total_treat * (skill_buff_info.valueEffect/100 + skill_buff_info.levelEffectValue/100 * attacker.level)

    elif skill_buff_info.effectId == 3 and skill_buff_info.valueType == 2:
        actual_demage = total_demage*skill_buff_info.valueEffect/100

    elif skill_buff_info.effectId == 3 and skill_buff_info.valueType == 1:
        actual_demage = attacker.level*skill_buff_info.valueEffect/100
    target.hp -= actual_demage
    target.hp += actual_treat
    print "    技能ID（%d）,暴击（%s），格挡（%s），基础伤害值(%s)，暴击伤害系数(%s)，等级压制系数(%s)，伤害浮动系数(%s)，\
            总伤害值(%s)，总治疗值(%s)，攻方实际伤害值(%s)，攻方实际治疗值(%s)" \
    % (skill_buff_info.id, is_cri, is_block, base_demage_value, cri_coeff, level_coeff, demage_fluct_coeff,
            total_demage, total_treat, actual_demage, actual_treat)
    return is_block, is_cri

def get_random_int(start, end):
    return random.randint(start, end)

def execute_mp(target, skill_buff_info):
    if skill_buff_info.effectId == 8:
        target.mp += skill_buff_info.valueEffect
    elif skill_buff_info.effectId == 9:
        target.mp -= skill_buff_info.valueEffect




