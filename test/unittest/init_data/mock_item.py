# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午2:25.
"""
from app.game.core.pack.item import Item


def init_item(player):
    # 突破丹
    item1 = Item(20001, 1000)
    item2 = Item(20002, 2000)
    item3 = Item(20003, 3000)
    item4 = Item(20004, 4000)
    item5 = Item(20005, 5000)

    # 经验
    item6 = Item(10003, 150)
    item11 = Item(10002, 11)
    item10 = Item(10001, 10)

    # box
    item7 = Item(40001, 1500)
    # key
    item8 = Item(40002, 1500)
    item9 = Item(60001, 100)



    player.item_package.add_item(item1)
    player.item_package.add_item(item2)
    player.item_package.add_item(item3)
    player.item_package.add_item(item4)
    player.item_package.add_item(item5)
    player.item_package.add_item(item6)
    player.item_package.add_item(item9)
    player.item_package.add_item(item7)
    player.item_package.add_item(item8)
    player.item_package.add_item(item9)
    player.item_package.add_item(item10)
    player.item_package.add_item(item11)

