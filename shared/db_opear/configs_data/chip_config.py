# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午1:42.
"""
from common_item import CommonItem
from shared.db_opear.configs_data.data_helper import parse


class ChipConfig(object):

    def __init__(self):
        self._chips = {}
        self._mapping = {}
        self._map = {}

    def parser(self, config_value):
        """解析config到HeroConfig"""
        for row in config_value:
            row["sacrificeGain"] = parse(row.get("sacrificeGain"))
            obj = CommonItem(row)
            self._chips[obj.id] = obj
            if self._map.get(obj.combineResult):
                self._map.get(obj.combineResult).append(obj.id)
            else:
                self._map[obj.combineResult] = [obj.id]
            self._mapping[obj.combineResult] = obj

        return {'chips': self._chips, 'mapping': self._mapping, 'map': self._map}
