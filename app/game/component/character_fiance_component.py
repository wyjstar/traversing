# -*- coding:utf-8 -*-
"""
created by server on 14-6-27下午6:49.
"""
from app.game.component.Component import Component
from gtwisted.utils import log


class CharacterFinanceComponent(Component):
    """金币"""

    def __init__(self, owner):
        super(CharacterFinanceComponent, self).__init__(owner)
        self._coin = 0
        self._hero_soul = 0
        self._mmode = None

    def init_data(self, mmode):

        if not self._mmode:
            log.msg("初始化金币出错！")
        self._mmode = mmode
        data = self._mmode.get('data')
        self._coin = data.get('coin')
        self._hero_soul = data.get('hero_soul')

    @property
    def coin(self):
        return self._coin

    @coin.setter
    def coin(self, value):
        self._coin = value
        self.update_coin()

    @property
    def hero_soul(self):
        return self._coin

    @hero_soul.setter
    def hero_soul(self, value):
        self._hero_soul = value
        self.update_hero_soul()

    def add_coin(self, coin):
        self._coin += coin
        self.update_coin()

    def consume_coin(self, coin):
        self._coin -= coin
        self.update_coin()

    def add_hero_soul(self, hero_soul):
        self._hero_soul += hero_soul
        self.update_hero_soul()

    def consume_hero_soul(self, hero_soul):
        self._hero_soul -= hero_soul
        self.update_hero_soul()

    def update_coin(self):
        self._mmode.update('coin', self._coin)

    def update_hero_soul(self):
        self._mmode.update('hero_soul', self._hero_soul)

    def is_afford(self, coin):
        if self._coin < coin:
            return False
        return True
