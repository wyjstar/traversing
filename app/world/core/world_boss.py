#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""

class WorldBoss(object):
    """docstring for WorldBoss"""
    def __init__(self, hp):
        super(WorldBoss, self).__init__()
        self._hp = hp

    @property
    def hp(self):
        return self._hp

    @hp.setter
    def hp(self, value):
        self._hp = value

    def save_data(self):
        pass
