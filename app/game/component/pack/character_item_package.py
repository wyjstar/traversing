# -*- coding:utf-8 -*-
"""
created by server on 14-7-2下午4:51.
"""
from app.game.component.Component import Component
from app.game.core.pack.item import Item
from app.game.redis_mode import tb_character_item_package


class CharacterItemPackageComponent(Component):
    """角色的道具包裹组件
    """
    def __init__(self, owner):
        super(CharacterItemPackageComponent, self).__init__(owner)
        self._items = {}  # 背包道具 {'item_no': item obj}

    def init_data(self):
        """初始化道具信息
        """
        item_package_data = tb_character_item_package.getObjData(self.owner.base_info.id)
        if item_package_data:
            items_data = item_package_data.get('items', {})
            for item_no, item_num in items_data.items():
                item = Item(item_no, item_num)
                self._items[item_no] = item
        else:
            tb_character_item_package.new({'id': self.owner.base_info.id, 'items': {}})

    @property
    def items(self):
        return self._items

    def add_item(self, item):
        """添加道具
        """
        if item.item_no in self._items:  # 已经存在的item_no
            item_obj = self._items[item.item_no]
            item_obj.modify_num(item.num, add=True)
        else:
            item_obj = item
            self._items[item.item_no] = item_obj

    def get_item(self, item_no):
        return self._items.get(item_no)

    def consume_item(self, item_no, item_num):
        self._items.get(item_no).num -= item_num

    def save_data(self):
        props = {}
        for item_no, item in self._items.iteritems():
            props[item_no] = item.num

        items_data = tb_character_item_package.getObj(self.owner.base_info.id)
        items_data.update('items', props)










