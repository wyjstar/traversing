# -*- coding:utf-8 -*-
"""
created by server on 14-6-26下午3:39.
"""


from common_item import CommonItem
from shared.db_opear.configs_data.data_helper import parse
from shared.db_opear.configs_data.data_helper import convert_keystr2num


class HeroConfig(object):
    """武将配置类"""
    def __init__(self):
        self.heros = {}

    def parser(self, config_value):
        """解析config到HeroConfig"""
        for row in config_value:
            convert_keystr2num(row.get('awake'))
            row["sacrificeGain"] = parse(row.get("sacrificeGain"))
            row["sellGain"] = parse(row.get("sellGain"))
            if row['quality'] == 2:
                row['color'] = 1
            elif row['quality'] == 3 or row['quality'] == 4:
                row['color'] = 2
            elif row['quality'] == 5 or row['quality'] == 6:
                row['color'] = 3
            self.heros[row.get('id')] = CommonItem(row)
        return self.heros
