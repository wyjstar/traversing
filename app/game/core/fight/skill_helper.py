# -*- coding:utf-8 -*-
"""
created by server on 14-7-22下午3:07.
"""


class SkillHelper(object):
    """Skill helper
    """
    def __init__(self, skills=[]):
        self._skills = skills

        self._buffs = []

    @property
    def buffs(self):
        return self._buffs

    def init_attr(self):
        for skill in self._skills:
            buffs = skill.buffs
            for buff in buffs:
                self.add_buff(buff)

    def add_buff(self, add_buff):
        """添加合并
        :param add_buff:
        :return:
        """
        buff = self.get_buff(add_buff)
        if buff:
            buff += add_buff
        else:
            self._buffs.append(buff)

    def get_buff(self, add_buff):
        for buff in self._buffs:
            if buff == add_buff:
                return buff
        return None



