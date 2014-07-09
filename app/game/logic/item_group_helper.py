# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午5:11.
"""
COIN = 1
GOLD = 2
HERO_SOUL = 3
HERO_CHIP = 4
ITEM = 5
BIG_BAG = 6
from app.game.core.hero_chip import HeroChip
from app.game.core.pack.item import Item


def is_afford(player, item_group):
    """消耗是否足够。"""
    for type_id, group_item in item_group.items():
        num = group_item.num
        obj_id = group_item.obj_id
        if type_id == COIN and player.finance.coin < num:
            return {'result': False}
        elif type_id == GOLD and player.finance.gold < num:
            return {'result': False}
        elif type_id == HERO_SOUL and player.finance.hero_soul < num:
            return {'result': False}
        elif type_id == HERO_CHIP:
            hero_chip = player.hero_chip_component.get_chip(obj_id)
            if not hero_chip or hero_chip.num < num:
                return {'result': False}
        elif type_id == ITEM:
            item = player.item_package.get_item(obj_id)
            if not item or item.num < num:
                return {'result': False}

    return {'result': True}


def consume(player, item_group):
    """消耗"""
    for type_id, group_item in item_group.items():
        num = group_item.num
        obj_id = group_item.obj_id
        if type_id == COIN:
            player.finance.coin -= num
            player.finance.save_data()

        elif type_id == GOLD:
            player.finance.gold -= num
            player.finance.save_data()

        elif type_id == HERO_SOUL:
            player.finance.hero_soul -= num
            player.finance.save_data()

        elif type_id == HERO_CHIP:
            hero_chip = player.hero_chip_component.get_chip(obj_id)
            hero_chip.num -= num
            player.hero_chip_component.save_data()

        elif type_id == ITEM:
            item = player.item_package.get_item(obj_id)
            item.num -= num
            player.item_package.save_data()


def get(player, item_group):
    """获取"""
    for type_id, group_item in item_group.items():
        num = group_item.num
        obj_id = group_item.obj_id
        if type_id == COIN:
            player.finance.coin += num
            player.finance.save_data()

        elif type_id == GOLD:
            player.finance.gold += num
            player.finance.save_data()

        elif type_id == HERO_SOUL:
            player.finance.hero_soul += num
            player.finance.save_data()

        elif type_id == HERO_CHIP:
            hero_chip = player.hero_chip_component.get_chip(obj_id)
            hero_chip = HeroChip(obj_id, num)
            player.hero_chip_component.add_chip(hero_chip)
            player.hero_chip_component.save_data()

        elif type_id == ITEM:
            item = player.item_package.get_chip(obj_id)
            item = Item(obj_id, num)
            player.item_package.add_item(item)
            player.item_package.save_data()

        elif type_id == BIG_BAG:


