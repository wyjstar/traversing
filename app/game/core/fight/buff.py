# -*- coding:utf-8 -*-
"""
created by server on 14-7-22下午2:46.
"""
# from shared.db_opear.configs_data import game_configs


class Buff(object):
    """buff
    """

    def __init__(self, buff_no, effec_id, trigger_type, value_type, value_effect):
        self._buff_no = buff_no

        self._effec_id = effec_id
        self._trigger_type = trigger_type
        self._value_type = value_type
        self._value_effect = value_effect

    @property
    def buff_no(self):
        return self._buff_no

    @property
    def effec_id(self):
        return self._effec_id

    @property
    def trigger_type(self):
        return self._trigger_type

    @property
    def value_type(self):
        return self._value_type

    @property
    def value_effect(self):
        return self._value_effect

    def __cmp__(self, other):
        if self is not None and other is not None:
            return cmp((self.effec_id, self.trigger_type, self.value_type, self.value_effect),
                       (self.effec_id, self.trigger_type, self.value_type, self.value_effect))

        if self is None and other is None:
            return 0
        elif other is None:
            return -1
        else:
            return 1

    def __add__(self, other):
        self.value_effect += other.value_effect


if __name__ == '__main__':
    a = Buff(1, 2, 3, 4, 5)
    b = Buff(1, 2, 3, 4, 5)

    c = []

    c.append(a)

    if b in c:
        pass
    else:
        c.append(b)

    print c









