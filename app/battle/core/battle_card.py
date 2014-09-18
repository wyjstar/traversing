# -*- coding:utf-8 -*-
"""
created by server on 14-9-10下午5:26.
"""

class BattleCard(object):
    """战斗内单张卡 hero和enemy都继承于本类
    """
    def __init__(self, prop):
        self.no = prop.no
        self.level = prop.level
        self.quality = prop.quality
        self.pos = prop.pos
        self.is_boss = prop.is_boss
        self.hp = prop.hp
        self.hpM = prop.hpM
        self.atk = prop.atk
        self.pdef = prop.pdef
        self.mdef = prop.mdef
        self.hit = prop.hit
        self.dodge = prop.dodge
        self.cri = prop.cri
        self.cri_coeff = prop.cri_coeff
        self.cri_ded_coeff = prop.cri_ded_coeff
        self.block = prop.block
        self.base_hp = prop.base_hp
        self.base_atk = prop.base_atk
        self.base_pdef = prop.base_pdef
        self.base_mdef = prop.base_mdef
        self.base_hit = prop.base_hit
        self.base_dodge = prop.base_dodge
        self.base_cri = prop.base_cri
        self.base_cri_coeff = prop.base_cri_coeff
        self.base_cri_ded_coeff = prop.base_cri_ded_coeff
        self.base_block = prop.base_block
        self.normal_skill = prop.normal_skill
        self.rage_skill = prop.rage_skill
        self.break_skill = prop.break_skill

        self.anger = 0
        self.is_dead = False

    @property
    def no(self):
        return self.no

    @property
    def level(self):
        return self.level

    @property
    def quality(self):
        return self.quality

    @property
    def pos(self):
        return self.pos

    @pos.setter
    def pos(self, pos):
        self.pos = pos

    @property
    def is_boss(self):
        return self.is_boss

    @property
    def hp(self):
        return self.hp

    @property
    def hpM(self):
        return self.hpM

    @property
    def atk(self):
        return self.atk

    @property
    def pdef(self):
        return self.pdef

    @property
    def mdef(self):
        return self.mdef

    @property
    def hit(self):
        return self.hit

    @property
    def dodge(self):
        return self.dodge

    @property
    def cri(self):
        return self.cri

    @property
    def cri_coeff(self):
        return self.cri_coeff

    @property
    def cri_ded_coeff(self):
        return self.cri_ded_coeff

    @property
    def block(self):
        return self.block

    @property
    def base_hp(self):
        return self.base_hp

    @property
    def base_atk(self):
        return self.base_atk

    @property
    def base_pdef(self):
        return self.base_pdef

    @property
    def base_mdef(self):
        return self.base_mdef

    @property
    def base_hit(self):
        return self.base_hit

    @property
    def base_dodge(self):
        return self.base_dodge

    @property
    def base_cri(self):
        return self.base_cri

    @property
    def base_cri_coeff(self):
        return self.base_cri_coeff

    @property
    def base_cri_ded_coeff(self):
        return self.base_cri_ded_coeff

    @property
    def base_block(self):
        return self.base_block

    @property
    def normal_skill(self):
        return self.normal_skill

    @property
    def rage_skill(self):
        return self.rage_skill

    @property
    def break_skill(self):
        return self.break_skill