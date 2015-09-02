# !/usr/bin/env python
# -*- coding: utf-8 -*-
from battle_buff import Buff
from execute_skill_buff import check_hit, check_block
from find_target_units import find_target_units
from gfirefly.server.logobj import logger_cal
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

    def init_round(self, red_units, red_best_skill, blue_units, blue_best_skill, friend_skill):
        self._red_units = copy.deepcopy(red_units)  # copy.deepcopy(red_units)
        self._red_best_skill = red_best_skill
        self._blue_units = copy.deepcopy(blue_units)
        self._blue_best_skill = blue_best_skill
        self._friend_skill = friend_skill

        if len(self._blue_units) == 0:
            logger_cal.debug("敌方人数为0！")
            return False
        self.enter_battle()
        return True

    def enter_battle(self):
        """
        在战斗开始前，进行触发类别为2的突破技能buff
        """
        logger_cal.debug("    进入战场，添加的buff...")
        for temp in self._red_units.values():
            for skill_buff_info in temp.skill.begin_skill_buffs():
                target_units, target_side = find_target_units(temp, self._red_units, self._blue_units, skill_buff_info)
                self.handle_skill_buff(temp, target_side, target_units, skill_buff_info)
                if DEBUG:
                    target_nos = []
                    for temp in target_units:
                        target_nos.append(temp.slot_no)
                    logger_cal.debug("    作用目标: %s" % (target_nos))

        for temp in self._blue_units.values():
            for skill_buff_info in temp.skill.begin_skill_buffs():
                target_units, target_side = find_target_units(temp, self._blue_units, self._red_units, skill_buff_info)
                self.handle_skill_buff(temp, target_side, target_units, skill_buff_info)
                if DEBUG:
                    target_nos = []
                    for temp in target_units:
                        target_nos.append(temp.slot_no)
                    logger_cal.debug("    作用目标: %s" % (target_nos))

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
        perform mock battle, logger_cal.debug(battle process.)
        """
        logger_cal.debug("回合开始前，执行buff")
        self.perform_buff(self._red_units)
        self.perform_buff(self._blue_units)
        for i in range(1, 7):
            red_unit = self._red_units.get(i)
            self.handle_mock_special_skill(self._red_best_skill)
            if red_unit:
                logger_cal.debug(("red_%d" % i) + "-" * 20 + "我方攻击" + "-" * 20)
                self.perform_one_skill(self._red_units, self._blue_units, red_unit.skill)
                self._red_best_skill.add_mp()
                self._blue_best_skill.add_mp()
                logger_cal.debug("    ")
            self.handle_mock_special_skill(self._blue_best_skill)
            blue_unit = self._blue_units.get(i)
            if blue_unit:
                logger_cal.debug(("blue_%d" % i) + "-" * 20 + "敌方攻击" + "-" * 20)
                self.perform_one_skill(self._blue_units, self._red_units, blue_unit.skill)
                self._red_best_skill.add_mp()
                self._blue_best_skill.add_mp()
                logger_cal.debug("    ")

        self.remove_buff(self._red_units)
        self.remove_buff(self._blue_units)
        return self._red_units, self._blue_units

    def remove_buff(self, units):
        """docstring for remove_buff"""
        deads = []
        for k, temp in units.items():
            temp.buff_manager.remove()
            if temp.hp <= 0:
                deads.append(k)
        for k in deads:
            units.pop(k)

    def perform_buff(self, units):
        for k, temp in units.items():
            logger_cal.debug("武将: %s" % temp.unit_no)
            temp.buff_manager.perform_buff()


    def handle_mock_special_skill(self, best_skill):
        self.perform_best_skill(self._red_units, self._blue_units, best_skill)
        self.perform_friend_skill(self._red_units, self._blue_units, self._friend_skill)

    def perform_one_skill(self, army, enemy, skill):
        """执行技能：普通技能或者怒气技能"""
        attacker = skill.owner


        is_mp_skill = skill.is_mp_skill()
        logger_cal.debug("is_mp_skill %s" % is_mp_skill)
        logger_cal.debug("    进行攻击: 攻击者位置(%d), 攻击者(%d), 主技能ID(%d), buff(%s)" % \
                         (attacker.slot_no, attacker.unit_no, skill.main_skill_buff.id, attacker.buff_manager))

        if not attacker.buff_manager.is_dizzy():
            logger_cal.debug("    攻击者在buff中，无法攻击！")
            return

        main_target_units, main_target_side = find_target_units(attacker, army, enemy, skill.main_skill_buff)  # 主技能作用目标

        # 1.计算命中, 格挡
        # 规则：主技能作用多个目标，只要有一个命中的，则判定命中
        is_main_hit = False
        main_target_unit_infos = []

        for target_unit in main_target_units:
            if check_hit(skill.main_skill_buff, attacker.hit, target_unit.dodge):
                is_main_hit = True
            block_or_not = check_block(attacker, target_unit, skill.main_skill_buff)
            main_target_unit_infos.append((target_unit, block_or_not))


        logger_cal.debug("    是否命中:%s" % is_main_hit)
        # 2.主技能释放前，触发的buff
        logger_cal.debug("    1. 攻击前, 添加的buff")
        for skill_buff_info in skill.before_skill_buffs(is_main_hit):
            target_units, target_side = find_target_units(attacker, army, enemy, skill_buff_info, main_target_units)
            self.handle_skill_buff(attacker, target_side, target_units, skill_buff_info)

        # 3.触发攻击技能
        logger_cal.debug("    2. 攻击...")
        for skill_buff_info in skill.attack_skill_buffs():
            if not is_main_hit and skill_buff_info.skill_key and skill_buff_info.effectId in (1, 2, 3):
                # 当攻击主技能没有命中，则退出
                break
            if skill_buff_info.skill_key:
                self.handle_skill_buff(attacker, main_target_side, main_target_units, skill_buff_info)
                continue
            target_units, target_side = find_target_units(attacker, army, enemy, skill_buff_info, main_target_units)
            self.handle_skill_buff(attacker, target_side, target_units, skill_buff_info)


        # 4.主技能释放后，触发的buff
        logger_cal.debug("    3. 攻击后的buff...")
        for skill_buff_info in skill.after_skill_buffs(is_main_hit):
            target_units, target_side = find_target_units(attacker, army, enemy, skill_buff_info, main_target_units)
            self.handle_skill_buff(attacker, target_side, target_units, skill_buff_info)
        # 在攻击技能触发完成后，处理mp
        skill.set_mp(is_mp_skill)

        # 5. 反击
        for backer, is_block in main_target_unit_infos:
            for skill_buff_info in backer.skill.back_skill_buffs(is_main_hit, is_block):
                target_units, target_side = find_target_units(backer, army, enemy, skill_buff_info, main_target_units=None, target=attacker)
                target_nos = []
                for temp in target_units:
                    target_nos.append(temp.slot_no)
                logger_cal.debug("    反击目标: %s" % (target_nos))
                buff = Buff(target_side, attacker, skill_buff_info, is_block)
                target_unit.buff_manager.add(buff)

    def perform_best_skill(self, army, enemy, skill):
        """执行技能：无双"""
        if not skill.is_full():
            return
        for skill_buff_info in skill.skill_buffs:
            target_units, target_side = find_target_units(None, army, enemy, skill_buff_info, None)
            demage_hp = skill.player_level * skill_buff_info.levelEffectValue
            for target_unit in target_units:
                target_unit.hp -= demage_hp
            logger_cal.debug("无双的伤害值为 %s" % demage_hp)

        skill.reset_mp()

    def perform_friend_skill(self, army, enemy, skill):
        """执行技能：小伙伴"""
        if not skill.is_full():
            return
        self.perform_one_skill(army, enemy, skill)
        skill.reset_mp()

    def handle_skill_buff(self, attacker, target_side, target_units, skill_buff_info):
        """
        根据作用位置找到攻击目标，然后执行技能或者添加buff
        """
        logger_cal.debug("-" * 80)
        for target_unit in target_units:
            buff = Buff(target_side, attacker, skill_buff_info)
            target_unit.buff_manager.add(buff)

        logger_cal.debug("    技能或buffID：%s, 受击后的状态：" % (skill_buff_info.id))

        for temp in target_units:
            if temp.hp > 0:
                logger_cal.debug("    %s" % temp)

        logger_cal.debug("-" * 80)

    @property
    def result(self):
        """docstring for win"""
        if not self._blue_units: return 1
        if not self._red_units: return -1
        if self._blue_units and self._red_units:
            return 0





