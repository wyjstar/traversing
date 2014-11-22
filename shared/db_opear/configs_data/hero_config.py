# -*- coding:utf-8 -*-
"""
created by server on 14-6-26下午3:39.
"""


from common_item import CommonItem
from shared.db_opear.configs_data.data_helper import parse

class HeroConfig(object):
    """武将配置类"""
    def __init__(self):
        self.heros = {}

    def parser(self, config_value):
        """解析config到HeroConfig"""
        def convert_keystr2num(d):
            for k in d.keys():
                nk = None
                v = d[k]
                try:
                    nk = eval(k)
                except:
                    pass
                if nk is not None:
                    del d[k]
                    d[nk] = v
                if isinstance(v, dict):
                    convert_keystr2num(v)

        for row in config_value:
            convert_keystr2num(row.get('awake'))
            row["sacrificeGain"] = parse(row.get("sacrificeGain"))
            row["sellGain"] = parse(row.get("sellGain"))
            self.heros[row.get('id')] = CommonItem(row)
        return self.heros
