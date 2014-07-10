# -*- coding:utf-8 -*-
"""
created by server on 14-6-27下午6:49.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from gtwisted.utils import log


class CharacterFinanceComponent(Component):
    """金币"""

    def __init__(self, owner, coin=0, gold=0, hero_soul=0):
        super(CharacterFinanceComponent, self).__init__(owner)
        self._coin = coin  # 角色的金币
        self._gold = gold  # 角色的充值币
        self._hero_soul = 0  # 角色的武魂

    @property
    def coin(self):
        return self._coin

    @coin.setter
    def coin(self, coin):
        self._coin = coin

    @property
    def hero_soul(self):
        return self._coin

    @hero_soul.setter
    def hero_soul(self, value):
        self._hero_soul = value

    @property
    def gold(self):
        return self._gold

    @gold.setter
    def gold(self, gold):
        self._gold = gold

    def modify_single_attr(self, attr_name='', num=0, add=True):
        """修改单个属性的值
        @param attr_name:  属性名称
        @param num:  修改的数量
        @param add: 添加或者减少
        @return:
        """
        print 'finance modify_single_attr:', attr_name, num, add
        if add:
            setattr(self, attr_name, getattr(self, attr_name, 0) + int(num))
        else:
            setattr(self, attr_name, getattr(self, attr_name, 0) - int(num))

    def modify_attrs(self, kwargs):
        """更新多个属性对应的值
        @param kwargs: {'attr_name':{'num':num, 'add':True}}
        @return:
        """
        for attr_name, info in kwargs.iteritems():
            num = info.get('num', 0)
            add = info.get('add', True)
            self.modify_single_attr(attr_name, num, add)

    def save_data(self):
        """保存数据
        """
        props = {'coin': self._coin, 'gold': self._gold, 'hero_soul': self._hero_soul}
        character_obj = tb_character_info.getObj(self.owner.base_info.id)
        character_obj.update_multi(props)

    def is_afford(self, coin):
        if self._coin < coin:
            return False
        return True

    def add_coin(self, num):
        self._coin += num

    def consume_coin(self, num):
        self._coin -= num

    def add_gold(self, num):
        self._gold += num

    def consume_gold(self, num):
        self._gold -= num

    def add_hero_soul(self, num):
        self._hero_soul += num

    def consume_hero_soul(self, num):
        self._hero_soul -= num
