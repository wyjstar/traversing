# -*- coding:utf-8 -*-
"""
created by server on 14-7-5下午3:25.
"""
import cPickle
from shared.utils.const import const


class LineUp(object):
    """阵容
    """
    def __init__(self, no=1):
        self._no = no  # 阵容编号
        self._heros = {}.fromkeys(const.LINE_UP_INDEX, 0)  # {座位编号：英雄ID （0:空位）}
        self._unique = 0  # 必杀技能：技能ID

    def dumps(self):
        return dict(no=self._no, heros=cPickle.dumps(self._heros), unique=self._unique)

    def loads(self, data):
        self._no = data.get('no')
        self._heros = cPickle.loads(data.get('heros'))
        self._unique = data.get('unique')






















