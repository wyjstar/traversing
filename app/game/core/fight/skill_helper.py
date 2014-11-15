# -*- coding:utf-8 -*-
"""
created by server on 14-7-22下午3:07.
"""
from shared.db_opear.configs_data.common_item import CommonItem


class SkillHelper(object):
    """Skill helper
    """
    def __init__(self, skills=[]):
        self._skills = skills

        self._buffs = []

    @property
    def buffs(self):
        return self._buffs

    def init_attr(self):
        for skill in self._skills:
            buffs = skill.buffs
            for buff in buffs:
                self.add_buff(buff)

    def add_buff(self, add_buff):
        """添加合并
        :param add_buff:
        :return:
        """
        buff = self.get_buff(add_buff)
        if buff:
            buff += add_buff
        else:
            self._buffs.append(add_buff)

    def get_buff(self, add_buff):
        for buff in self._buffs:
            if buff == add_buff:
                return buff
        return None

    def parse_buffs(self):
        """解析buffs, 汇总buff加成。
        """
        hp_up = 0.0  # HP上限增加
        hp_up_rate = 0.0  # HP上限增加率
        hp_down = 0.0  # HP上限减少
        hp_down_rate = 0.0  # HP上限减少率

        atk_up = 0.0  # ATK上限增加
        atk_up_rate = 0.0  # ATK上限增加率
        atk_down = 0.0  # ATK上限减少
        atk_down_rate = 0.0  # ATK上限减少率

        physical_def_up = 0.0  # 物理防御增加
        physical_def_up_rate = 0.0  # 物理防御增加率
        physical_def_down = 0.0  # 物理防御减少
        physical_def_down_rate = 0.0  # 物理防御减少率

        magic_def_up = 0.0  # 魔法防御增加
        magic_def_up_rate = 0.0  # 魔法防御增加率
        magic_def_down = 0.0  # 魔法防御减少
        magic_def_down_rate = 0.0  # 魔法防御减少率

        hit_up = 0.0  # 命中率增加
        hit_down = 0.0  # 命中率减少

        dodge_up = 0.0  # 闪避率增加
        dodge_down = 0.0  # 闪避率减少

        cri_up = 0.0  # 暴击率增加
        cri_down = 0.0  # 暴击率减少

        cri_coeff = 0.0  # 暴击伤害系数
        cri_ded_coeff = 0.0  # 暴击减免系数

        block_up = 0.0  # 格挡率增加
        block_down = 0.0  # 格挡率减少

        ductility_up = 0.0  # 韧性增加
        ductility_down = 0.0  # 韧性减小

        for buff in self._buffs:
            if buff.effect_id == 4 and buff.value_type == 1:
                hp_up += buff.value_effect
                continue
            if buff.effect_id == 4 and buff.value_type == 2:
                hp_up_rate += buff.value_effect / 100
                continue

            if buff.effect_id == 5 and buff.value_type == 1:
                hp_down += buff.value_effect
                continue

            if buff.effect_id == 5 and buff.value_type == 2:
                hp_down_rate += buff.value_effect / 100
                continue

            if buff.effect_id == 6 and buff.value_type == 1:
                atk_up += buff.value_effect
                continue

            if buff.effect_id == 6 and buff.value_type == 2:
                atk_up_rate += buff.value_effect / 100
                continue

            if buff.effect_id == 7 and buff.value_type == 1:
                atk_down += buff.value_effect
                continue

            if buff.effect_id == 7 and buff.value_type == 2:
                atk_down_rate += buff.value_effect / 100
                continue

            if buff.effect_id == 10 and buff.value_type == 1:
                physical_def_up += buff.value_effect
                continue

            if buff.effect_id == 10 and buff.value_type == 2:
                physical_def_up_rate += buff.value_effect / 100
                continue

            if buff.effect_id == 11 and buff.value_effect == 1:
                physical_def_down += buff.value_effect
                continue

            if buff.effect_id == 11 and buff.value_type == 2:
                physical_def_down_rate += buff.value_effect / 100
                continue

            if buff.effect_id == 12 and buff.value_type == 1:
                magic_def_up += buff.value_effect
                continue

            if buff.effect_id == 12 and buff.value_type == 2:
                magic_def_up_rate += buff.value_effect / 100
                continue

            if buff.effect_id == 13 and buff.value_type == 1:
                magic_def_down += buff.value_effect
                continue

            if buff.effect_id == 13 and buff.value_type == 2:
                magic_def_down_rate += buff.value_effect / 100
                continue

            if buff.effect_id == 14:
                hit_up += buff.value_effect

            if buff.effect_id == 15:
                hit_down += buff.value_effect

            if buff.effect_id == 16:
                dodge_up += buff.value_effect

            if buff.effect_id == 17:
                dodge_down += buff.value_effect

            if buff.effect_id == 18:
                cri_up += buff.value_effect

            if buff.effect_id == 19:
                cri_down += buff.value_effect

            if buff.effect_id == 20:
                cri_coeff += buff.value_effect

            if buff.effect_id == 21:
                cri_ded_coeff += buff.value_effect

            if buff.effect_id == 22:
                block_up += buff.value_effect

            if buff.effect_id == 23:
                block_down += buff.value_effect

            if buff.effect_id == 28:
                ductility_up += buff.value_effect

            if buff.effect_id == 29:
                ductility_down += buff.value_effect

        return CommonItem(
            dict(hp=hp_up + hp_down,
                 hp_rate=hp_up_rate - hp_down_rate,
                 atk=atk_up - atk_down,
                 atk_rate=atk_up_rate - atk_down_rate,
                 physical_def=physical_def_up - physical_def_down,
                 physical_def_rate=physical_def_up_rate - physical_def_down_rate,
                 magic_def=magic_def_up - magic_def_down,
                 magic_def_rate=magic_def_up_rate - magic_def_down_rate,
                 hit=hit_up - hit_down,
                 dodge=dodge_up - dodge_down,
                 cri=cri_up - cri_down,
                 cri_coeff=cri_coeff,
                 cri_ded_coeff=cri_ded_coeff,
                 block=block_up - block_down,
                 ductility=ductility_up-ductility_down))