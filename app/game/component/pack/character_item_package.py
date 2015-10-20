# -*- coding:utf-8 -*-
"""
created by server on 14-7-2下午4:51.
"""
from app.game.component.Component import Component
from app.game.core.pack.item import Item
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger
#from shared.db_opear.configs_data import game_configs


class CharacterItemPackageComponent(Component):
    """角色的道具包裹组件
    """
    def __init__(self, owner):
        super(CharacterItemPackageComponent, self).__init__(owner)
        self._items = {}  # 背包道具 {'item_no': item obj}

    def init_data(self, character_info):
        items_data = character_info.get('items')
        for item_no, item_num in items_data.items():
            item = Item(item_no, item_num)
            self._items[item_no] = item

    def save_data(self):
        props = {}
        for item_no, item in self._items.iteritems():
            props[item_no] = item.num

        char_obj = tb_character_info.getObj(self.owner.base_info.id)
        logger.debug(str(props))
        char_obj.hset('items', props)

    def new_data(self):
        return {'items': {}}

    @property
    def items(self):
        return self._items

    @property
    def items_count(self):
        return len(self._items)

    def add_item(self, item):
        """添加道具
        """
        if item.num <= 0: return
        if item.item_no in self._items:  # 已经存在的item_no
            item_obj = self._items[item.item_no]
            item_obj.modify_num(item.num, add=True)
        else:
            item_obj = item
            self._items[item.item_no] = item_obj

        #item_max = game_configs.base_config.get("max_item_superposition")
        #if item_obj.num > item_max:
            #item_obj.num = item_max

    def get_item(self, item_no):
        return self._items.get(item_no)

    def get_all(self):
        return self._items.values()

    def consume_item(self, item_no, item_num):
        item = self._items.get(item_no)
        if not item: return
        item.num -= item_num
        if item.num == 0:
            del self._items[item_no]

        self.save_data()
