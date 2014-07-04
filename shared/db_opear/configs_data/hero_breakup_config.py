# -*- coding:utf-8 -*-
"""
created by server on 14-7-4下午4:42.
"""

from common_item import CommonItem


class HeroBreakupConfig(object):
    """武将突破配置类"""
    def __init__(self):
        self.hero_breakups = {}

    def parser(self, config_value):
        """解析config到HeroConfig"""
        heros = {}
        for row in config_value:
            self.hero_breakups[row.get('id')] = HeroBreakupItem(row)
        return self.hero_breakups

    class HeroBreakupItem(object):

        def __init__(self, row):
            self.info = row

        def get_consume(self, break_level, consume_name):
            """
            获取突破消耗
            :param break_level: 1-7
            :param consume_name: coin, break_pill, hero_chip
            :return:
            """
            consume_info = self.info.get('consume' + str(break_level))
            if consume_name == 'coin':
                lst = consume_info.get(1)
                return lst[0]

            elif consume_info == 'break_pill':
                lst = consume_info.get(2)
                return lst[0], lst[2]

            elif consume_info == 'hero_chip':
                lst = consume_info.get(3)
                return lst[0], lst[2]




