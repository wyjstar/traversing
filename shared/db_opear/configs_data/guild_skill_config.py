# -*- coding:utf-8 -*-
"""
created by server on 14-6-26下午3:39.
"""


from common_item import CommonItem
from shared.db_opear.configs_data.data_helper import parse
from shared.db_opear.configs_data.data_helper import convert_keystr2num


class GuildSkillConfig(object):
    """武将觉醒配置类"""
    def __init__(self):
        self.items = {}

    def parser(self, config_value):
        """解析config到HeroConfig"""
        for row in config_value:
            convert_keystr2num(row.get('Skill_condition'))
            row["Consume"] = parse(row.get("Consume"))

            if row["type"] not in self.items:
                self.items[row["type"]] = {}
            self.items[row["type"]][row["Skill_level"]] = CommonItem(row)
            self.items[row["id"]] = CommonItem(row)
        return self.items
