# -*- coding:utf-8 -*-
"""
created by server on 14-6-26下午3:39.
"""


from common_item import CommonItem


class PushConfig(object):
    """
    """
    def __init__(self):
        self.pushs = {}

    def parser(self, config_value):
        """
        """
        for row in config_value:
            self.pushs[row.get('id')] = CommonItem(row)
        return self.pushs
