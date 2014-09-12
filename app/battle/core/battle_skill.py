# -*- coding:utf-8 -*-
"""
created by server on 14-9-10下午5:33.
"""

class BattleSkill(object):
    """战斗内skill
    """
    def __init__(self, skill):
        self.id = skill.id
        self.canBreak = skill.canBreak  #skill_config action 0 can't break otherwise can break
        self.buf = skill.buf

    # @property
    # def no(self):
    #     return self._no
    #
    # @no.setter
    # def no(self, no):
    #     self._no = no