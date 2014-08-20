# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午2:25.
"""
from app.game.core.PlayersManager import PlayersManager
from app.game.core.pack.item import Item
from app.game.redis_mode import tb_character_item_package


def init_item(player):
    # 突破丹
    item1 = Item(1900020001, 1)
    item2 = Item(1900020002, 2)
    item3 = Item(1900020003, 3)
    item4 = Item(1900020004, 4)
    item5 = Item(1900020005, 5)

    # box
    item6 = Item(1900030003, 15)
    # key
    item7 = Item(1900030013, 15)

    player.item_package.add_item(item1)
    player.item_package.add_item(item2)
    player.item_package.add_item(item3)
    player.item_package.add_item(item4)
    player.item_package.add_item(item5)
    player.item_package.add_item(item6)
    player.item_package.add_item(item7)