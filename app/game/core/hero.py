# -*- coding:utf-8 -*-
"""
created by server on 14-6-25下午5:27.
"""
from gfirefly.server.logobj import logger
from app.game.core.fight.skill import Skill
from app.game.core.fight.skill_helper import SkillHelper
from shared.db_opear.configs_data import game_configs
from shared.db_opear.configs_data.common_item import CommonItem
from app.game.redis_mode import tb_character_info
import random


class Hero(object):
    """武将类"""

    def __init__(self, character_id=0):
        """
        :field _level: 等级
        :field _break_level: 突破等级
        :field _exp: 当前等级的经验
        :field _refine: 炼体
        :field _is_guard: 是否驻守，秘境相关
        """
        self._hero_no = 0
        self._level = 1
        self._exp = 0
        self._break_level = 0
        self._refine = 0
        self._character_id = character_id
        self._is_guard = False
        self._is_online = False
        self._awake_level = 0
        self._awake_exp = 0
        self._awake_item_num = 0
        self._break_item_num = 0

        self._runt = {}

    def init_data(self, hero_property):
        self._hero_no = hero_property.get("hero_no")
        self._level = hero_property.get("level")
        self._exp = hero_property.get("exp")
        self._break_level = hero_property.get("break_level")
        self._refine = hero_property.get("refine")
        self._is_guard = hero_property.get("is_guard")
        self._is_online = hero_property.get("is_online")
        self._runt = hero_property.get("runt")
        self._awake_level = hero_property.get("awake_level", 0)
        self._awake_exp = hero_property.get("awake_exp", 0)
        self._awake_item_num = hero_property.get("awake_item_num", 0)
        self._break_item_num = hero_property.get("break_item_num", 0)

    @property
    def runt(self):
        return self._runt

    @runt.setter
    def runt(self, value):
        self._runt = value

    @property
    def refine(self):
        return self._refine

    @refine.setter
    def refine(self, value):
        self._refine = value

    @property
    def hero_no(self):
        return self._hero_no

    @hero_no.setter
    def hero_no(self, value):
        assert value != 0, "hero no cant be 0!"
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

    @property
    def awake_level(self):
        return self._awake_level

    @awake_level.setter
    def awake_level(self, value):
        self._awake_level = value

    @property
    def awake_exp(self):
        return self._awake_exp

    @awake_exp.setter
    def awake_exp(self, value):
        self._awake_exp = value

    @property
    def awake_item_num(self):
        return self._awake_item_num

    @awake_item_num.setter
    def awake_item_num(self, value):
        self._awake_item_num = value

    @property
    def break_item_num(self):
        return self._break_item_num

    @break_item_num.setter
    def break_item_num(self, value):
        self._break_item_num = value

    def get_all_exp(self):
        """根据等级+当前等级经验，得到总经验"""
        total_exp = 0
        for level in range(1, self._level):
            total_exp += game_configs.hero_exp_config[level].get('exp', 0)

        return total_exp + self._exp

    def upgrade(self, exp, player_level):
        """根据经验升级"""
        level = self._level
        temp_exp = self._exp
        temp_exp += exp
        while True:
            level_conf = game_configs.hero_exp_config.get(level)
            if not level_conf:
                break
            current_level_exp = level_conf.get('exp', 0)
            if current_level_exp <= temp_exp:
                level += 1
                temp_exp -= current_level_exp
            else:
                break

        if level > player_level:
            level = player_level
            temp_exp = game_configs.hero_exp_config[player_level].get('exp', 0)
        self.level = level
        self.exp = temp_exp

        return level, temp_exp

    def need_exp_to_max(self, player_level):
        """升到最高级, 所需经验"""
        need_exp = 0
        for level in range(self._level, player_level+1):
            level_exp = game_configs.hero_exp_config.get(level).get('exp', 0)
            if level == self._level:
                need_exp += (level_exp-self._exp)
            else:
                need_exp += level_exp
        return need_exp

    def save_data(self):
        char_obj = tb_character_info.getObj(self._character_id).getObj('heroes')
        data = self.hero_proerty_dict()
        if not char_obj.hset(data['hero_no'], data):
            logger.error('save hero error:%s', data['hero_no'])

    def hero_proerty_dict(self):
        hero_property = {
            'hero_no': self._hero_no,
            'level': self._level,
            'exp': self._exp,
            'break_level': self._break_level,
            'refine': self._refine,
            'is_guard': self._is_guard,
            'is_online': self._is_online,
            'runt': self._runt,
            'awake_level': self._awake_level,
            'awake_exp': self._awake_exp,
            'awake_item_num': self._awake_item_num,
            'break_item_num': self._break_item_num,
        }
        return hero_property

    def delete(self):
        char_obj = tb_character_info.getObj(self._character_id).getObj('heroes')
        return char_obj.hdel(self._hero_no)

    def update_pb(self, hero_pb):
        hero_pb.hero_no = self._hero_no
        hero_pb.level = self._level
        hero_pb.break_level = self._break_level
        hero_pb.exp = self._exp
        hero_pb.refine = self._refine
        hero_pb.is_guard = self._is_guard
        hero_pb.is_online = self._is_online
        hero_pb.is_guard = self._is_guard
        hero_pb.awake_level = self._awake_level
        hero_pb.awake_exp = self._awake_exp
        hero_pb.awake_item_num = self._awake_item_num
        hero_pb.break_item_num = self._break_item_num

        for (runt_type, item) in self._runt.items():
            runt_type_pb = hero_pb.runt_type.add()
            runt_type_pb.runt_type = runt_type
            for (runt_po, runt_info) in item.items():
                runt_pb = runt_type_pb.runt.add()
                runt_pb.runt_po = runt_po

                [runt_no, runt_id, main_attr, minor_attr] = runt_info
                runt_pb.runt_id = runt_id
                runt_pb.runt_no = runt_no
                for (attr_type, [attr_value_type, attr_value, attr_increment]) in main_attr.items():
                    main_attr_pb = runt_pb.main_attr.add()
                    main_attr_pb.attr_type = attr_type
                    main_attr_pb.attr_value_type = attr_value_type
                    main_attr_pb.attr_value = attr_value
                    main_attr_pb.attr_increment = attr_increment

                for (attr_type, [attr_value_type, attr_value, attr_increment]) in minor_attr.items():
                    minor_attr_pb = runt_pb.minor_attr.add()
                    minor_attr_pb.attr_type = attr_type
                    minor_attr_pb.attr_value_type = attr_value_type
                    minor_attr_pb.attr_value = attr_value
                    minor_attr_pb.attr_increment = attr_increment


    @property
    def hero_info(self):
        return game_configs.hero_config.get(self._hero_no)

    def calculate_attr(self):
        """根据属性和等级计算卡牌属性
        """
        item_config = self.hero_info

        hero_no = self._hero_no  # 英雄编号
        quality = item_config.quality  # 英雄品质

        # =============================================

        # 符文属性
        # {type_id:{po:[no,type,main,minor]}}
        all_attr = {1: 0,
                    2: 0,
                    3: 0,
                    4: 0,
                    5: 0,
                    6: 0,
                    7: 0,
                    8: 0,
                    9: 0,
                    10: 0,
                    11: 0}
        for (type_id, type_info) in self._runt.items():
            for (po, [runt_no, runt_type, main_attr, minor_attr]) in type_info.items():
                xs = 1
                if type_id != runt_type:
                    xs = game_configs.base_config.get('totemSpaceDecay')

                for (attr_type, attr_info) in main_attr.items():
                    attr_value_type, attr_value, attr_increment = attr_info
                    all_attr[attr_type] += xs * attr_value

                for (attr_type, attr_info) in minor_attr.items():
                    attr_value_type, attr_value, attr_increment = attr_info
                    all_attr[attr_type] += xs * attr_value

        # =============================================

        hp = item_config.hp + self._level * item_config.growHp + all_attr[1]  # 血
        atk = item_config.atk + self._level * item_config.growAtk + all_attr[2]  # 攻击
        physical_def = item_config.physicalDef + self._level * item_config.growPhysicalDef + all_attr[3]  # 物理防御
        magic_def = item_config.magicDef + self._level * item_config.growMagicDef + all_attr[4]  # 魔法防御
        hit = item_config.hit + all_attr[5]  # 命中率
        dodge = item_config.dodge + all_attr[6]  # 闪避率
        cri = item_config.cri + all_attr[7]  # 暴击率
        cri_coeff = item_config.criCoeff + all_attr[8]  # 暴击伤害系数
        cri_ded_coeff = item_config.criDedCoeff + all_attr[9]  # 暴击减免系数
        block = item_config.block + all_attr[10]  # 格挡率
        ductility = item_config.ductility + all_attr[11]  # 韧性

        normal_skill = self.group_by_normal
        rage_skill = self.group_by_rage
        break_skills = self.break_skill_ids


        return CommonItem(
            dict(hero_no=hero_no, quality=quality, normal_skill=normal_skill,
                 rage_skill=rage_skill, hp=hp, atk=atk,
                 physical_def=physical_def, magic_def=magic_def,
                 hit=hit, dodge=dodge, cri=cri, cri_coeff=cri_coeff,
                 cri_ded_coeff=cri_ded_coeff, block=block,
                 break_skills=break_skills, level=self._level,
                 break_level=self._break_level, ductility=ductility))

    def refine_attr(self):
        attr = CommonItem()
        if self.refine != 0:
            _refine_attr = game_configs.seal_config.get(self.refine)
            #item = CommonItem(dict(hp=0, atk=0, physicalDef=0, magicDef=0))
            for pulse in range(1, _refine_attr.pulse+1):
                lst = game_configs.seal_config.get(pulse)
                for item in lst:
                    if item.id > _refine_attr.id or item.allInt < 0:
                        continue
                    add_item = CommonItem(dict(hp=item.hp, atk=item.atk, physicalDef=item.physicalDef, magicDef=item.magicDef))
                    attr += add_item

                last_lst = game_configs.seal_config.get(pulse-1)
                if last_lst:
                    first_item = last_lst[0]
                    attr += CommonItem(dict(hp=first_item.hp, atk=first_item.atk, physicalDef=first_item.physicalDef, magicDef=first_item.magicDef))

                if _refine_attr.id == lst[-1].id:
                    first_item = lst[0]
                    attr += CommonItem(dict(hp=first_item.hp, atk=first_item.atk, physicalDef=first_item.physicalDef, magicDef=first_item.magicDef))


        return attr

    def finished_pulse(self):
        pulse = 0
        if self.refine != 0:
            _refine_attr = game_configs.seal_config.get(self.refine)
            pulse = _refine_attr.pulse - 1
            lst = game_configs.seal_config.get(_refine_attr.pulse)
            if _refine_attr.id == lst[-1].id:
                pulse += 1
        pulse += 1
        return pulse

    def runt_attr(self):
        all_attr = {1: "hp",
                    2: "atk",
                    3: "physical_def",
                    4: "magic_def",
                    5: "hit",
                    6: "dodge",
                    7: "cri",
                    8: "cri_coeff",
                    9: "cri_ded_coeff",
                    10: "block",
                    11: "ductility"}

        result_attr = {}
        # init
        for _, v in all_attr.items():
            result_attr[v] = 0

        for (type_id, type_info) in self._runt.items():
            for (po, [runt_no, runt_id, main_attr, minor_attr]) in type_info.items():
                xs = 1
                stone_info = game_configs.stone_config.get("stones").get(runt_id)
                if type_id != stone_info.get("type"):
                    xs = game_configs.base_config.get('totemSpaceDecay')

                for (attr_type, attr_info) in main_attr.items():
                    attr_value_type, attr_value, attr_increment = attr_info
                    result_attr[all_attr.get(attr_type)] += xs * attr_value

                for (attr_type, attr_info) in minor_attr.items():
                    attr_value_type, attr_value, attr_increment = attr_info
                    result_attr[all_attr.get(attr_type)] += xs * attr_value

        return result_attr

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
        hero_info = game_configs.hero_config.get(self._hero_no)
        assert hero_info!=None, "cannot find hero no %s" % self._hero_no
        skill_ids = []
        for i in range(self._break_level):
            skill_id = hero_info.get('break%s' % (i + 1))
            skill_ids.append(skill_id)

        return skill_ids

    @property
    def break_param(self):
        """突破系数*基础"""
        hero_info = game_configs.hero_config.get(self._hero_no)
        param = hero_info.get("parameters%d" % self._break_level)

        if param:
            return param
        return 0

    @property
    def hero_links(self):
        """英雄羁绊配置数据
        """
        return game_configs.link_config.get(self._hero_no, {})

    @property
    def normal_skill_id(self):
        """普通技能ID
        """
        item_config = game_configs.hero_config.get(self._hero_no)
        skill_id = item_config.normalSkill  # 普通技能
        return skill_id

    @property
    def rage_skill_id(self):
        """怒气技能ID
        """
        item_config = game_configs.hero_config.get(self._hero_no)
        rage_id = item_config.rageSkill  # 怒气技能
        return rage_id

    @property
    def group_by_normal(self):
        """根据普通技能ID获得技能buff组
        """
        normal_skill_id = self.normal_skill_id
        normal_skill_config = game_configs.skill_config.get(normal_skill_id)
        normal_group = normal_skill_config.group
        return normal_group

    @property
    def group_by_rage(self):
        """根据怒气技能ID获得技能buff组
        """
        rage_skill_id = self.rage_skill_id

        rage_skill_config = game_configs.skill_config.get(rage_skill_id)
        rage_group = rage_skill_config.group
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
    def is_guard(self):
        """
        是否驻守，秘境相关
        """
        return self._is_guard

    @is_guard.setter
    def is_guard(self, value):
        self._is_guard = value

    @property
    def is_online(self):
        """
        是否上阵
        """
        return self._is_online

    @is_online.setter
    def is_online(self, value):
        self._is_online = value

    @property
    def break_skill_buff_ids(self):
        """突破技能ID，buff组
        """
        skills = []
        skill_ids = self.break_skill_ids
        for skill_id in skill_ids:
            skill_config = game_configs.skill_config.get(skill_id)  # 技能配置
            group = skill_config.group  # buff组
            skills.extend(group)

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
                logger.error('skill config can not find id:%d' % skill)
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

    def is_awake(self):
        v = game_configs.awake_config.get(self._awake_level).get('awakeProbability')
        target_percent = random.uniform(v[0], v[1])
        if random.random() < target_percent:
            return True
        return False

    @property
    def awake_info(self):
        """docstring for awake_info"""
        v = game_configs.awake_config.get(self._awake_level)
        return v

