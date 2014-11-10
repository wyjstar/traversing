# !/usr/bin/env python
# -*- coding: utf-8 -*-
from battle_round import BattleRound


class BattlePVPProcess(object):
    """docstring for BattleProcess"""

    def __init__(self, red_units, red_best_skill, blue_units, blue_best_skill):
        self._red_units = red_units
        self._blue_units = blue_units
        self._red_best_skill = red_best_skill
        self._blue_best_skill = blue_best_skill
        print "我方阵容:"
        for k, v in self._red_units.items():
            print k, v
        print "-" * 80
        print "敌方阵容:"
        for k, v in self._blue_units.items():
            print k, v
        print "-" * 80

    def process(self):
        """docstring for process"""
        battle_round = BattleRound()
        battle_round.init_round(self._red_units, self._red_best_skill, self._blue_units, self._blue_best_skill)
        print "开始战斗..."

        i = 1
        while True:
            print "第%d回合......" % i
            i = i + 1
            battle_round.perform_round()
            result = battle_round.result
            if result == 0: continue
            if result == 1:
                print "I finally win the battle."
                break
            if result == -1:
                print "I finally lose the battle."
                break


class BattlePVEProcess(object):
    """docstring for BattleProcess"""

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


