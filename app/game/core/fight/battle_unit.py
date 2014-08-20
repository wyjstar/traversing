# -*- coding:utf-8 -*-
"""
created by server on 14-7-19下午2:27.
"""


class BattleUnit(object):
    """战斗单位组件
    """
    def __init__(self, no):
        """
        """
        self._no = no  # 战斗单位ID
        self._quality = 2  # 战斗单位品质
        self._normal_skill = 3  # 战斗单位普通技能
        self._rage_skill = 4  # 战斗单位怒气技能
        self._break_skills = 16  # 战斗单位突破技能
        self._hp = 5  # 战斗单位血量
        self._atk = 6  # 战斗单位攻击
        self._physical_def = 7  # 战斗单位物理防御
        self._magic_dif = 8  # 战斗单位魔法防御
        self._hit = 9  # 战斗单位命中率
        self._dodge = 10  # 战斗单位闪避率
        self._cri = 11  # 战斗单位暴击率
        self._cri_coeff = 12  # 战斗单位暴击伤害系数
        self._cri_ded_coeff = 13  # 战斗单位暴伤减免系数
        self._block = 14  # 战斗单位格挡率
        self._is_boss = 15  # 是否是boss bool

    @property
    def no(self):
        return self._no

    @no.setter
    def no(self, no):
        self._no = no

    @property
    def quality(self):
        return self._quality

    @quality.setter
    def quality(self, quality):
        self._quality = quality

    @property
    def normal_skill(self):
        return self._normal_skill

    @normal_skill.setter
    def normal_skill(self, normal_skill):
        self._normal_skill = normal_skill

    @property
    def rage_skill(self):
        return self._rage_skill

    @rage_skill.setter
    def rage_skill(self, rage_skill):
        self._rage_skill = rage_skill

    @property
    def hp(self):
        return self._hp

    @hp.setter
    def hp(self, hp):
        self._hp = hp

    @property
    def atk(self):
        return self._atk

    @atk.setter
    def atk(self, atk):
        self._atk = atk

    @property
    def physical_def(self):
        return self._physical_def

    @physical_def.setter
    def physical_def(self, physical_def):
        self._physical_def = physical_def

    @property
    def magic_dif(self):
        return self._magic_dif

    @magic_dif.setter
    def magic_dif(self, magic_dif):
        self._magic_dif = magic_dif

    @property
    def hit(self):
        return self._hit

    @hit.setter
    def hit(self, hit):
        self._hit = hit

    @property
    def dodge(self):
        return self._dodge

    @dodge.setter
    def dodge(self, dodge):
        self._dodge = dodge

    @property
    def cri(self):
        return self._cri

    @cri.setter
    def cri(self, cri):
        self._cri = cri

    @property
    def cri_coeff(self):
        return self._cri_coeff

    @cri_coeff.setter
    def cri_coeff(self, cri_coeff):
        self._cri_coeff = cri_coeff

    @property
    def cri_ded_coeff(self):
        return self._cri_ded_coeff

    @cri_ded_coeff.setter
    def cri_ded_coeff(self, cri_ded_coeff):
        self._cri_ded_coeff = cri_ded_coeff

    @property
    def block(self):
        return self._block

    @block.setter
    def block(self, block):
        self._block = block

    @property
    def is_boss(self):
        return self._is_boss

    @is_boss.setter
    def is_boss(self, is_boss):
        self._is_boss = is_boss

    @property
    def break_skills(self):
        return self._break_skills

    @break_skills.setter
    def break_skills(self, skills):
        self._break_skills = skills