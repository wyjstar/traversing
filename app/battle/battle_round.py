# !/usr/bin/env python
# -*- coding: utf-8 -*-
from battle_buff import Buff
from execute_skill_buff import perform_hit, execute_skill_buff, execute_mp
from find_target_units import find_side, find_target_units
from gfirefly.server.logobj import logger
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
        self._red_units = copy.deepcopy(red_units)  # copy.deepcopy(red_units)
        self._red_best_skill = red_best_skill
        self._blue_units = copy.deepcopy(blue_units)
        self._blue_best_skill = blue_best_skill
        self._friend_skill = friend_skill

        if len(self._blue_units) == 0:
            logger.debug_cal("敌方人数为0！")
            return False
        self.enter_battle()
        return True

    def enter_battle(self):
        """
        在战斗开始前，进行触发类别为2的突破技能buff。
        """
        logger.debug_cal("    进入战场，添加的buff...")
        for temp in self._red_units.values():
            for skill_buff_info in temp.skill.begin_skill_buffs():
                target_units = find_target_units(temp, self._red_units, self._blue_units, skill_buff_info)
                self.handle_skill_buff(temp, self._red_units, self._blue_units, skill_buff_info, target_units)
                if DEBUG:
                    target_nos = []
                    for temp in target_units:
                        target_nos.append(temp.slot_no)
                    logger.debug_cal("    作用目标: %s" % (target_nos))

        for temp in self._blue_units.values():
            for skill_buff_info in temp.skill.begin_skill_buffs():
                target_units = find_target_units(temp, self._blue_units, self._red_units, skill_buff_info)
                self.handle_skill_buff(temp, self._blue_units, self._red_units, skill_buff_info, target_units)
                if DEBUG:
                    target_nos = []
                    for temp in target_units:
                        target_nos.append(temp.slot_no)
                    logger.debug_cal("    作用目标: %s" % (target_nos))

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
                # check
                self._client_data.move_to_next()
            client_skill_result = self._client_data.current()
            if not client_skill_result: return
            self.handle_special_skill(special_skill_types)

            if blue_unit and not special_skill_types.contains(FRIEND_SKILL):
                self.perform_one_skill(self._blue_units, self._red_units, blue_unit.skill)
                # check
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
                # check
                skill_types.append(BEST_SKILL)
                self._client_data.move_to_next()

            elif client_skill_result.skill_type == FRIEND_SKILL:
                self.perform_one_skill(self._red_units, self._blue_units, self._friend_skill)
                # check
                self._client_data.move_to_next()
                skill_types.append(FRIEND_SKILL)
            else:
                break

    def perform_round(self):
        """
        perform mock battle, logger.debug_cal(battle process.)
        """
        for i in range(1, 7):
            red_unit = self.get_next_unit(i, self._red_units)
            blue_unit = self.get_next_unit(i, self._blue_units)
            self.handle_mock_special_skill(self._red_best_skill)
            if red_unit:
                logger.debug_cal(("red_%d" % i) + "-" * 20 + "我方攻击" + "-" * 20)
                self.perform_one_skill(self._red_units, self._blue_units, red_unit.skill)
                self._red_best_skill.add_mp()
                self._blue_best_skill.add_mp()
                logger.debug_cal("    ")
            self.handle_mock_special_skill(self._blue_best_skill)
            if blue_unit:
                logger.debug_cal(("blue_%d" % i) + "-" * 20 + "敌方攻击" + "-" * 20)
                self.perform_one_skill(self._blue_units, self._red_units, blue_unit.skill)
                self._red_best_skill.add_mp()
                self._blue_best_skill.add_mp()
                logger.debug_cal("    ")

    def get_next_unit(self, i, units):
        temp = None

        while (not temp) and (i < 7):
            temp = units.get(i)
            i += 1
        return temp

    def handle_mock_special_skill(self, best_skill):
        if best_skill and best_skill.is_full:
            self.perform_best_skill(self._red_units, self._blue_units, best_skill)
        if self._friend_skill and self._friend_skill.is_full:
            self.perform_friend_skill(self._red_units, self._blue_units, self._friend_skill)

    def perform_one_skill(self, army, enemy, skill):
        """执行技能：普通技能或者怒气技能"""
        attacker = skill.owner
        print attacker.slot_no, attacker.unit_no, skill.main_skill_buff

        logger.debug_cal("    进行攻击: 攻击者位置(%d), 攻击者(%d), 主技能ID(%d), buff(%s)" % \
                         (attacker.slot_no, attacker.unit_no, skill.main_skill_buff.id, attacker.buff_manager))

        if not attacker.can_attack:
            logger.debug_cal("    攻击者在buff中，无法攻击！")

        main_target_units = find_target_units(attacker, army, enemy, skill.main_skill_buff, None)  # 主技能作用目标

        # 1.计算命中
        # 规则：主技能作用多个目标，只要有一个命中的，则判定命中
        is_hit = False
        for target_unit in main_target_units:
            if perform_hit(skill.main_skill_buff, attacker.hit, target_unit.dodge):
                is_hit = True

        logger.debug_cal("    是否命中:%s" % is_hit)
        # 2.主技能释放前，触发的buff
        logger.debug_cal("    1. 攻击前, 添加的buff")
        for skill_buff_info in skill.before_skill_buffs(is_hit):
            target_units = find_target_units(attacker, army, enemy, skill_buff_info, main_target_units)
            self.handle_skill_buff(attacker, army, enemy, skill_buff_info, target_units, True)

        # 3.触发攻击技能
        logger.debug_cal("    2. 攻击...")
        before_or_not = True
        for skill_buff_info in skill.attack_skill_buffs():
            if not is_hit and skill_buff_info.skill_key and skill_buff_info.effectId in (1, 2, 3):
                # 当攻击主技能没有命中，则退出
                break
            if skill_buff_info.skill_key:
                before_or_not = False
                self.handle_skill_buff(attacker, army, enemy, skill_buff_info, main_target_units, before_or_not)
                continue
            target_units = find_target_units(attacker, army, enemy, skill_buff_info, main_target_units)
            self.handle_skill_buff(attacker, army, enemy, skill_buff_info, target_units, False)


        # 在攻击技能触发完成后，处理mp
        skill.set_mp()

        # 4.主技能释放后，触发的buff
        logger.debug_cal("    3. 攻击后的buff...")
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

        logger.debug_cal("-" * 80)
        result = []
        for target_unit in target_units:
            if target_unit.hp <= 0: continue
            if skill_buff_info.effectId in [1, 2, 3, 26]:
                is_block, is_cri = execute_skill_buff(attacker, target_unit, skill_buff_info)
                if target_unit.hp <= 0:  # 如果血量为0，则去掉该unit
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

        logger.debug_cal("    技能或buffID：%s, 受击后的状态：" % (skill_buff_info.id))
        if DEBUG:
            for temp in target_units:
                if temp.hp > 0:
                    logger.debug_cal("    %s" % temp)

        # 触发反击
        for is_block, backer in result:
            for skill_buff_info in backer.skill.back_skill_buffs(True, is_block):
                target_units = find_target_units(backer, army, enemy, skill_buff_info, None, attacker)
                if DEBUG:
                    target_nos = []
                    for temp in target_units:
                        target_nos.append(temp.slot_no)
                    logger.debug_cal("    反击目标: %s" % (target_nos))
                self.handle_skill_buff(backer, army, enemy, skill_buff_info, target_units)

        logger.debug_cal("-" * 80)

    @property
    def result(self):
        """docstring for win"""
        if not self._blue_units: return 1
        if not self._red_units: return -1
        if self._blue_units and self._red_units:
            return 0





