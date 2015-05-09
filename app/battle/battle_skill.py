# -*- coding:utf-8 -*-
"""
created by server on 14-11-10下午3:43.
"""

from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger_cal
from gfirefly.server.logobj import logger


class UnitSkill(object):
    """docstring for UnitSkill"""

    def __init__(self, unit, unit_config, mp_config):
        self._unit_no = unit.unit_no
        self._mp = mp_config[0]
        self._mp_step = mp_config[1]
        self._mp_max = mp_config[2]
        self._owner = unit
        self._main_normal_skill_buff = None
        self._main_mp_skill_buff = None
        self._attack_normal_skill_buffs = []
        self._attack_mp_skill_buffs = []
        self._has_skill_buff = False
        logger.debug("skill %s" % self._unit_no)
        temp_unit = unit_config.get(self._unit_no)
        skill_info = game_configs.skill_config.get(temp_unit.normalSkill, None)
        self._main_normal_skill_buff, self._attack_normal_skill_buffs, self._has_normal_treat_skill_buff = \
            self.get_skill_buff(skill_info.get("group"))

        skill_info = game_configs.skill_config.get(temp_unit.rageSkill, None)
        self._main_mp_skill_buff, self._attack_mp_skill_buffs, self._has_mp_treat_skill_buff = self.get_skill_buff(
            skill_info.get("group"))

    def get_skill_buff(self, skill_buff_ids):
        main_skill_buff = None
        attack_skill_buffs = []
        has_treat_skill_buff = False
        for id in skill_buff_ids:
            skill_buff_info = game_configs.skill_buff_config.get(id)
            if skill_buff_info.skill_key:
                main_skill_buff = skill_buff_info
            attack_skill_buffs.append(skill_buff_info)
            if skill_buff_info.triggerType == 26:
                has_treat_skill_buff = True

        return main_skill_buff, attack_skill_buffs, has_treat_skill_buff

    @property
    def is_full(self):
        """docstring for is_full"""
        if self._mp == self._mp_max:
            return True
        return False

    @property
    def main_skill_buff(self):
        """普通技能或者怒气技能中的主技能"""
        if self.is_mp_skill():
            return self._main_mp_skill_buff
        return self._main_normal_skill_buff

    def is_mp_skill(self):
        return self.is_full and (not self._owner.buff_manager.is_slient())

    def attack_skill_buffs(self):
        """普通技能或者怒气技能中除主技能外的技能"""
        if self.is_full:
            return self._attack_mp_skill_buffs
        return self._attack_normal_skill_buffs

    @property
    def has_treat_skill(self):
        """普通技能或者怒气技能中是否包含治疗技能(triggerType==26)"""
        if self.is_full:
            return self._has_mp_treat_skill_buff
        return self._has_normal_treat_skill_buff

    def set_mp(self, is_mp_skill):
        """
        攻击结束后，修改怒气值。
        """
        if not is_mp_skill:
            self._mp += self._mp_step
            logger_cal.debug("正常添加 mp：%s" % self._mp_step)
            if self._mp > self._mp_max:
                self._mp = self._mp_max

        else:
            self._mp = self._owner._mp_base
            logger_cal.debug("重置 mp: %s" % self._mp)

    @property
    def owner(self):
        return self._owner

    @property
    def mp(self):
        return self._mp

    @mp.setter
    def mp(self, value):
        if value < 0:
            self._mp = 0
        elif value > self._mp_max:
            self._mp = self._mp_max
        else:
            self._mp = value


class HeroSkill(UnitSkill):
    """武将技能"""
    def __init__(self, unit):
        mp_config = game_configs.base_config.get('chushi_value_config')
        if unit.is_break:
            mp_config = game_configs.base_config.get('stage_break_angry_value')
        elif unit.is_awake:
            mp_config = game_configs.base_config.get('angryValueAwakeHero')
        super(HeroSkill, self).__init__(unit, game_configs.hero_config, mp_config)
        self._break_skill_ids = []
        self._break_skill_buffs = {}

    def before_skill_buffs(self, is_hit):
        """主技能释放前，执行的buff(triggerType==10)"""
        if is_hit:
            return self._break_skill_buffs.get(10, [])
        return []

    def after_skill_buffs(self, is_hit):
        """主技能释放前，执行的buff(triggerType==6, 7, 8, 9)"""
        temp = []

        if self.has_treat_skill:
            temp.extend(self._break_skill_buffs.get(9, []))

        if not is_hit:
            return temp

        if self.is_full:
            temp.extend(self._break_skill_buffs.get(7, []))
        else:
            temp.extend(self._break_skill_buffs.get(6, []))

        temp.extend(self._break_skill_buffs.get(8, []))

        return temp

    def back_skill_buffs(self, is_hit, is_block):
        """ 反击技能 """
        temp = []
        if not is_hit:
            return temp
        temp.extend(self._break_skill_buffs.get(4, []))
        if is_block:
            temp.extend(self._break_skill_buffs.get(5, []))
        return temp

    def begin_skill_buffs(self):
        """进入战场时，施加的buff"""
        return self._break_skill_buffs.get(2, [])

    @property
    def break_skill_ids(self):
        """break skill buff ids"""
        return self._break_skill_ids

    @break_skill_ids.setter
    def break_skill_ids(self, value):
        self._break_skill_ids = value
        for id in self._break_skill_ids:
            skill_buff_info = game_configs.skill_buff_config.get(id)
            trigger_type = skill_buff_info.triggerType
            if trigger_type not in self._break_skill_buffs:
                self._break_skill_buffs[trigger_type] = []
            self._break_skill_buffs[trigger_type].append(skill_buff_info)


class MonsterSkill(UnitSkill):
    """怪物技能"""
    def __init__(self, unit):
        mp_config = game_configs.base_config.get('chushi_value_config')
        super(MonsterSkill, self).__init__(unit, game_configs.monster_config, mp_config)

    def before_skill_buffs(self, is_hit):
        return []

    def after_skill_buffs(self, is_hit):
        return []

    def back_skill_buffs(self, is_hit, is_block):
        return []

    def begin_skill_buffs(self):
        return []


class BestSkill(object):
    """docstring for BestSkill"""

    def __init__(self, skill_no, player_level):
        super(BestSkill, self).__init__()
        best_mp_config = game_configs.base_config.get('wushang_value_config')
        self._mp = best_mp_config[0]
        self._skill_no = skill_no
        self._mp_step = best_mp_config[1]
        self._mp_max_1 = best_mp_config[2]
        self._mp_max_2 = best_mp_config[3]
        self._mp_max_3 = best_mp_config[4]
        self._skill_buffs = []
        self._player_level = player_level
        skill_info = game_configs.skill_config.get(self._skill_no, None)
        if skill_info:
            for buff_id in skill_info.group:
                self._skill_buffs.append(game_configs.skill_buff_config.get(buff_id))

    def is_full(self):
        """只进行最后的三段攻击"""
        if self._mp == self._mp_max_3:
            return True
        return False

    def is_can(self):
        """
        可进行多段攻击
        """
        return self._mp >= self._mp_max_1

    @property
    def skill_buffs(self):
        """docstring for skill_buff_ids"""
        return self._skill_buffs

    def reset_mp(self):
        # 释放技能后，减少怒气
        if self._mp == self._mp_max_3:
            self._mp = 0
        elif self._mp >= self._mp_max_2:
            self._mp = self._mp - self._mp_max_2
        elif self._mp >= self._mp_max_1:
            self._mp = self._mp - self._mp_max_1

        return []

    def add_mp(self):
        """docstring for add_mp"""
        if not self.is_full():
            self._mp += self._mp_step
            # 如果超过最大怒气，赋值为最大怒气,
            if self._mp > self._mp_max_3:
                self._mp = self._mp_max_3

    @property
    def player_level(self):
        return self._player_level

    @player_level.setter
    def player_level(self, value):
        self._player_level = value


class BestSkillNone(object):
    """docstring for BestSkill"""

    def __init__(self):
        super(BestSkillNone, self).__init__()

    def is_full(self):
        return False

    def is_can(self):
        return False

    @property
    def skill_buffs(self):
        """docstring for skill_buff_ids"""
        return []

    def reset_mp(self):
        # 释放技能后，减少怒气
        pass

    def add_mp(self):
        pass


class FriendSkill(object):
    """docstring for FriendSkill"""

    def __init__(self, unit):
        super(FriendSkill, self).__init__()
        friend_mp_config = game_configs.base_config.get('huoban_value_config')
        self._unit = unit
        self._mp_init = friend_mp_config[0]
        self._mp = self._mp_init
        self._mp_step = friend_mp_config[1]
        self._mp_max = friend_mp_config[2]

    def is_full(self):
        """docstring for is_full"""
        if self._mp == self._mp_max:
            return True
        return False

    @property
    def skill_buff_ids(self):
        return self._unit.skill_buff_ids

    def before_skill_buffs(self, is_hit):
        return []

    def after_skill_buffs(self, is_hit):
        return []

    def attack_skill_buffs(self):
        """docstring for attack_skill_buffs"""
        return self._unit._attack_mp_skill_buffs

    def reset_mp(self):
        """
        reset mp
        """
        self._mp = self._mp_init

    def add_mp(self):
        """docstring for add_mp"""
        if not self.is_full:
            self._mp += self._mp_step
        if self._mp > self._mp_max:
            self._mp = self._mp_max


class FriendSkillNone(object):
    """docstring for FriendSkill"""

    def __init__(self):
        super(FriendSkillNone, self).__init__()

    def is_full(self):
        return False

    def attack_skill_buffs(self):
        """docstring for attack_skill_buffs"""
        return []

    def reset_mp(self):
        """
        reset mp
        """
        pass

    def add_mp(self):
        """docstring for add_mp"""
        pass
