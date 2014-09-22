# -*- coding:utf-8 -*-
"""
created by server on 14-6-27下午6:49.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from gtwisted.utils import log


class CharacterFinanceComponent(Component):
    """货币"""

    def __init__(self, owner, coin=0, gold=0, hero_soul=0):
        super(CharacterFinanceComponent, self).__init__(owner)
        self._coin = coin  # 角色的金币
        self._gold = gold  # 角色的充值币
        self._hero_soul = 0  # 角色的武魂

        self._junior_stone = 0  # 低级熔炼石头
        self._middle_stone = 0  # 中级熔炼石头
        self._high_stone = 0  # 高级熔炼石头

    @property
    def junior_stone(self):
        return self._junior_stone

    @junior_stone.setter
    def junior_stone(self, junior_stone):
        self._junior_stone = junior_stone

    @property
    def middle_stone(self):
        return self._middle_stone

    @middle_stone.setter
    def middle_stone(self, middle_stone):
        self._middle_stone = middle_stone

    @property
    def high_stone(self):
        return self._high_stone

    @high_stone.setter
    def high_stone(self, high_stone):
        self._high_stone = high_stone

    @property
    def coin(self):
        return self._coin

    @coin.setter
    def coin(self, coin):
        self._coin = coin

    @property
    def hero_soul(self):
        return self._hero_soul

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
        @param attr_name:  属性名称 str
        @param num:  修改的数量 int
        @param add: 添加或者减少
        @return:
        """
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
        props = {'coin': self._coin,
                 'gold': self._gold,
                 'hero_soul': self._hero_soul,
                 'junior_stone': self._junior_stone,
                 'middle_stone': self._middle_stone,
                 'high_stone': self._high_stone}
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
