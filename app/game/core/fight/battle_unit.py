# -*- coding:utf-8 -*-
"""
created by server on 14-7-19下午2:27.
"""
import cPickle


class BattleUnit(object):
    """战斗单位组件
    """
    def __init__(self, no):
        """
        """
        self._no = no  # 战斗单位ID
        self._quality = 0  # 战斗单位品质
        self._normal_skill = []  # 战斗单位普通技能
        self._rage_skill = []  # 战斗单位怒气技能
        self._break_skills = []  # 战斗单位突破技能
        self._hp = 0  # 战斗单位血量
        self._atk = 0  # 战斗单位攻击
        self._physical_def = 0  # 战斗单位物理防御
        self._magic_def = 0  # 战斗单位魔法防御
        self._hit = 0  # 战斗单位命中率
        self._dodge = 0  # 战斗单位闪避率
        self._cri = 0  # 战斗单位暴击率
        self._cri_coeff = 0  # 战斗单位暴击伤害系数
        self._cri_ded_coeff = 0  # 战斗单位暴伤减免系数
        self._block = 0  # 战斗单位格挡率
        self._base_hp = 0  # 战斗单位基础血量
        self._base_atk = 0  # 战斗单位基础攻击
        self._base_physical_def = 0  # 战斗单位基础物理防御
        self._base_magic_def = 0  # 战斗单位基础魔法防御
        self._base_hit = 0  # 战斗单位基础命中率
        self._base_dodge = 0  # 战斗单位基础闪避率
        self._base_cri = 0  # 战斗单位基础暴击率
        self._base_cri_coeff = 0  # 战斗单位基础暴击伤害系数
        self._base_cri_ded_coeff = 0  # 战斗单位基础暴伤减免系数
        self._base_block = 0  # 战斗单位基础格挡率
        self._level = 0  # 等级
        self._break_level = 0  # 突破等级
        self._position = 0  # 战斗单位位置
        self._is_boss = False  # 是否是boss bool

    @property
    def info(self):
        return dict(no=self._no, quality=self._quality, normal_skill=self._normal_skill, rage_skill=self._rage_skill,
                    break_skills=self._break_skills, hp=self._hp, atk=self._atk, physical_def=self._physical_def,
                    magic_def=self._magic_def, hit=self._hit, dodge=self._dodge, cri=self._cri,
                    cri_coeff=self._cri_coeff, cri_ded_coeff=self._cri_ded_coeff, block=self._block,
                    base_hp=self._base_hp, base_atk=self._base_atk, base_physical_def=self._base_physical_def,
                    base_magic_def=self._base_magic_def, base_hit=self._base_hit, base_dodge=self._base_dodge,
                    base_cri=self._base_cri, base_cri_coeff=self._base_cri_coeff,
                    base_cri_ded_coeff=self._base_cri_ded_coeff, base_block=self._base_block, level=self._level,
                    break_level=self._break_level)

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
    def magic_def(self):
        return self._magic_def

    @magic_def.setter
    def magic_def(self, magic_def):
        self._magic_def = magic_def

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
    def base_hp(self):
        return self._base_hp

    @base_hp.setter
    def base_hp(self, base_hp):
        self._base_hp = base_hp

    @property
    def base_atk(self):
        return self._base_atk

    @base_atk.setter
    def base_atk(self, base_atk):
        self._base_atk = base_atk

    @property
    def base_physical_def(self):
        return self._base_physical_def

    @base_physical_def.setter
    def base_physical_def(self, base_physical_def):
        self._base_physical_def = base_physical_def

    @property
    def base_magic_def(self):
        return self._base_magic_def

    @base_magic_def.setter
    def base_magic_def(self, base_magic_def):
        self._base_magic_def = base_magic_def

    @property
    def base_hit(self):
        return self._base_hit

    @base_hit.setter
    def base_hit(self, base_hit):
        self._base_hit = base_hit

    @property
    def base_dodge(self):
        return self._base_dodge

    @base_dodge.setter
    def base_dodge(self, base_dodge):
        self._base_dodge = base_dodge

    @property
    def base_cri(self):
        return self._base_cri

    @base_cri.setter
    def base_cri(self, base_cri):
        self._base_cri = base_cri

    @property
    def base_cri_coeff(self):
        return self._base_cri_coeff

    @base_cri_coeff.setter
    def base_cri_coeff(self, base_cri_coeff):
        self._base_cri_coeff = base_cri_coeff

    @property
    def base_cri_ded_coeff(self):
        return self._base_cri_ded_coeff

    @base_cri_ded_coeff.setter
    def base_cri_ded_coeff(self, base_cri_ded_coeff):
        self._base_cri_ded_coeff = base_cri_ded_coeff

    @property
    def base_block(self):
        return self._base_block

    @base_block.setter
    def base_block(self, base_block):
        self._base_block = base_block

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

    @property
    def position(self):
        return self._position

    @position.setter
    def position(self, position):
        self._position = position

    @property
    def level(self):
        return self._level

    @level.setter
    def level(self, level):
        self._level = level

    @property
    def break_level(self):
        return self._break_level

    @break_level.setter
    def break_level(self, break_level):
        self._break_level = break_level

if __name__ == '__main__':
    class A(object):
        def __init__(self):
            self._name = 1

        @property
        def name(self):
            return self._name

        @name.setter
        def name(self, name):
            self._name = name

        def set_attrs(self, **kwargs):
            for name, value in kwargs.items():
                setattr(self, name,  value)

    a = A()
    a.set_attrs(name=2)

    print a.name