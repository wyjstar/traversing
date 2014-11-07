# -*- coding:utf-8 -*-
"""
created by server on 14-7-19下午2:27.
"""
import cPickle


class BattleUnit(object):
    """战斗单位组件
    """
    __slots__ = ['no',
                 'quality',
                 'normal_skill',
                 'rage_skill',
                 'break_skills',
                 'hp',
                 'atk',
                 'physical_def',
                 'magic_def',
                 'hit',
                 'dodge',
                 'cri',
                 'cri_coeff',
                 'cri_ded_coeff',
                 'block',
                 'base_hp',
                 'base_atk',
                 'base_physical_def',
                 'base_magic_def',
                 'base_hit',
                 'base_dodge',
                 'base_cri',
                 'base_cri_coeff',
                 'base_cri_ded_coeff',
                 'base_block',
                 'level',
                 'break_level',
                 'position',
                 'is_boss']

    def __init__(self, no):
        """
        """
        self.no = no  # 战斗单位ID
        self.quality = 0  # 战斗单位品质
        self.normal_skill = 0  # 战斗单位普通技能
        self.rage_skill = 0  # 战斗单位怒气技能
        self.break_skills = []  # 战斗单位突破技能
        self.hp = 0  # 战斗单位血量
        self.atk = 0  # 战斗单位攻击
        self.physical_def = 0  # 战斗单位物理防御
        self.magic_def = 0  # 战斗单位魔法防御
        self.hit = 0  # 战斗单位命中率
        self.dodge = 0  # 战斗单位闪避率
        self.cri = 0  # 战斗单位暴击率
        self.cri_coeff = 0  # 战斗单位暴击伤害系数
        self.cri_ded_coeff = 0  # 战斗单位暴伤减免系数
        self.block = 0  # 战斗单位格挡率
        self.base_hp = 0  # 战斗单位基础血量
        self.base_atk = 0  # 战斗单位基础攻击
        self.base_physical_def = 0  # 战斗单位基础物理防御
        self.base_magic_def = 0  # 战斗单位基础魔法防御
        self.base_hit = 0  # 战斗单位基础命中率
        self.base_dodge = 0  # 战斗单位基础闪避率
        self.base_cri = 0  # 战斗单位基础暴击率
        self.base_cri_coeff = 0  # 战斗单位基础暴击伤害系数
        self.base_cri_ded_coeff = 0  # 战斗单位基础暴伤减免系数
        self.base_block = 0  # 战斗单位基础格挡率
        self.level = 0  # 等级
        self.break_level = 0  # 突破等级
        self.position = 0  # 战斗单位位置
        self.is_boss = False  # 是否是boss bool

    @property
    def info(self):
        return dict(no=self.no, quality=self.quality, normal_skill=self.normal_skill, rage_skill=self.rage_skill,
                    break_skills=self.break_skills, hp=self.hp, atk=self.atk, physical_def=self.physical_def,
                    magic_def=self.magic_def, hit=self.hit, dodge=self.dodge, cri=self.cri,
                    cri_coeff=self.cri_coeff, cri_ded_coeff=self.cri_ded_coeff, block=self.block,
                    base_hp=self.base_hp, base_atk=self.base_atk, base_physical_def=self.base_physical_def,
                    base_magic_def=self.base_magic_def, base_hit=self.base_hit, base_dodge=self.base_dodge,
                    base_cri=self.base_cri, base_cri_coeff=self.base_cri_coeff,
                    base_cri_ded_coeff=self.base_cri_ded_coeff, base_block=self.base_block, level=self.level,
                    break_level=self.break_level)

    def dumps(self):
        return cPickle.dumps(self.info)

    @classmethod
    def loads(cls, data):
        info = cPickle.loads(data)
        no = info['no']
        unit = cls(no)
        unit.set_attrs(**info)
        return unit

    def set_attrs(self, **kwargs):
        for name, value in kwargs.items():
            setattr(self, name, value)

    def __cmp__(self, other):
        if self is not None and other is not None:
            return cmp(self.no, other.no)

        if self is None and other is None:
            return 0
        elif other is None:
            return -1
        else:
            return 1

    def __getstate__(self):
        l = [self.no,
             self.quality,
             self.normal_skill,
             self.rage_skill,
             self.break_skills,
             self.hp,
             self.atk,
             self.physical_def,
             self.magic_def,
             self.hit,
             self.dodge,
             self.cri,
             self.cri_coeff,
             self.cri_ded_coeff,
             self.block,
             self.base_hp,
             self.base_atk,
             self.base_physical_def,
             self.base_magic_def,
             self.base_hit,
             self.base_dodge,
             self.base_cri,
             self.base_cri_coeff,
             self.base_cri_ded_coeff,
             self.base_block,
             self.level,
             self.break_level,
             self.position,
             self.is_boss]
        return tuple(l)

    def __setstate__(self, l):
        self.no = l[0]
        self.quality = l[1]
        self.normal_skill = l[2]
        self.rage_skill = l[3]
        self.break_skills = l[4]
        self.hp = l[5]
        self.atk = l[6]
        self.physical_def = l[7]
        self.magic_def = l[8]
        self.hit = l[9]
        self.dodge = l[10]
        self.cri = l[11]
        self.cri_coeff = l[12]
        self.cri_ded_coeff = l[13]
        self.block = l[14]
        self.base_hp = l[15]
        self.base_atk = l[16]
        self.base_physical_def = l[17]
        self.base_magic_def = l[18]
        self.base_hit = l[19]
        self.base_dodge = l[20]
        self.base_cri = l[21]
        self.base_cri_coeff = l[22]
        self.base_cri_ded_coeff = l[23]
        self.base_block = l[24]
        self.level = l[25]
        self.break_level = l[26]
        self.position = l[27]
        self.is_boss = l[28]
