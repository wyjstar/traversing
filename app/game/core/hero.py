# -*- coding:utf-8 -*-
"""
created by server on 14-6-25下午5:27.
"""
from shared.db_opear.configs_data.common_item import CommonItem

from shared.db_opear.configs_data.game_configs import hero_config, hero_exp_config, hero_breakup_config
from gtwisted.utils import log
import cPickle
from app.game.redis_mode import tb_character_hero


class Hero(object):
    """武将类"""

    def __init__(self, character_id=0):
        """
        :field _level: 等级
        :field _break_level: 突破等级
        :field _exp: 当前等级的经验
        :field _equipmentids: 装备IDs
        """
        self._hero_no = 0
        self._level = 0
        self._exp = 0
        self._break_level = 0
        self._character_id = character_id

    def init_data(self, data):
        print "武将初始化nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn"
        self._character_id = data.get("character_id")
        hero_property = data.get("property")
        self._hero_no = hero_property.get("hero_no")
        self._level = hero_property.get("level")
        self._exp = hero_property.get("exp")
        self._break_level = hero_property.get("break_level")

    @property
    def hero_no(self):
        return self._hero_no

    @hero_no.setter
    def hero_no(self, value):
        self._hero_no = value

    @property
    def level(self):
        return self._level

    @level.setter
    def level(self, value):
        self._level = value

    @property
    def exp(self):
        return self._exp

    @exp.setter
    def exp(self, value):
        self._exp = value

    @property
    def break_level(self):
        return self._break_level

    @break_level.setter
    def break_level(self, value):
        self._break_level = value

    def get_all_exp(self):
        """根据等级+当前等级经验，得到总经验"""
        total_exp = 0
        for level in range(1, self._level):
            total_exp += hero_exp_config[level].get('exp', 0)

        return total_exp + self._exp

    def upgrade(self, exp):
        """根据经验升级"""
        level = self._level
        temp_exp = self._exp
        temp_exp += exp
        while True:
            current_level_exp = hero_exp_config[level].get('exp', 0)
            if current_level_exp < temp_exp:
                level += 1
                temp_exp -= current_level_exp
            else:
                break

        self.level = level
        self.exp = temp_exp
        self.save_data()
        return level, temp_exp

    def save_data(self):
        hero_id = str(self._character_id) + '_' + str(self._hero_no)
        mmode = tb_character_hero.getObj(hero_id)
        mmode.update('property', self.hero_proerty_dict())

    def hero_proerty_dict(self):
        hero_property = {
            'hero_no': self._hero_no,
            'level': self._level,
            'exp': self._exp,
            'break_level': self._break_level
        }
        return hero_property

    def update_pb(self, hero_pb):
        hero_pb.hero_no = self._hero_no
        hero_pb.level = self._level
        hero_pb.break_level = self._break_level
        hero_pb.exp = self._exp

    def calculate_attr(self):
        """根据属性和等级计算卡牌属性
        """
        item_config = hero_config.get(self._hero_no)
        hero_no = self._hero_no
        quality = item_config.quality
        normal_skill = item_config.normalSkill
        rage_skill = item_config.rageSkill
        hp = item_config.hp + self._level * item_config.growHp  # 血
        atk = item_config.atk + self._level * item_config.growAtk  # 攻击
        physica_def = item_config.physicaDef + self._level * item_config.growPhysicaDef  # 物理防御
        magic_def = item_config.magicDef + self._level * item_config.growMagicDef  # 魔法防御
        hit = item_config.hit  # 命中率
        dodge = item_config.dodge  # 闪避率
        cri = item_config.cri  # 暴击率
        cri_coeff = item_config.criCoeff  # 暴击伤害系数
        cri_ded_coeff = item_config.criDedCoeff  # 暴击减免系数
        block = item_config.block  # 格挡率

        break_skill_ids = self.__break_skills()

        return CommonItem(
            dict(hero_no=hero_no, quality=quality, normal_skill=normal_skill, rage_skill=rage_skill, hp=hp, atk=atk,
                 physica_def=physica_def, magic_def=magic_def,
                 hit=hit, dodge=dodge, cri=cri, cri_coeff=cri_coeff, cri_ded_coeff=cri_ded_coeff, block=block,
                 break_skill_ids=break_skill_ids))

    def __break_skills(self):
        """根据突破等级取得突破技能ID
        """
        breakup_config = hero_breakup_config.get(self._hero_no)

        skill_ids = []
        for i in range(self._break_level + 1):
            skill_id = getattr(breakup_config, 'break%s' % (i + 1))
            skill_ids.append(skill_id)

        return skill_ids



