# -*- coding:utf-8 -*-
"""
created by server on 14-6-17下午5:29.
"""


class BaseConfig(dict):
    def __getattr__(self, name):
        return self.get(name, None)