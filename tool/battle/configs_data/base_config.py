# -*- coding:utf-8 -*-
"""
created by server on 14-6-17下午5:29.
"""


class BaseConfig(object):

    def parser(self, config_value):
        config_value['hero_position_open_level'] = {1:1,2:2,3:5,4:10,5:16,6:20}
        config_value['friend_position_open_level'] = {1:20,2:30,3:40,4:50,5:60,6:70}
        return config_value