# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午2:25.
"""

from test.unittest.init_data.mock_player import player
from app.game.core.pack.item import Item
from app.game.redis_mode import tb_character_item_package

item1 = Item(1000101, 1)
item2 = Item(1000102, 2)
item3 = Item(1000103, 3)
item4 = Item(1000104, 4)

# 突破丹
item5 = Item(1000111, 2)

data = {'id': 1, 'items': ''}
tb_character_item_package.new(data)

player.item_package.add_item(item1)
player.item_package.add_item(item2)
player.item_package.add_item(item3)
player.item_package.add_item(item4)
player.item_package.add_item(item5)