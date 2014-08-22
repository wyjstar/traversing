# -*- coding:utf-8 -*-
"""
created by server on 14-8-22下午2:08.
"""
from app.game.core.fight.battle_unit import BattleUnit


def do_assemble(no, quality, normal_skill, rage_skill, break_skills, hp, atk, physical_def, magic_def, hit, dodge,
                cri, cri_coeff, cri_ded_coeff, block, is_boss=False):
    """组装战斗单位
    @param no: 编号
    @param quality: 品质
    @param normal_skill: 普通技能[技能ID, 技能buffs]
    @param rage_skill: 怒气技能[技能ID, 技能buffs]
    @param break_skills: 突破技能 [[技能ID, 技能buffs], [技能ID, 技能buffs]]
    @param hp: 血
    @param atk: 攻
    @param physical_def: 物理防御
    @param magic_def: 魔法防御
    @param hit: 命中
    @param dodge: 闪避
    @param cri: 暴击
    @param cri_coeff: 暴击伤害系数
    @param cri_ded_coeff: 暴击减免系数
    @param block: 格挡率
    @param is_boss: 是否是boss
    @return: 战斗单位对象
    """
    battle_unit = BattleUnit(no)
    battle_unit.quality = quality
    battle_unit.normal_skill = normal_skill
    battle_unit.rage_skill = rage_skill
    battle_unit.break_skills = break_skills
    battle_unit.hp = hp
    battle_unit.atk = atk
    battle_unit.physical_def = physical_def
    battle_unit.magic_def = magic_def
    battle_unit.hit = hit
    battle_unit.dodge = dodge
    battle_unit.cri = cri
    battle_unit.cri_coeff = cri_coeff
    battle_unit.cri_ded_coeff = cri_ded_coeff
    battle_unit.block = block
    battle_unit.is_boss = is_boss

    return battle_unit