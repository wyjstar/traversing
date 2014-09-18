# -*- coding:utf-8 -*-
"""
created by server on 14-9-10下午5:23.
"""

import math
import random

class BattleCalculate(object):
    """战斗内使用计算公式
    """
    def __init__(self):
        """
        """
        pass

    # 战斗公式 基础伤害值
    # k1:攻方总实际攻击
    # k2:守方总物理防御值或者总魔法防御值
    # k3:攻防等价调整参数(3)
    # k4:伤害数值调整参数(2)
    def base_hurt_value(self, k1, k2, k3, k4, k5):
        return (((math.pow(k1, 2)/(k1 + k3 * k2))) * k4)

    # 战斗公式 暴击伤害系数
    # k1:攻方总暴击伤害系数
    # k2:守方总暴伤减免系数
    def cri_hurt_coeff(self, k1, k2):
        return k1 - k2

    # 战斗公式 格挡受伤系数
    # k1:基础配置表单手配置(0.7)
    def block_hurt_coeff(self, k1):
        return k1

    # 战斗公式 等级压制系数
    # k1:攻方等级
    # k2:守方等级
    # k3:调整参数1(1)
    # k4:调整参数2(1600)
    # k5:调整参数3(3)
    def level_suppress_coeff(self, k1, k2, k3, k4, k5):
        if k2 - k1 > 5:
            if 1-k3/k4*math.pow(k2-k1, 2) + k2 - k1 > 0.1:
                return 1 - k3/k4 * (math.pow(k2-k1, 2) + k2 - k1 + k5)
            else:
                return 0.1

        return 1

    # 战斗公式 伤害浮动系数
    # k1:下限
    # k2:上限
    def hurt_float_coeff(self, k1, k2):
        return random.uniform(k1, k2)

    # 战斗公式 总伤害值
    # k1: 基础伤害值
    # k2: 暴击伤害系数
    # k3: 格挡伤害系数
    # k4: 等级压制系数
    # k5: 伤害浮动系数
    def total_hurt(self, k1, k2, k3, k4, k5, is_crit, is_block):
        if is_crit:
            k2 = 1

        if is_block:
            k3 = 1

        return k1 * k2 * k3 * k4 * k5

    # 战斗公式 总治疗值
    # k1: 攻方总暴击伤害系数
    # k2: 攻方总攻击值
    def total_cure(self, k1, k2):
        return k1 * k2

    # 战斗公式 攻方实际治疗值
    # k1: 攻方总治疗值
    # k2: 技能效果参数 读表
    # k3: 等级效果参数 读表
    # k4: 卡牌等级
    def real_cure(self, k1, k2, k3, k4):
        if k3 != 0:
            k2 = k2 + k3 * k4

        return k1 * k2

    # 战斗公式 攻方实际伤害值
    # k1: 攻方总治疗值
    # k2: 技能效果参数 读表
    # k3: 等级效果参数 读表
    # k4: 卡牌等级
    def real_hit(self, k1, k2, k3, k4):
        if k3 != 0:
            k2 = k2 + k3 * k4

        return k1 * k2

    # 战斗公式 受击方实际伤害百分比
    # k1: 受击方总治疗值
    # k2: 技能效果参数 读表
    # k3: 等级效果参数 读表
    # k4: 卡牌等级
    def real_on_hit(self, k1, k2, k3, k4):
        if k3 != 0:
            k2 = k2 + k3 * k4

        return k1 * k2

    # 战斗公式 受击方实际治疗值
    # k1: 受击方总治疗值
    # k2: 技能效果参数 读表
    # k3: 等级效果参数 读表
    # k4: 卡牌等级
    def real_on_hit_cure(self, k1, k2, k3, k4):
        if k3 != 0:
            k2 = k2 + k3 * k4

        return k1 * k2

    # skill buff计算
    # k1: 技能效果参数
    # k2: 等级效果参数
    # k3: 卡牌等级
    def buff_effect(self, k1, k2, k3):
        if k2 == 0:
            return k1

        return k1 + k2 * k3