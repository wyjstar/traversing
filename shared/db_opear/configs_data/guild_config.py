# -*- coding:utf-8 -*-
"""
created by server on 14-8-20上午11:09.
"""


from common_item import CommonItem
from shared.db_opear.configs_data.data_helper import parse
from shared.db_opear.configs_data.data_helper import convert_keystr2num


class GuildConfig(object):
    """武将配置类"""
    def __init__(self):
        self._guild = {}  # {type:{level:info}, type2:{}}

    def parser(self, config_value):
        """解析config到GuildConfig"""
        for row in config_value:

            convert_keystr2num(row.get("cohesion"))
            row["support"] = parse(row.get("support"))
            row["collectSupportGift"] = parse(row.get("collectSupportGift"))
            if self._guild.get(row.get('type')):
                self._guild[row.get('type')][row.get('level')] = CommonItem(row)
            else:
                self._guild[row.get('type')] = {row.get('level'): CommonItem(row)}
        return self._guild
