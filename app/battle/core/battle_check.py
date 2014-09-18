# -*- coding:utf-8 -*-
"""
created by server on 14-9-11上午11:00.
"""

class BattleCheck(object):
    """战斗验证 pve时候做验证
    """
    def __init__(self, battle_data):
        self.camp = battle_data.camp
        self.exectuor = battle_data.exectuor
        self.skill_id = battle_data.skill_id
        self.skill_type = battle_data.skill_type
        self.buffs = battle_data.buffs

