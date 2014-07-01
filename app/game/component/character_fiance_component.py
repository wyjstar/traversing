# -*- coding:utf-8 -*-
"""
created by server on 14-6-27下午6:49.
"""
from app.game.component.Component import Component


class CharacterFinanceComponent(Component):
    """金币"""
    def __init__(self, coin):
        self._coin = coin

    @property
    def coin(self):
        return self._coin

    @coin.setter
    def coin(self, value):
        self._coin = value

    def add_coin(self, coin):
        self._coin += coin

    def consume_coin(self, coin):

        self._coin -= coin

    def is_afford(self, coin):
        if self._coin < coin:
            return False
        return True
