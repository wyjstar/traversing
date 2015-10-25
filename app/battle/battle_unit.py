# -*- coding:utf-8 -*-
"""
created by server on 14-11-10下午3:31.
"""
from battle_skill import HeroSkill, MonsterSkill
from battle_buff import BuffManager
import cPickle


class BattleUnit(object):
    """战斗单元"""

    def __init__(self):
        self._slot_no = 0  # 阵容位置
        self._position = 0  # 位置
        self._unit_name = ""
        self._unit_no = 0
        self._hp_max = 0.0
        self._hp = 0.0
        self._atk = 0.0
        self._physical_def = 0.0
        self._magic_def = 0.0
        self._hit = 0.0            # 命中率
        self._dodge = 0.0          # 闪避率
        self._cri = 0.0            # 暴击率
        self._cri_coeff = 0.0      # 暴击伤害系数
        self._cri_ded_coeff = 0.0  # 暴击减免系数
        self._block = 0.0          # 格挡率
        self._ductility = 0.0      # 韧性
        self._level = 0.0          # 等级
        self._break_level = 0      # 突破等级
        self._mp_base = 0          # 武将基础mp
        self._quality = 0          # 武将品质
        self._is_boss = 0          # 是否为boss
        self._skill = None         # 技能
        self._is_break = False     # 是否为突破
        self._is_awake = False     # 是否觉醒
        self._origin_no = 0        # 突破或者觉醒武将的原始no
        self._power = 0
        self._awake_level = 0 # 觉醒等级

        self._buff_manager = BuffManager(self)

    @property
    def origin_no(self):
        return self._origin_no

    @origin_no.setter
    def origin_no(self, value):
        self._origin_no = value

    @property
    def is_break(self):
        return self._is_break

    @is_break.setter
    def is_break(self, value):
        self._is_break = value

    @property
    def is_awake(self):
        return self._is_awake

    @is_awake.setter
    def is_awake(self, value):
        self._is_awake = value

    @property
    def is_boss(self):
        return self._is_boss

    @is_boss.setter
    def is_boss(self, value):
        self._is_boss = value

    @property
    def quality(self):
        return self._quality

    @quality.setter
    def quality(self, value):
        self._quality = value

    @property
    def mp(self):
        return self._skill.mp

    @mp.setter
    def mp(self, value):
        self._skill.mp = value

    @property
    def buff_manager(self):
        return self._buff_manager

    @buff_manager.setter
    def buff_manager(self, value):
        self._buff_manager = value

    @property
    def level(self):
        return self._level

    @level.setter
    def level(self, value):
        self._level = value

    @property
    def break_level(self):
        return self._break_level

    @break_level.setter
    def break_level(self, value):
        self._break_level = value

    @property
    def slot_no(self):
        return self._slot_no

    @slot_no.setter
    def slot_no(self, value):
        self._slot_no = value

    @property
    def position(self):
        return self._position

    @position.setter
    def position(self, value):
        self._position = value

    @property
    def unit_name(self):
        return self._unit_name

    @unit_name.setter
    def unit_name(self, value):
        self._unit_name = value

    @property
    def skill(self):
        return self._skill

    @skill.setter
    def skill(self, value):
        self._skill = value

    @property
    def unit_no(self):
        return self._unit_no

    @unit_no.setter
    def unit_no(self, value):
        self._unit_no = value

    @property
    def hp(self):
        return int(self._hp)

    @hp.setter
    def hp(self, value):
        if value < self._hp_max:
            self._hp = value
        else:
            self._hp=self._hp_max

    @property
    def hit(self):
        return self._buff_manager.get_buffed_hit(self._hit)

    @hit.setter
    def hit(self, value):
        self._hit = value

    @property
    def physical_def(self):
        return self._buff_manager.get_buffed_physical_def(self._physical_def)

    @physical_def.setter
    def physical_def(self, value):
        self._physical_def = value

    @property
    def magic_def(self):
        return self._buff_manager.get_buffed_magic_def(self._magic_def)

    @magic_def.setter
    def magic_def(self, value):
        self._magic_def = value

    @property
    def dodge(self):
        return self._buff_manager.get_buffed_dodge(self._dodge)

    @dodge.setter
    def dodge(self, value):
        self._dodge = value

    @property
    def cri(self):

        return self._buff_manager.get_buffed_cri(self._cri)

    @cri.setter
    def cri(self, value):
        self._cri = value

    @property
    def cri_coeff(self):
        return self._buff_manager.get_buffed_cri_coeff(self._cri_coeff)

    @cri_coeff.setter
    def cri_coeff(self, value):
        self._cri_coeff = value

    @property
    def cri_ded_coeff(self):
        return self._buff_manager.get_buffed_cri_ded_coeff(self._cri_ded_coeff)

    @cri_ded_coeff.setter
    def cri_ded_coeff(self, value):
        self._cri_ded_coeff = value

    @property
    def block(self):
        return self._buff_manager.get_buffed_block(self._block)

    @block.setter
    def block(self, value):
        self._block = value

    @property
    def atk(self):
        return self._buff_manager.get_buffed_atk(self._atk)

    @atk.setter
    def atk(self, value):
        self._atk = value

    @property
    def ductility(self):
        return self._buff_manager.get_buffed_ductility(self._ductility)

    @ductility.setter
    def ductility(self, value):
        self._ductility = value

    def __repr__(self):
        return ("阵容(%s), 位置(%s), 武将名称(%s), 编号(%s), hp(%s), 攻击(%s), 物防(%s), 魔防(%s), \
                命中(%s), 闪避(%s), 暴击(%s), 暴击伤害系数(%s), 暴击减免系数(%s), 格挡(%s), 韧性(%s), 等级(%s), 突破等级(%s), mp(%s), buffs(%s), hp_percent(%s), power(%s)") \
               % (self._slot_no,
            self._position, self._unit_name, self._unit_no, self.hp, self.atk, self.physical_def, self.magic_def,
            self.hit, self.dodge, self.cri, self.cri_coeff, self.cri_ded_coeff, self.block, self.ductility,
            self.level, self.break_level, 0, 0, self.hp_percent, self._power)

    @property
    def hp_max(self):
        return int(self._hp_max)

    @hp_max.setter
    def hp_max(self, value):
        self._hp_max = value

    @property
    def power(self):
        return self._power

    @power.setter
    def power(self, value):
        self._power = value

    @property
    def awake_level(self):
        return self._awake_level

    @awake_level.setter
    def awake_level(self, value):
        self._awake_level = value

    @property
    def hp_percent(self):
        """hp 百分比"""
        return self._hp / self._hp_max

    @property
    def info(self):
        return dict(unit_no=self.unit_no, quality=self._quality,
                    break_skills=self.skill.break_skill_ids,
                    hp_max=self._hp_max, hp=self._hp, atk=self._atk,
                    physical_def=self._physical_def, magic_def=self._magic_def,
                    hit=self._hit, dodge=self._dodge, cri=self._cri,
                    cri_coeff=self._cri_coeff,
                    cri_ded_coeff=self._cri_ded_coeff, block=self._block,
                    ductility=self._ductility,
                    level=self._level,
                    is_boss=self._is_boss,
                    skill=self._skill,
                    is_awake=False,
                    origin_no=0,
                    is_break=False,
                    position=self._position,
                    power=self._power,
                    awake_level=self._awake_level
                    )

    def dumps(self):
        return cPickle.dumps(self.info)

    @classmethod
    def loads(cls, data):
        info = cPickle.loads(data)
        unit = cls()
        unit.set_attrs(**info)
        return unit

    def set_attrs(self, **kwargs):
        for name, value in kwargs.items():
            setattr(self, name, value)

    def __cmp__(self, other):
        if self is not None and other is not None:
            return cmp(self.unit_no, other.unit_no)

        if self is None and other is None:
            return 0
        elif other is None:
            return -1
        else:
            return 1


def do_assemble(slot_no, no, quality, break_skills, hp,
                atk, physical_def, magic_def, hit, dodge, cri, cri_coeff, cri_ded_coeff, block, ductility, position,
                level, break_level,
                is_boss=False, is_hero=True, is_break_hero=False, unit_name="", power=0, awake_level=0):
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
    battle_unit = BattleUnit()

    battle_unit.unit_no = no
    battle_unit.origin_no = no
    battle_unit.unit_name = unit_name
    battle_unit.quality = quality

    battle_unit.hp_max = hp
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
    battle_unit.break_level = break_level

    battle_unit.level = level
    battle_unit.is_boss = is_boss
    battle_unit.position = position
    battle_unit.slot_no = slot_no

    if is_hero:
        battle_unit.skill = HeroSkill(battle_unit)
    else:
        battle_unit.skill = MonsterSkill(battle_unit)

    battle_unit.skill.break_skill_ids = break_skills
    battle_unit.power = power
    battle_unit.awake_level = awake_level
    return battle_unit


# import copy


# unit = do_assemble(10001, 1, [], 1, 1, 1, 1, 1, 1,1, 1, 1, 1, 1, 1, 1)
#copy.deepcopy(unit)


