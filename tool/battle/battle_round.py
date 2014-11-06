#!/usr/bin/env python
# -*- coding: utf-8 -*-
from configs_data.game_configs import skill_config
from configs_data.game_configs import skill_buff_config
from configs_data.game_configs import hero_config
from configs_data.game_configs import base_config, hero_breakup_config
from battle_buff import Buff, BuffManager
from execute_skill_buff import perform_hit, execute_skill_buff, execute_mp
from find_target_units import find_side, find_target_units
import copy
BEST_SKILL = 1
FRIEND_SKILL = 2
DEBUG = 1

class BattleRound(object):
    """战斗回合 """
    def __init__(self):
        self._red_units = {}
        self._blue_units = {}
        self._red_best_skill = None
        self._blue_best_skill = None
        self._friend_skill = None
        self._client_data = None

    def init_round(self, red_units, red_best_skill, blue_units, blue_best_skill=None, friend_skill=None):
        self._red_units = red_units # copy.deepcopy(red_units)
        self._red_best_skill = red_best_skill
        self._blue_units = blue_units
        self._blue_best_skill = blue_best_skill
        self._friend_skill = friend_skill
        self.enter_battle()

    def enter_battle(self):
        """
        在战斗开始前，进行触发类别为2的突破技能buff。
        """
        print "进入战场，添加的buff..."
        for temp in self._red_units.values():
            for skill_buff_info in temp.skill.begin_skill_buffs():
                target_units = find_target_units(temp, self._red_units, self._blue_units, skill_buff_info)
                self.handle_skill_buff(temp, self._red_units, self._blue_units, skill_buff_info, target_units)
                if DEBUG:
                    target_nos = []
                    for temp in target_units:
                        target_nos.append(temp.slot_no)
                    print "作用目标: %s" % (target_nos)

        for temp in self._blue_units.values():
            for skill_buff_info in temp.skill.begin_skill_buffs():
                target_units = find_target_units(temp, self._blue_units, self._red_units, skill_buff_info)
                self.handle_skill_buff(temp, self._blue_units, self._red_units, skill_buff_info, target_units)
                if DEBUG:
                    target_nos = []
                    for temp in target_units:
                        target_nos.append(temp.slot_no)
                    print "作用目标: %s" % (target_nos)

    def perform_round_check(self, client_data):
        """perform a round battle and battle check."""
        self._client_data = client_data

        client_skill_result = None
        for i in range(1, 7):
            red_unit = self._red_units.get(i)
            blue_unit = self._blue_units.get(i)
            special_skill_types = []
            client_skill_result = self._client_data.current()
            if not client_skill_result: return
            self.handle_special_skill(special_skill_types)

            if red_unit:
                self.perform_one_skill(self._red_units, self._blue_units, red_unit.skill)
                #check
                self._client_data.move_to_next()
            client_skill_result = self._client_data.current()
            if not client_skill_result: return
            self.handle_special_skill(special_skill_types)

            if blue_unit and not special_skill_types.contains(FRIEND_SKILL):
                self.perform_one_skill(self._blue_units, self._red_units, blue_unit.skill)
                #check
                self._client_data.move_to_next()

    def handle_special_skill(self, skill_types):
        """
        handle best skill and friend skill.
        """
        client_skill_result = self._client_data.current()
        while True:
            if not client_skill_result:
                break

            if client_skill_result.skill_type == BEST_SKILL:
                self.perform_one_skill(self._red_units, self._blue_units, self._best_skill)
                #check
                skill_types.append(BEST_SKILL)
                self._client_data.move_to_next()

            elif client_skill_result.skill_type == FRIEND_SKILL:
                self.perform_one_skill(self._red_units, self._blue_units, self._friend_skill)
                #check
                self._client_data.move_to_next()
                skill_types.append(FRIEND_SKILL)
            else:
                break

    def perform_round(self):
        """
        perform mock battle, print battle process.
        """
        for i in range(1, 7):
            red_unit = self._red_units.get(i)
            blue_unit = self._blue_units.get(i)
            self.handle_mock_special_skill(self._red_best_skill)
            if red_unit:
                print "-"*20 + "我方攻击" + "-"*20
                self.perform_one_skill(self._red_units, self._blue_units, red_unit.skill)
                self._red_best_skill.add_mp()
                self._blue_best_skill.add_mp()
                print ""
            self.handle_mock_special_skill(self._blue_best_skill)
            if blue_unit:
                print "-"*20 + "敌方攻击" + "-"*20
                self.perform_one_skill(self._blue_units, self._red_units, blue_unit.skill)
                self._red_best_skill.add_mp()
                self._blue_best_skill.add_mp()
                print ""

        # 每回合结束后，减buff
        for unit in self._red_units.values():
            unit.buff_manager.remove()
        for unit in self._blue_units.values():
            unit.buff_manager.remove()

    def handle_mock_special_skill(self, best_skill):
        if best_skill and best_skill.is_full:
            self.perform_best_skill(self._red_units, self._blue_units, best_skill)
        if self._friend_skill and self._friend_skill.is_full:
            self.perform_friend_skill(self._red_units, self._blue_units, self._friend_skill)

    def perform_one_skill(self, army, enemy, skill):
        """执行技能：普通技能或者怒气技能"""
        attacker = skill.owner
        print "进行攻击: 攻击者位置(%d), 攻击者(%d), 主技能ID(%d)" % (attacker.slot_no, attacker.hero_no, skill.main_skill_buff.id)

        main_target_units = find_target_units(attacker, army, enemy, skill.main_skill_buff, None) # 主技能作用目标

        # 1.计算命中
        # 规则：主技能作用多个目标，只要有一个命中的，则判定命中
        is_hit = False
        for target_unit in main_target_units:
            if perform_hit(skill.main_skill_buff, attacker.hit, target_unit.dodge):
                is_hit = True

        print "是否命中:", is_hit
        # 2.主技能释放前，触发的buff
        print "1. 攻击前, 添加的buff"
        for skill_buff_info in skill.before_skill_buffs(is_hit):
            target_units = find_target_units(attacker, army, enemy, skill_buff_info, main_target_units)
            self.handle_skill_buff(attacker, army, enemy, skill_buff_info, target_units, True)

        # 3.触发攻击技能
        print "2. 攻击..."
        before_or_not = True
        for skill_buff_info in skill.attack_skill_buffs():
            if not is_hit and skill_buff_info.skill_key and skill_buff_info.effectId in (1, 2, 3):
                # 当攻击主技能没有命中，则退出
                break
            if skill_buff_info.skill_key:
                before_or_not = False
            self.handle_skill_buff(attacker, army, enemy, skill_buff_info, main_target_units, before_or_not)

        # 在攻击技能触发完成后，处理mp
        skill.set_mp()

        # 4.主技能释放后，触发的buff
        print "3. 攻击后的buff..."
        for skill_buff_info in skill.after_skill_buffs(is_hit):
            target_units = find_target_units(attacker, army, enemy, skill_buff_info, main_target_units)
            self.handle_skill_buff(attacker, army, enemy, skill_buff_info, target_units, False)


    def perform_best_skill(self, army, enemy, skill):
        """执行技能：无双"""
        for skill_buff_info in skill.skill_buffs:
            target_units = find_target_units(None, army, enemy, skill_buff_info)
            self.handle_skill_buff(None, army, enemy, skill_buff_info, target_units)
        skill.reset_mp()

    def perform_friend_skill(self, army, enemy, skill):
        """执行技能：小伙伴"""
        self.perform_one_skill(None, army, enemy, skill)
        skill.reset_mp()

    def handle_skill_buff(self, attacker, army, enemy, skill_buff_info, target_units, before_or_not):
        """
        根据作用位置找到攻击目标，然后执行技能或者添加buff
        """
        #if DEBUG:
            #target_nos = []
            #for temp in target_units:
                #target_nos.append(temp.slot_no)
            #print "技能或者buffID（%s），作用目标: %s, %s" % (skill_buff_info.id, skill_buff_info.effectPos, target_nos)

        print "-" * 80
        result = []
        for target_unit in target_units:
            if skill_buff_info.effectId in [1, 2, 3, 26]:
                is_block, is_cri = execute_skill_buff(attacker, target_unit, skill_buff_info)
                if target_unit.hp <= 0: # 如果血量为0，则去掉该unit
                    target_side = find_side(skill_buff_info, army, enemy)
                    if target_unit.slot_no in target_side:
                        del target_side[target_unit.slot_no]

                if skill_buff_info.skill_key:
                    result.append((is_block, target_unit))
            elif skill_buff_info.effectId in [8, 9]:
                execute_mp(target_unit, skill_buff_info)
            else:
                buff = Buff(attacker, skill_buff_info, before_or_not)
                target_unit.buff_manager.add(buff)

        print "技能或buffID：%s, 受击后的状态：" % (skill_buff_info.id)
        if DEBUG:
            for temp in target_units:
                print temp

        # 触发反击
        for is_block, backer in result:
            for skill_buff_info in backer.skill.back_skill_buffs(True, is_block):
                target_units = find_target_units(backer, army, enemy, skill_buff_info, None, attacker)
                if DEBUG:
                    target_nos = []
                    for temp in target_units:
                        target_nos.append(temp.slot_no)
                    print "反击目标: %s" % (target_nos)
                self.handle_skill_buff(backer, army, enemy, skill_buff_info, target_units)

        print "-" * 80

    @property
    def result(self):
        """docstring for win"""
        if not self._blue_units: return 1
        if not self._red_units: return -1
        if self._blue_units and self._red_units:
            return 0

class BattleUnit(object):
    """战斗单元"""

    def __init__(self, slot_no, hero_name='', hero_no=0, quality=0, hp=0, atk=0, physical_def=0, magic_def=0, hit=0, dodge=0, cri=0, cri_coeff=0, cri_ded_coeff=0, block=0, ductility=0, level=0, break_level=0, mp_base=0):
        #print slot_no, hero_name, hero_no, quality, hp, atk, physical_def, magic_def, hit, dodge, cri, cri_coeff, cri_ded_coeff, block, ductility, level, break_level, mp_base
        self._slot_no = slot_no
        self._hero_name = hero_name
        self._hero_no = int(hero_no)
        self._hp = float(hp)
        self._atk = float(atk)
        self._physical_def = float(physical_def)
        self._magic_def = float(magic_def)
        self._hit = float(hit)                     # 命中率
        self._dodge = float(dodge)                 # 闪避率
        self._cri = float(cri)                     # 暴击率
        self._cri_coeff = float(cri_coeff)         # 暴击伤害系数
        self._cri_ded_coeff = float(cri_ded_coeff) # 暴击减免系数
        self._block = float(block)                 # 格挡率
        self._ductility = float(ductility)         # 韧性
        self._level = int(level)                        # 等级
        self._break_level = int(break_level)            # 突破等级
        self._mp_base = int(mp_base)                    # 武将基础mp

        self._skill = HeroSkill(self)
        self._buff_manager = BuffManager(self)


    @property
    def can_attack(self):
        return self._buff_manager.can_attack()

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
    def hero_name(self):
        return self._hero_name

    @hero_name.setter
    def hero_name(self, value):
        self._hero_name = value

    @property
    def skill(self):
        return self._skill

    @skill.setter
    def skill(self, value):
        self._skill = value

    @property
    def hero_no(self):
        return self._hero_no

    @hero_no.setter
    def hero_no(self, value):
        self._hero_no = value

    @property
    def hp(self):
        return self._hp

    @hp.setter
    def hp(self, value):
        self._hp = value

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

    def __bool__(self):
        if self._hp>0:
            return True
        return False

    __nonzero__=__bool__
    def __repr__(self):
        return ("位置(%d), 武将名称(%s), 编号(%s), hp(%s), 攻击(%s), 物防(%s), 魔防(%s), \
                命中(%s), 闪避(%s), 暴击(%s), 暴击伤害系数(%s), 暴击减免系数(%s), 格挡(%s), 韧性(%s), 等级(%s), 突破等级(%s), mp初始值(%s), buffs(%s)") \
                %(self._slot_no, self._hero_name, self._hero_no, self._hp, self._atk, self._physical_def, self._magic_def,
            self._hit, self._dodge, self._cri, self._cri_coeff, self._cri_ded_coeff, self._block, self._ductility, self._level, self._break_level, self._mp_base, self.buff_manager)

class HeroSkill(object):
    """docstring for HeroSkill"""
    def __init__(self, unit):
        super(HeroSkill, self).__init__()
        mp_config = base_config.get('chushi_value_config')
        self._hero_no = unit.hero_no
        self._mp = mp_config[0]
        self._mp_step = mp_config[1]
        self._mp_max = mp_config[2]
        self._owner = unit
        self._main_normal_skill_buff = None
        self._main_mp_skill_buff = None
        self._attack_normal_skill_buffs = []
        self._attack_mp_skill_buffs = []
        self._has_skill_buff = False
        self._break_skill_buffs = {}
        hero = hero_config.get(self._hero_no)
        skill_info = skill_config.get(hero.normalSkill, None)
        self._main_normal_skill_buff, self._attack_normal_skill_buffs, self._has_normal_treat_skill_buff = self.get_skill_buff(skill_info.get("group"))

        #print "normal skill:", skill_info.get("group"),self._main_normal_skill_buff, self._attack_normal_skill_buffs, self._has_normal_treat_skill_buff

        skill_info = skill_config.get(hero.rageSkill, None)
        self._main_mp_skill_buff, self._attack_mp_skill_buffs, self._has_mp_treat_skill_buff = self.get_skill_buff(skill_info.get("group"))
        skill_info = skill_config.get(hero.rageSkill, None)

        #print "mp skill:", skill_info, self._main_mp_skill_buff, self._attack_mp_skill_buffs, self._has_mp_treat_skill_buff
        for id in self.hero_break_skill_buff_ids():
            skill_buff_info = skill_buff_config.get(id)
            trigger_type = skill_buff_info.triggerType
            if trigger_type not in self._break_skill_buffs:
                self._break_skill_buffs[trigger_type] = []
            self._break_skill_buffs[trigger_type].append(skill_buff_info)

    def get_skill_buff(self, skill_buff_ids):
        main_skill_buff = None
        attack_skill_buffs = []
        has_treat_skill_buff = False
        for id in skill_buff_ids:
            skill_buff_info = skill_buff_config.get(id)
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

    def hero_break_skill_buff_ids(self):
        hero_break_skill_buff_ids = []
        hero_break_skill_ids = []
        hero_break_info = hero_breakup_config.get(self._hero_no)

        for i in range(self._owner.break_level):
            hero_break_skill_ids.append(hero_break_info.get_skill_id(i+1))

        for skill_id in hero_break_skill_ids:
            skill_info = skill_config.get(skill_id, None)
            if skill_info:
                hero_break_skill_buff_ids.extend(skill_info.get("group"))
        return hero_break_skill_buff_ids

    @property
    def main_skill_buff(self):
        """普通技能或者怒气技能中的主技能"""
        if self.is_full:
            return self._main_mp_skill_buff
        return self._main_normal_skill_buff

    @property
    def has_treat_skill(self):
        """普通技能或者怒气技能中是否包含治疗技能(triggerType==26)"""
        if self.is_full:
            return self._has_mp_treat_skill_buff
        return self._has_normal_treat_skill_buff

    def attack_skill_buffs(self):
        """普通技能或者怒气技能中除主技能外的技能"""
        if self.is_full:
            return self._attack_mp_skill_buffs
        return self._attack_normal_skill_buffs

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

    def set_mp(self):
        """
        攻击结束后，修改怒气值。
        """
        if self.is_full:
            self._mp = self._owner._mp_base
        else:
            self._mp += self._mp_step

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

class BestSkill(object):
    """docstring for BestSkill"""
    def __init__(self, mp, skill_no):
        super(BestSkill, self).__init__()
        best_mp_config = base_config.get('wushang_value_config')
        self._mp = best_mp_config[0]
        self._skill_no = skill_no
        self._mp_step = best_mp_config[1]
        self._mp_max_1 = best_mp_config[2]
        self._mp_max_2 = best_mp_config[3]
        self._mp_max_3 = best_mp_config[4]
        self._skill_buffs = []
        skill_info = skill_config.get(self._skill_no, None)
        if skill_info:
            for buff_id in  skill_info.group:
                self._skill_buffs.append(skill_buff_config.get(buff_id))

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
        #释放技能后，减少怒气
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
            #如果超过最大怒气，赋值为最大怒气,
            if self._mp > self._mp_max_3:
                self._mp = self._mp_max_3


class FriendSkill(object):
    """docstring for FriendSkill"""
    def __init__(self, unit):
        super(FriendSkill, self).__init__()
        friend_mp_config = base_config.get('huoban_value_config')
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
        return self._unit.skill.before_skill_buffs(is_hit)

    def after_skill_buffs(self, is_hit):
        return self._unit.skill.after_skill_buffs(is_hit)

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
