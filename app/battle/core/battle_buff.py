# -*- coding:utf-8 -*-
"""
created by server on 14-9-10下午5:33.
"""

class BattleBuff(object):
    """战斗内Buff
    """
    def __init__(self, buff):
        self.id = buff.id
        self.effect_id = buff.effect_id
        self.round = buff.round  # mapping for continue since continue is keyword of python
        self.trigger_type = buff.trigger_type
        self.value_type = buff.value_type
        self.value_effect = buff.value_effect
        self.level_effect_value = buff.level_effect_value
        self.effect_role = buff.effect_role
        self.effect_pos = buff.effect_pos
        self.overlay = buff.overlay
        self.hit_times = buff.hit_times
        self.act_effect = buff.act_effect
        self.audio_id = buff.audio_id
        self.trigger_rate = buff.trigger_rate
        self.is_damage = buff.is_damage

    @property
    def buff_id(self):
        return self.id

    @property
    def effect_id(self):
        return self.effect_id

    @property
    def round(self):
        return self.round

    @property
    def trigger_type(self):
        return self.trigger_type

    @property
    def value_type(self):
        return self.value_type

    @property
    def value_effect(self):
        return self.value_effect

    @property
    def level_effect_value(self):
        return self.level_effect_value

    @property
    def effect_role(self):
        return self.effect_role

    @property
    def overlay(self):
        return self.overlay

    @property
    def hit_times(self):
        return self.hit_times

    @property
    def act_effect(self):
        return self.act_effect

    @property
    def audio_id(self):
        return self.audio_id

    @property
    def trigger_rate(self):
        return self.trigger_rate

    @property
    def is_damage(self):
        return self.is_damage

    # pass current red side and blue side character
    # return effect targets
    # red:  hero side
    # blue: monster side
    # 1   单体
    # 2   全体
    # 3   前排
    # 4   后排
    # 5   竖排
    # 6   随机
    # 7   血量百分比 最少
    # 8   血量百分比 最多
    # 9   怒气      最少
    # 10  怒气      最多
    # 11  自己
    # 12  根据普通攻击或怒气攻击的对象 (突破附加)
    def locate_target(self, red, blue):
        pass

    def parse_effect(self):
        if self.effect_id == 1:

        elif self.effect_id == 2:
        elif self.effect_id == 3:
        elif self.effect_id == 4:
        elif self.effect_id == 5:
        elif self.effect_id == 6:
        elif self.effect_id == 7:
        elif self.effect_id == 8:
        elif self.effect_id == 9:
        elif self.effect_id == 10:
        elif self.effect_id == 11:
        elif self.effect_id == 12:
        elif self.effect_id == 13:
        elif self.effect_id == 14:
        elif self.effect_id == 15:
        elif self.effect_id == 16:
        elif self.effect_id == 17:
        elif self.effect_id == 18:
        elif self.effect_id == 19:
        elif self.effect_id == 20:
        elif self.effect_id == 21:
        elif self.effect_id == 22:
        elif self.effect_id == 23:
        elif self.effect_id == 24:
        elif self.effect_id == 25:
        elif self.effect_id == 26:
        elif self.effect_id == 27:
        else:






