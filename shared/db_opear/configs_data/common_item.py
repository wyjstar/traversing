# -*- coding:utf-8 -*-
"""
created by server on 14-7-3下午8:29.
"""


class CommonItem(dict):
    """通用类"""
    def __getattribute__(self, item):
        return self.get(item)