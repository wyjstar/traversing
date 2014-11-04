# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午1:42.
"""
from common_item import CommonItem


class ChipConfig(object):

    def __init__(self):
        self._chips = {}
        self._mapping = {}

    def parser(self, config_value):
        """解析config到HeroConfig"""
        for row in config_value:
            obj = CommonItem(row)
            self._chips[obj.id] = obj
            self._mapping[obj.combineResult] = obj

        return {'chips': self._chips, 'mapping': self._mapping}