# -*- coding:utf-8 -*-
"""
created by server on 14-7-22下午2:46.
"""
# from shared.db_opear.configs_data import game_configs


class Buff(object):
    """buff
    """

    def __init__(self, buff_no, effect_id, trigger_type, value_type, value_effect):
        self._buff_no = buff_no

        self._effect_id = effect_id
        self._trigger_type = trigger_type
        self._value_type = value_type
        self._value_effect = value_effect

    @property
    def buff_no(self):
        return self._buff_no

    @property
    def effect_id(self):
        return self._effect_id

    @property
    def trigger_type(self):
        return self._trigger_type

    @property
    def value_type(self):
        return self._value_type

    @property
    def value_effect(self):
        return self._value_effect

    @value_effect.setter
    def value_effect(self, value):
        self._value_effect = value

    def __cmp__(self, other):
        if self is not None and other is not None:
            return cmp((self.effect_id, self.trigger_type, self.value_type, self.value_effect),
                       (other.effect_id, other.trigger_type, other.value_type, other.value_effect))

        if self is None and other is None:
            return 0
        elif other is None:
            return -1
        else:
            return 1

    def __add__(self, other):
        if self is not None and other is not None:
            self.value_effect += other.value_effect