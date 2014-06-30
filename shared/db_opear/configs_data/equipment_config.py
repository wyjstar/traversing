#-*- coding:utf-8 -*-
"""
created by server on 14-6-30上午9:45.
"""

class equipmentconfig(dict):
    def __getattr__(self, name):
        return self.get(name, None)

    def parser(config_value):
        return config_value