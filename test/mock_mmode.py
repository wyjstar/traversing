# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午11:39.
"""

from shared.db_entrust.redis_mode import MMode


class MockMMode(MMode):

    def __init__(self):
        try:
            super(MockMMode, self).__init__('id', 'id')
        except Exception as err:
            pass
    """Mock"""
    def update(self, key, values):
        pass