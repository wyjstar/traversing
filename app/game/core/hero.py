# -*- coding:utf-8 -*-
"""
created by server on 14-6-25下午5:27.
"""
from gtwisted.utils import log
from app.game.core.fight.skill import Skill
from app.game.core.fight.skill_helper import SkillHelper
from shared.db_opear.configs_data import game_configs
from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.game_configs import hero_config
from shared.db_opear.configs_data.game_configs import hero_exp_config
from shared.db_opear.configs_data.game_configs import hero_breakup_config
from shared.db_opear.configs_data.game_configs import link_config
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
        self._level = 1
        self._exp = 0
        self._break_level = 0
        self._character_id = character_id

    def init_data(self, data):
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

        hero_no = self._hero_no  # 英雄编号
        quality = item_config.quality  # 英雄品质

        hp = item_config.hp + self._level * item_config.growHp  # 血
        atk = item_config.atk + self._level * item_config.growAtk  # 攻击
        physical_def = item_config.physicalDef + self._level * item_config.growPhysicalDef  # 物理防御
        magic_def = item_config.magicDef + self._level * item_config.growMagicDef  # 魔法防御
        hit = item_config.hit  # 命中率
        dodge = item_config.dodge  # 闪避率
        cri = item_config.cri  # 暴击率
        cri_coeff = item_config.criCoeff  # 暴击伤害系数
        cri_ded_coeff = item_config.criDedCoeff  # 暴击减免系数
        block = item_config.block  # 格挡率

        normal_skill = self.normal_skill
        rage_skill = self.rage_skill
        break_skills = self.break_skills

        return CommonItem(
            dict(hero_no=hero_no, quality=quality, normal_skill=normal_skill, rage_skill=rage_skill, hp=hp, atk=atk,
                 physical_def=physical_def, magic_def=magic_def,
                 hit=hit, dodge=dodge, cri=cri, cri_coeff=cri_coeff, cri_ded_coeff=cri_ded_coeff, block=block,
                 break_skills=break_skills, level=self._level, break_level=self._break_level))

    def break_attr(self):
        """突破技能带来的属性加成
        """
        skills = []
        for skill_id in self.break_skill_ids:
            skill = Skill(skill_id)
            skill.init_attr()
            skills.append(skill)

        skill_helper = SkillHelper(skills)
        skill_helper.init_attr()
        attr = skill_helper.parse_buffs()
        return attr

    @property
    def break_skill_ids(self):
        """根据突破等级取得突破技能ID
        """
        breakup_config = hero_breakup_config.get(self._hero_no)
        if not breakup_config:
            log.err('cant find breakup:%d' % self.hero_no)
        skill_ids = []
        for i in range(self._break_level + 1):
            skill_id = breakup_config.info.get('break%s' % (i + 1))
            if skill_id != 0:
                skill_ids.append(skill_id)

        return skill_ids

    @property
    def hero_links(self):
        """英雄羁绊配置数据
        """
        return link_config.get(self._hero_no)

    @property
    def normal_skill_id(self):
        """普通技能ID
        """
        item_config = hero_config.get(self._hero_no)
        skill_id = item_config.normalSkill  # 普通技能
        return skill_id

    @property
    def rage_skill_id(self):
        """怒气技能ID
        """
        item_config = hero_config.get(self._hero_no)
        rage_id = item_config.rageSkill  # 怒气技能
        return rage_id

    @property
    def group_by_normal(self):
        """根据普通技能ID获得技能buff组
        """
        normal_skill_id = self.normal_skill_id
        normal_skill_config = game_configs.skill_config.get(normal_skill_id)
        normal_group = normal_skill_config.group[:]  # 取得一个拷贝
        return normal_group

    @property
    def group_by_rage(self):
        """根据怒气技能ID获得技能buff组
        """
        rage_skill_id = self.rage_skill_id
        rage_skill_config = game_configs.skill_config.get(rage_skill_id)
        rage_group = rage_skill_config.group[:]  # 取得一个拷贝
        return rage_group

    @property
    def normal_skill(self):
        """普通技能ID，buff组
        """
        normal_id = self.normal_skill_id  # 普通技能ID
        normal_group = self.group_by_normal  # 普通技能buff组
        normal_group = self.__assemble_skills(normal_group)
        return [normal_id] + normal_group

    @property
    def rage_skill(self):
        """怒气技能ID，buff组
        """
        rage_id = self.rage_skill_id  # 怒气技能ID
        rage_group = self.group_by_rage  # 怒气技能buff组
        rage_group = self.__assemble_skills(rage_group)
        return [rage_id] + rage_group

    @property
    def break_skills(self):
        """突破技能ID，buff组
        """
        skills = []
        skill_ids = self.break_skill_ids
        for skill_id in skill_ids:
            skill = [skill_id]
            skill_config = game_configs.skill_config.get(skill_id)  # 技能配置
            group = skill_config.group  # buff组
            for buff_id in group[:]:
                buff_config = game_configs.skill_buff_config.get(buff_id)  # buff配置
                trigger_type = buff_config.triggerType  # 触发类别
                if trigger_type == 1 or trigger_type == 6 or trigger_type == 7 or trigger_type == 8 or trigger_type \
                        == 9 or trigger_type == 10:
                    continue
                skill.append(buff_id)
            skills.append(skill)
        return skills

    def __assemble_skills(self, buffs, mold=0):
        """根据突破技能组装技能
        @param buffs: 技能buff组
        @param mold： 0：普通技能 1：怒气技能
        @return: 普通技能ID，普通技能buff组，怒气技能ID，怒气技能buff组
        """
        skill_ids = self.break_skill_ids
        for skill in skill_ids:
            skill_config = game_configs.skill_config.get(skill)  # 技能配置
            if not skill_config:
                log.err('skill config can not find id:%d' % skill)
            group = skill_config.group  # buff组
            for buff_id in group:
                buff_config = game_configs.skill_buff_config.get(buff_id)  # buff配置
                trigger_type = buff_config.triggerType  # 触发类别
                # 6-如果普通技能组击中敌人则生效
                # 7-如果怒气技能组击中敌人则生效
                # 8-普通技能组或怒气技能组击中敌人则生效
                # 9-普通技能组或怒气技能是治疗技能则生效
                # 10-普通技能组或怒气技能组释放前生效
                if trigger_type == 6 and not mold:
                    buffs.append(buff_id)
                    continue
                if trigger_type == 7 and mold:
                    buffs.append(buff_id)
                    continue
                if trigger_type == 8 or trigger_type == 9 or trigger_type == 10:
                    buffs.append(buff_id)
                    continue
        return buffs






