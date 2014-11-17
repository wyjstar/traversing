# -*- coding:utf-8 -*-
"""
created by server on 14-7-22下午3:27.
"""
from app.game.core.fight.buff import Buff
from shared.db_opear.configs_data import game_configs


class Skill(object):
    """技能
    """
    def __init__(self, skill_no):
        self._skill_no = skill_no
        self._buffs = []

    def __get_group(self):
        skill_config = game_configs.skill_config.get(self._skill_no)
        return skill_config.group

    def __get_buff_config(self, buff_no):
        buff_config = game_configs.skill_buff_config.get(buff_no)
        return buff_config

    def init_attr(self):
        group = self.__get_group()
        buffs = []
        for buff_no in group:
            buff_config = self.__get_buff_config(buff_no)
            effect_id = buff_config.effectId  # 效果ID
            trigger_type = buff_config.triggerType  # 触发类别
            value_type = buff_config.valueType  # 数值类型
            value_effect = buff_config.valueEffect  # 基础数值效果

            if trigger_type != 1:  # 战斗前显示
                continue
            buff = Buff(buff_no, effect_id, trigger_type, value_type, value_effect)
            buffs.append(buff)
        self._buffs = buffs

    @property
    def buffs(self):
        return self._buffs




