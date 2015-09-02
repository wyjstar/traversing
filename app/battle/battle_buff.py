# !/usr/bin/env python
# -*- coding: utf-8 -*-
from gfirefly.server.logobj import logger_cal, logger
from execute_skill_buff import execute_demage, execute_pure_demage, execute_mp, execute_treat, check_block, actual_value, check_trigger


class BuffManager(object):
    """docstring for BattleBuffManager"""

    def __init__(self, owner):
        super(BuffManager, self).__init__()
        self._owner = owner
        self._buffs = {}

    def add(self, buff):
        """
        add a buff.
        """
        if not check_trigger(buff.skill_buff_info):
            return
        logger_cal.debug("添加buff: %s" % buff.skill_buff_info.id)
        effect_id = buff.skill_buff_info.effectId
        if effect_id not in self._buffs:
            self._buffs[effect_id] = []

        if buff.skill_buff_info.overlay:
            self._add_buff(buff, effect_id)
        elif not buff.skill_buff_info.overlay:
            if self._buffs[effect_id]:
                temp = self._buffs[effect_id][0]
                if temp.skill_buff_info.replace <= buff.skill_buff_info.replace:
                    self._add_buff(buff, effect_id, True)
            else:
                self._add_buff(buff, effect_id)

    def _add_buff(self, buff, effect_id, replace=False):
        buff.perform_buff(self._owner) # perform buff
        if buff.continue_num > 0:
            if replace:
                self._buffs[effect_id] = [buff]
            else:
                self._buffs[effect_id].append(buff)

    def perform_buff(self):
        """
        在回合开始时，使buff生效
        """
        for buffs in self._buffs.values():
            for buff in buffs:
                buff.perform_buff(self._owner)


    def remove(self):
        """docstring for remove"""
        for k, value in self._buffs.items():
            temp = []
            for buff in value:
                buff.continue_num -= 1
                if buff.continue_num > 0:
                    temp.append(buff)
                else:
                    logger_cal.debug("去除buff %s", buff.skill_buff_info.id)
            self._buffs[k] = temp

    def get_buffed_dodge(self, dodge):
        """
        get buffed dodge
        """
        temp_buffs = self._buffs.get(16, [])

        for buff_info in temp_buffs:
            dodge += self.get_buff_value(dodge, buff_info.skill_buff_info)
        temp_buffs = self._buffs.get(17, [])

        for buff_info in temp_buffs:
            dodge -= self.get_buff_value(dodge, buff_info.skill_buff_info)
        return dodge

    def get_buffed_atk(self, atk):
        """
        get buffed atk
        """
        temp_buffs = self._buffs.get(6, [])

        for buff_info in temp_buffs:
            atk += self.get_buff_value(atk, buff_info.skill_buff_info)
        temp_buffs = self._buffs.get(7, [])

        for buff_info in temp_buffs:
            atk -= self.get_buff_value(atk, buff_info.skill_buff_info)
        return atk

    def get_buffed_physical_def(self, physical_def):
        """
        get buffed physical_def
        """
        temp_buffs = self._buffs.get(10, [])

        for buff_info in temp_buffs:
            physical_def += self.get_buff_value(physical_def, buff_info.skill_buff_info)
        temp_buffs = self._buffs.get(11, [])

        for buff_info in temp_buffs:
            physical_def -= self.get_buff_value(physical_def, buff_info.skill_buff_info)
        return physical_def

    def get_buffed_magic_def(self, magic_def):
        """
        get buffed  magic_def
        """
        temp_buffs = self._buffs.get(12, [])

        for buff_info in temp_buffs:
            magic_def += self.get_buff_value(magic_def, buff_info.skill_buff_info)
        temp_buffs = self._buffs.get(13, [])

        for buff_info in temp_buffs:
            magic_def -= self.get_buff_value(magic_def, buff_info.skill_buff_info)
        return magic_def

    def get_buffed_hit(self, hit):
        """
        get buffed hit
        """
        temp_buffs = self._buffs.get(14, [])

        for buff_info in temp_buffs:
            hit += self.get_buff_value(hit, buff_info.skill_buff_info)
        temp_buffs = self._buffs.get(15, [])

        for buff_info in temp_buffs:
            hit -= self.get_buff_value(hit, buff_info.skill_buff_info)
        return hit

    def get_buffed_cri(self, cri):
        """
        get buffed cri
        """
        temp_buffs = self._buffs.get(18, [])

        for buff_info in temp_buffs:
            cri += self.get_buff_value(cri, buff_info.skill_buff_info)
        temp_buffs = self._buffs.get(19, [])

        for buff_info in temp_buffs:
            cri -= self.get_buff_value(cri, buff_info.skill_buff_info)

        #logger_cal.debug(str(cri)+"*"*60+("%s" % self._buffs))
        return cri

    def get_buffed_cri_coeff(self, cri_coeff):
        """
        cri_coeff 只有增加
        """
        temp_buffs = self._buffs.get(20, [])

        for buff_info in temp_buffs:
            cri_coeff += self.get_buff_value(cri_coeff, buff_info.skill_buff_info)

        return cri_coeff

    def get_buffed_cri_ded_coeff(self, cri_ded_coeff):
        """
        cri_ded_coeff 只有增加
        """
        temp_buffs = self._buffs.get(21, [])

        for buff_info in temp_buffs:
            cri_ded_coeff += self.get_buff_value(cri_ded_coeff, buff_info.skill_buff_info)

        return cri_ded_coeff

    def get_buffed_block(self, block):
        """
        get buffed block
        """
        temp_buffs = self._buffs.get(22, [])

        for buff_info in temp_buffs:
            block += self.get_buff_value(block, buff_info.skill_buff_info)
        temp_buffs = self._buffs.get(23, [])

        for buff_info in temp_buffs:
            block -= self.get_buff_value(block, buff_info.skill_buff_info)
        return block

    def get_buffed_ductility(self, ductility):
        """
        get buffed ductility
        """
        temp_buffs = self._buffs.get(28, [])

        for buff_info in temp_buffs:
            ductility += self.get_buff_value(ductility, buff_info.skill_buff_info)
        temp_buffs = self._buffs.get(29, [])

        for buff_info in temp_buffs:
            ductility -= self.get_buff_value(ductility, buff_info.skill_buff_info)
        return ductility

    def is_dizzy(self):
        """
        can atk or not.
        """
        temp = True
        temp_buffs = self._buffs.get(24, [])

        for buff_info in temp_buffs:
            return False
        return temp

    def is_slient(self):
        """docstring for is_slient"""
        temp_buffs = self._buffs.get(25, [])

        for buff_info in temp_buffs:
            return True
        return False


    def get_buff_value(self, value, buff_info):
        all_vars=dict(skill_buff=buff_info,
                      heroLevel=self._owner.level,
                      attrHero=value)
        v1 = actual_value("skillbuffEffct_1", all_vars)
        v2 = actual_value("skillbuffEffct_2", all_vars)
        if v1:return v1
        if v2:return v2
        return 0


    def __repr__(self):
        temp = []
        for k, v in self._buffs.items():
            temp.extend(v)
        return str(temp)


class Buff(object):
    """docstring for Buff"""

    def __init__(self, target_side, attacker, skill_buff_info, is_block=False):
        """
        target_side: 目标方所有units
        attacker: 攻击者
        skill_buff_info: 数值数据
        is_block: 是否出现格挡
        """
        super(Buff, self).__init__()
        self._target_side = target_side
        self._skill_buff_info = skill_buff_info
        self._attacker = attacker
        self._continue_num = skill_buff_info.get("continue")
        self._is_block = is_block

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

    def perform_buff(self, owner):
        if not self._target_side: return
        effect_id = self._skill_buff_info.effectId
        if effect_id in [1, 2, 3, 8, 9, 26]:
            logger_cal.debug("执行buff %s" % self._skill_buff_info.id)
            self._continue_num -= 1

        if effect_id in [1, 2]:
            block_or_not = False
            if self._skill_buff_info.skill_key == 1:
                block_or_not = self._is_block
            else:
                block_or_not = check_block(self._attacker, owner, self._skill_buff_info)

            execute_demage(self._attacker, owner, self._skill_buff_info, block_or_not)
        elif effect_id in [3]:
            execute_pure_demage(self._attacker, owner, self._skill_buff_info)
        elif effect_id in [8, 9]:
            execute_mp(owner, self._skill_buff_info)
        elif effect_id in [26]:
            execute_treat(self._attacker, owner, self._skill_buff_info)

        if owner.hp<=0 and owner.slot_no in self._target_side:
            logger.debug(owner.hp)
            logger.debug(self._target_side)
            logger.debug(owner.slot_no)

            del self._target_side[owner.slot_no]
            logger_cal.debug("%s死了。" % owner.unit_no)

