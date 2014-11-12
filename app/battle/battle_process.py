# !/usr/bin/env python
# -*- coding: utf-8 -*-
from battle_round import BattleRound
from shared.db_opear.configs_data.game_configs import base_config
from battle_skill import BestSkill
from gfirefly.server.logobj import logger


class BattlePVPProcess(object):
    """pvp"""

    def __init__(self, red_units, red_best_skill_no, blue_units, blue_best_skill_no):
        self._red_units = red_units
        self._blue_units = blue_units

        self._red_best_skill = BestSkill(red_best_skill_no)
        self._blue_best_skill = BestSkill(blue_best_skill_no)
        logger.debug("我方阵容:")
        for k, v in self._red_units.items():
            print k, v
        logger.debug("-" * 80)
        print "敌方阵容:"
        for k, v in self._blue_units.items():
            print k, v
        logger.debug("-" * 80)

    def process(self):
        """docstring for process"""
        battle_round = BattleRound()
        battle_round.init_round(self._red_units, self._red_best_skill, self._blue_units, self._blue_best_skill)
        logger.debug("开始战斗...")

        for i in range(base_config.get("max_times_fight")):
            i = i + 1
            print "第%d回合......" % i
            battle_round.perform_round()
            result = battle_round.result
            if result == 0: continue
            if result == 1:
                logger.debug("我赢了。")
                return True
            if result == -1:
                logger.debug("我输了。")
                return False
        return False


class BattlePVEProcess(object):
    """pve"""

    def __init__(self, red_units, red_best_skill, blue_groups, friend_skill):
        super(BattlePVEProcess, self).__init__()
        self._red_units = red_units
        self._blue_groups = blue_groups
        self._red_best_skill = red_best_skill
        self._friend_skill = friend_skill
        print "我方阵容:"
        for k, v in self._red_units.items():
            print k, v
        print "-" * 80
        print "敌方阵容:"
        for item in blue_groups:
            for k, v in item.items():
                print k, v
            print 'next group:'
        print "-" * 80

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
                print "I finally win the battle."
                break
            if result == -1:
                print "I finally lose the battle."
                break


class BattlePVBProcess(object):
    """世界boss"""
    pass


