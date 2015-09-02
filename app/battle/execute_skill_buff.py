#!/usr/bin/env python
# -*- coding: utf-8 -*-

import random
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger_cal
from random_with_seed import get_random_int


skill_types = {}
def check_trigger(buff_info):
    all_vars = dict(triggerRate=buff_info.triggerRate,
                    random=get_random_int(0, 99))
    is_trigger_formula = game_configs.formula_config.get("isTrigger").get("formula")
    assert is_trigger_formula!=None, "isTrigger formula can not be None!"
    is_trigger = eval(is_trigger_formula, all_vars)
    if is_trigger:
        return True
    return False

def check_hit(skill_buff_info, hit, dodge):
    """
    当主技能为攻击技能时，才计算命中率
    hit: 攻方命中率
    dodge: 守方闪避率
    """
    all_vars = dict(hitArray1=hit,
                    dodgeArray2=dodge,
                    random=get_random_int(0, 99))
    is_hit_formula = game_configs.formula_config.get("isHit").get("formula")
    assert is_hit_formula!=None, "isHit formula can not be None!"
    is_hit = eval(is_hit_formula, all_vars)

    if skill_buff_info.effectId in [1, 2, 3]:
        if is_hit:
            return True
    return False


def check_block(attacker, target, skill_buff_info):
    all_vars = dict(blockArray=attacker.block,
                    random=get_random_int(0, 99))
    is_block_formula = game_configs.formula_config.get("isBlock").get("formula")
    assert is_block_formula!=None, "isBlock formula can not be None!"
    is_block = eval(is_block_formula, all_vars)
    if is_block:
        return True
    return False

def check_cri(cri, ductility):
    """
    当主技能为攻击技能时，才计算命中率
    cri: 攻方命中率
    dodge: 守方闪避率
    """
    all_vars = dict(criArray1=cri,
                    ductilityArray2=ductility,
                    random=get_random_int(0, 99))
    is_cri_formula = game_configs.formula_config.get("isCri").get("formula")
    assert is_cri_formula!=None, "isCri formula can not be None!"
    is_cri = eval(is_cri_formula, all_vars)

    if is_cri:
            return True
    return False

def execute_demage(attacker, target, skill_buff_info, is_block):
    """
    执行技能［1，2］
    """
    logger_cal.debug("    攻方 no(%d), unit_no(%d), name(%s), hp(%f), mp(%f), buff(%s)" % (attacker.slot_no, attacker.unit_no, attacker.unit_name, attacker.hp, attacker.mp, attacker.buff_manager))
    logger_cal.debug("    守方 no(%d), unit_no(%d), name(%s), hp(%f), mp(%f), buff(%s)" % (target.slot_no, target.unit_no, target.unit_name, target.hp, target.mp, target.buff_manager))

    is_cri = False # 是否暴击
    if check_cri(attacker.cri, target.ductility):
        is_cri = True

    k1 = attacker.atk # 攻方总实际攻击力
    k2 = 0            # 守方总物理或者魔法防御
    if skill_buff_info.effectId == 1:
        k2 = target.physical_def
    elif skill_buff_info.effectId == 2:
        k2 = target.magic_def

    # 1.base_demage_value 基础伤害值
    base_demage_vars = dict(atkArray=k1,
                            def2=k2,
                            heroLevel=attacker.level)

    base_demage_formula = game_configs.formula_config.get("baseDamage").get("formula")
    assert base_demage_formula!=None, "baseDamage formula can not be None!"
    base_demage_value = eval(base_demage_formula, base_demage_vars)

    # 2.cri_coeff 暴击伤害系数
    cri_coeff_vars = dict(criCoeffArray1=attacker.cri_coeff,
                          criDedCoeffArray2=target.cri_ded_coeff)

    cri_coeff_formula = game_configs.formula_config.get("criDamage").get("formula")
    assert cri_coeff_formula!=None, "criDamage formula can not be None!"
    cri_coeff = eval(cri_coeff_formula, cri_coeff_vars)

    # 3. levelDamage 等级压制系数
    level_coeff_vars = dict(heroLevel1=attacker.level,
                          heroLevel2=target.level)

    level_coeff_formula = game_configs.formula_config.get("levelDamage").get("formula")
    assert level_coeff_formula!=None, "levelDamage formula can not be None!"
    level_coeff = eval(level_coeff_formula, level_coeff_vars)

    # 4. floatDamage 等级压制系数
    temp = game_configs.base_config.get("a6")                           # 伤害浮动调整参数
    k1, k2 = temp[0], temp[1]                              #
    float_coeff_vars = dict(k1=k1,
                            k2=k2,
                            random=get_random_int(0, 99))
    float_coeff_formula = game_configs.formula_config.get("floatDamage").get("formula")
    assert float_coeff_formula!=None, "levelDamage formula can not be None!"
    float_coeff = eval(float_coeff_formula, float_coeff_vars)

    # 5. allDamage
    total_demage_vars = dict(baseDamage=base_demage_value,
                             isHit=True,
                             criDamage=cri_coeff,
                             isCri=is_cri,
                             isBlock=is_block,
                             levelDamage=level_coeff,
                             floatDamage=float_coeff)

    total_demage_formula = game_configs.formula_config.get("allDamage").get("formula")
    assert total_demage_formula!=None, "allDamage formula can not be None!"
    total_demage = eval(total_demage_formula, total_demage_vars) # 总伤害值

    all_vars = dict(
        skill_buff=skill_buff_info,
        allDamage=total_demage,
        valueEffect=skill_buff_info.valueEffect,
        levelEffectValue=skill_buff_info.levelEffectValue,
        heroLevel=attacker.level
    )
    actual_demage_1 = actual_value("damage_1", all_vars)
    actual_demage_2 = actual_value("damage_2", all_vars)

    logger_cal.debug("    技能ID（%d）,暴击（%s），格挡（%s），基础伤害值(%s)，暴击伤害系数(%s)，等级压制系数(%s)，伤害浮动系数(%s)，总伤害值(%s)，攻方实际伤害值(%s)" \
    % (skill_buff_info.id, is_cri, is_block, base_demage_value, cri_coeff, level_coeff, float_coeff,
            total_demage, actual_demage_1))
    target.hp = target.hp - actual_demage_1 - actual_demage_2

def execute_mp(target, skill_buff_info):
    """
    mp: 8,9
    """
    if skill_buff_info.effectId == 8:
        logger_cal.debug("mp 增加%s" % skill_buff_info.valueEffect)
        target.mp += skill_buff_info.valueEffect
    elif skill_buff_info.effectId == 9:
        target.mp -= skill_buff_info.valueEffect
        logger_cal.debug("mp 减少%s" % skill_buff_info.valueEffect)

def execute_pure_demage(attacker, target, skill_buff_info):
    """
    纯伤害:3
    """
    all_vars = dict(
        atkArray=attacker.atk,
        skill_buff=skill_buff_info,
        valueEffect=skill_buff_info.valueEffect,
        levelEffectValue=skill_buff_info.levelEffectValue,
        heroLevel=attacker.level
    )
    actual_demage_1 = actual_value("damage_3", all_vars)
    actual_demage_2 = actual_value("damage_4", all_vars)
    target.hp = target.hp - actual_demage_1 - actual_demage_2

def execute_treat(attacker, target, skill_buff_info):
    """
    治疗:26
    """
    is_cri = False # 是否暴击
    if check_cri(attacker.cri, target.ductility):
        is_cri = True

    # 6. allHeal
    total_treat_vars = dict(atkArray=attacker.atk,
                            criCoeffArray=attacker.cri_coeff,
                            isCri=is_cri)

    total_treat_formula = game_configs.formula_config.get("allHeal").get("formula")
    assert total_treat_formula!=None, "allHeal formula can not be None!"
    total_treat = eval(total_treat_formula, total_treat_vars) # 总伤害值

    all_vars = dict(
        skill_buff=skill_buff_info,
        allHeal=total_treat,
        valueEffect=skill_buff_info.valueEffect,
        levelEffectValue=skill_buff_info.levelEffectValue,
        heroLevel=attacker.level
    )
    actual_treat_1 = actual_value("heal_1", all_vars)
    actual_treat_2 = actual_value("heal_2", all_vars)
    target.hp = target.hp + actual_treat_1 + actual_treat_2


def actual_value(str_formula, all_vars):
    """docstring for actual_demage"""
    actual = 0
    condition_formula = game_configs.formula_config.get(str_formula).get("precondition")
    assert condition_formula!=None, "condition formula can not be None!"
    condition = eval(condition_formula, all_vars)

    if condition:
        actual_formula = game_configs.formula_config.get(str_formula).get("formula")
        assert actual_formula!=None, "actual formula can not be None!"
        actual = eval(actual_formula, all_vars)
    return actual

