# -*- coding:utf-8 -*-
"""
created by server on 14-7-4下午4:42.
"""

from common_item import CommonItem
from app.game.logic.item_group_helper import parse


class HeroBreakupConfig(object):
    """武将突破配置类"""
    def __init__(self):
        self.hero_breakups = {}

    def parser(self, config_value):
        """解析config到HeroConfig"""
        heros = {}
        for row in config_value:
            self.hero_breakups[row.get('id')] = HeroBreakupConfig.HeroBreakupItem(row)
        return self.hero_breakups

    class HeroBreakupItem(object):

        def __init__(self, row):
            self.info = row

        def get_consume(self, break_level):
            """
            获取突破消耗
            :param break_level: 1-7
            :return:
            """
            consume_info = self.info.get('consume' + str(break_level+1))
            return parse(consume_info)




