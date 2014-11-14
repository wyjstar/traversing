#!/usr/bin/env python
# -*- coding: utf-8 -*-
from gfirefly.server.logobj import logger

class BuffManager(object):
    """docstring for BattleBuffManager"""
    def __init__(self, owner):
        super(BuffManager, self).__init__()
        self._owner = owner
        self._buffs = {}
        self._skills = {}

    def add(self, buff):
        """
        add a buff.
        """
        effect_id = buff.skill_buff_info.effectId
        if effect_id not in self._buffs:
            self._buffs[effect_id] = []
        self._buffs[effect_id].append(buff)

    def remove(self):
        """docstring for remove"""
        for k, value in self._buffs.items():
            temp = []
            for buff in value:
                # logger.debug_cal(str(buff.skill_buff_info.id)+"*"*60+str(buff.continue_num))
                buff.continue_num -= 1
                if buff.continue_num > 0:
                    temp.append(buff)
            self._buffs[k] = temp

    def get_buffed_dodge(self, dodge):
        """
        get buffed dodge
        """
        temp_buffs = self._buffs.get(16, [])

        for buff_info in temp_buffs:
            dodge += self.get_buff_value(buff_info)
        temp_buffs = self._buffs.get(17, [])

        for buff_info in temp_buffs:
            dodge -= self.get_buff_value(buff_info)
        return dodge

    def get_buffed_atk(self, atk):
        """
        get buffed atk
        """
        temp_buffs = self._buffs.get(6, [])

        for buff_info in temp_buffs:
            atk += self.get_buff_value(buff_info)
        temp_buffs = self._buffs.get(7, [])

        for buff_info in temp_buffs:
            atk -= self.get_buff_value(buff_info)
        return atk

    def get_buffed_physical_def(self, physical_def):
        """
        get buffed physical_def
        """
        temp_buffs = self._buffs.get(10, [])

        for buff_info in temp_buffs:
            physical_def += self.get_buff_value(buff_info)
        temp_buffs = self._buffs.get(11, [])

        for buff_info in temp_buffs:
            physical_def -= self.get_buff_value(buff_info)
        return physical_def

    def get_buffed_magic_def(self, magic_def):
        """
        get buffed  magic_def
        """
        temp_buffs = self._buffs.get(12, [])

        for buff_info in temp_buffs:
            magic_def += self.get_buff_value(buff_info)
        temp_buffs = self._buffs.get(13, [])

        for buff_info in temp_buffs:
            magic_def -= self.get_buff_value(buff_info)
        return magic_def

    def get_buffed_hit(self, hit):
        """
        get buffed hit
        """
        temp_buffs = self._buffs.get(14, [])

        for buff_info in temp_buffs:
            hit += self.get_buff_value(buff_info)
        temp_buffs = self._buffs.get(15, [])

        for buff_info in temp_buffs:
            hit -= self.get_buff_value(buff_info)
        return hit

    def get_buffed_cri(self, cri):
        """
        get buffed cri
        """
        temp_buffs = self._buffs.get(18, [])

        for buff_info in temp_buffs:
            cri += self.get_buff_value(buff_info)
        temp_buffs = self._buffs.get(19, [])

        for buff_info in temp_buffs:
            cri -= self.get_buff_value(buff_info)

        #logger.debug_cal(str(cri)+"*"*60+("%s" % self._buffs))
        return cri

    def get_buffed_cri_coeff(self, cri_coeff):
        """
        cri_coeff 只有增加
        """
        temp_buffs = self._buffs.get(20, [])

        for buff_info in temp_buffs:
            cri_coeff += self.get_buff_value(buff_info)

        return cri_coeff

    def get_buffed_cri_ded_coeff(self, cri_ded_coeff):
        """
        cri_ded_coeff 只有增加
        """
        temp_buffs = self._buffs.get(21, [])

        for buff_info in temp_buffs:
            cri_ded_coeff += self.get_buff_value(buff_info)

        return cri_ded_coeff

    def get_buffed_block(self, block):
        """
        get buffed block
        """
        temp_buffs = self._buffs.get(22, [])

        for buff_info in temp_buffs:
            block += self.get_buff_value(buff_info)
        temp_buffs = self._buffs.get(23, [])

        for buff_info in temp_buffs:
            block -= self.get_buff_value(buff_info)
        return block

    def get_buffed_ductility(self, ductility):
        """
        get buffed ductility
        """
        temp_buffs = self._buffs.get(28, [])

        for buff_info in temp_buffs:
            ductility += self.get_buff_value(buff_info)
        temp_buffs = self._buffs.get(29, [])

        for buff_info in temp_buffs:
            ductility -= self.get_buff_value(buff_info)
        return ductility

    def can_attack(self):
        """
        can atk or not.
        """
        temp = True
        temp_buffs = self._buffs.get(24, [])

        for buff_info in temp_buffs:
            return False
        temp_buffs = self._buffs.get(25, [])

        for buff_info in temp_buffs:
            return False
        return temp

    def get_buff_value(self, buff_info):
        return buff_info.skill_buff_info.valueEffect + buff_info.skill_buff_info.levelEffectValue * self._owner.level

    def __repr__(self):
        temp = []
        for k, v in self._buffs.items():
            temp.extend(v)
        return str(temp)


class Buff(object):
    """docstring for Buff"""
    def __init__(self, attacker, skill_buff_info, before_or_not):
        """
        before_or_not: 在主技能释放前，添加的buff为True，在此回合有效
        """
        super(Buff, self).__init__()
        self._skill_buff_info = skill_buff_info
        self._attacker = attacker
        if not before_or_not:
            self._continue_num = skill_buff_info.get("continue") + 1
        else:
            self._continue_num = skill_buff_info.get("continue")


    @property
    def continue_num(self):
        return self._continue_num

    @continue_num.setter
    def continue_num(self, value):
        self._continue_num = value

    @property
    def skill_buff_info(self):
        return self._skill_buff_info

    def __repr__(self):
        return ("Buff_ID(%d), 持续回合(%d)" % (self._skill_buff_info.id, self._continue_num))
