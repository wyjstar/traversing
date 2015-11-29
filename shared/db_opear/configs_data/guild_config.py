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
        self._guild = {}  # {type:{level:info}, guild1:info}

    def parser(self, config_value):
        """解析config到GuildConfig"""
        for row in config_value:

            convert_keystr2num(row.get("worShip"))
            convert_keystr2num(row.get("guild_worship"))
            convert_keystr2num(row.get("reward"))
            convert_keystr2num(row.get("cohesion"))
            convert_keystr2num(row.get("animalOpen"))
            row["support"] = parse(row.get("support"))
            row["collectSupportGift"] = parse(row.get("collectSupportGift"))
            item = CommonItem(row)
            if self._guild.get(row.get('type')):
                self._guild[row.get('type')][row.get('level')] = item
            else:
                self._guild[row.get('type')] = {row.get('level'): item}
            self._guild[item.id] = item
        return self._guild
