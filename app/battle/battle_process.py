# !/usr/bin/env python
# -*- coding: utf-8 -*-
from battle_round import BattleRound
from shared.db_opear.configs_data import game_configs
from battle_skill import BestSkill, BestSkillNone, FriendSkillNone
from gfirefly.server.logobj import logger_cal
from battle_buff import Buff


class BattlePVPProcess(object):
    """pvp"""

    def __init__(self, red_units, red_best_skill_no, red_player_level, blue_units, blue_best_skill_no, blue_player_level):
        self._red_units = red_units
        self._blue_units = blue_units

        self._red_best_skill = BestSkill(red_best_skill_no, red_player_level) if red_best_skill_no else BestSkillNone()
        self._blue_best_skill = BestSkill(blue_best_skill_no, blue_player_level) if blue_best_skill_no else BestSkillNone()
        self._firent_skill = FriendSkillNone()
        logger_cal.debug("我方阵容:")
        for k, v in self._red_units.items():
            logger_cal.debug("%d %s" % (k, v))
        logger_cal.debug("-" * 80)
        logger_cal.debug("敌方阵容:")
        for k, v in self._blue_units.items():
            logger_cal.debug("%d %s" % (k, v))
        logger_cal.debug("-" * 80)

    def process(self):
        """docstring for process"""
        battle_round = BattleRound()
        if not battle_round.init_round(self._red_units, self._red_best_skill, self._blue_units, self._blue_best_skill, self._firent_skill):
            return True
        logger_cal.debug("开始战斗...")

        for i in range(game_configs.base_config.get("max_times_fight")):
            i = i + 1
            logger_cal.debug("第%d回合......" % i)
            battle_round.perform_round()
            result = battle_round.result
            if result == 0:
                continue
            if result == 1:
                logger_cal.debug("我赢了。")
                return True
            if result == -1:
                logger_cal.debug("我输了。")
                return False
        return False


class BattlePVEProcess(object):
    """pve"""

    def __init__(self, red_units, red_best_skill, red_player_level, blue_groups, blue_player_level, friend_skill):
        super(BattlePVEProcess, self).__init__()
        self._red_units = red_units
        self._blue_groups = blue_groups
        self._red_best_skill = red_best_skill
        self._friend_skill = friend_skill
        logger_cal.debug("我方阵容:")
        for k, v in self._red_units.items():
            logger_cal.debug(k, v)
        logger_cal.debug("-" * 80)
        logger_cal.debug("敌方阵容:")
        for item in blue_groups:
            for k, v in item.items():
                logger_cal.debug(k, v)
            logger_cal.debug('next group:')
        logger_cal.debug("-" * 80)

    def process(self):
        """docstring for process"""
        battle_round = BattleRound()
        battle_round.init_round(self._red_units, self._red_best_skill, self._blue_groups.pop(0),
                                friend_skill=self._friend_skill)
        while True:
            battle_round.perform_round()
            result = battle_round.result
            if result == 0: continue
            if result == 1 and self.blue_groups:
                battle_round.init_round(self._red_units, self._red_best_skill, self._blue_groups.pop(0),
                                        friend_skill=self._friend_skill)
                continue
            if result == 1:
                logger_cal.debug("I finally win the battle.")
                break
            if result == -1:
                logger_cal.debug("I finally lose the battle.")
                break


class BattlePVBProcess(object):
    """世界boss"""
    def __init__(self, red_units, red_player_level, red_best_skill_no, blue_units, debuff_no=0):
        self._red_units = red_units
        self._blue_units = blue_units

        # add debuff
        skill_info = game_configs.skill_config.get(debuff_no)
        if skill_info:
            for k, v in blue_units.items():
                for temp in skill_info.group:
                    skill_buff_info = game_configs.skill_buff_config.get(temp)
                    if not skill_buff_info:
                        continue

                    buff = Buff(blue_units, None, skill_buff_info)
                    v.buff_manager.add(buff)

        self._red_best_skill = BestSkill(red_best_skill_no, red_player_level) if red_best_skill_no else BestSkillNone()
        self._blue_best_skill = BestSkillNone()
        self._firent_skill = FriendSkillNone()
        logger_cal.debug("我方阵容:")
        for k, v in self._red_units.items():
            logger_cal.debug("%d %s" % (k, v))
        logger_cal.debug("-" * 80)
        logger_cal.debug("敌方阵容:")
        for k, v in self._blue_units.items():
            logger_cal.debug("%d %s" % (k, v))
        logger_cal.debug("-" * 80)

    def process(self):
        """docstring for process"""
        battle_round = BattleRound()
        if not battle_round.init_round(self._red_units, self._red_best_skill, self._blue_units, self._blue_best_skill, self._firent_skill):
            return True
        logger_cal.debug("开始战斗...")

        #return True, 0
        blue_units = None
        for i in range(game_configs.base_config.get("max_times_fight")):
            i = i + 1
            logger_cal.debug("第%d回合......" % i)
            red_units, blue_units = battle_round.perform_round()
            result = battle_round.result
            if result == 0: continue
            if result == 1:
                logger_cal.debug("我赢了。")
                return True, 0
            if result == -1:
                logger_cal.debug("我输了。")
                return False, blue_units.get(5).hp
        logger_cal.debug("我输了。")
        return False, blue_units.get(5).hp


