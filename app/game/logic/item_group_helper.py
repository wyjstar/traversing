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
HERO = 7
EQUIPMENT = 8

from app.game.core.hero_chip import HeroChip
from app.game.core.pack.item import Item
from shared.db_opear.configs_data.game_configs import chip_config
from app.game.core.drop_bag import BigBag
from app.game.core.hero import Hero


def is_afford(player, item_group):
    """消耗是否足够。"""
    for group_item in item_group:
        type_id = group_item.type_id
        num = group_item.num
        obj_id = group_item.obj_id
        print "hero_soul", player.finance.hero_soul
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
    for group_item in item_group:
        type_id = group_item.type_id
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


def gain(player, item_group):
    """获取"""
    for group_item in item_group:
        type_id = group_item.type_id
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
            hero_chip = HeroChip(obj_id, num)
            player.hero_chip_component.add_chip(hero_chip)
            player.hero_chip_component.save_data()

        elif type_id == ITEM:
            item = Item(obj_id, num)
            player.item_package.add_item(item)
            player.item_package.save_data()

        elif type_id == HERO:
            if player.hero_component.contain_hero(obj_id):
                # 已经存在该武将，自动转换为武将碎片
                # 获取hero对应的hero_chip_no, hero_chip_num
                print chip_config
                hero_chip_config_item = chip_config.get("mapping").get(obj_id)
                hero_chip_no = hero_chip_config_item.id
                hero_chip_num = hero_chip_config_item.need_num

                hero_chip = HeroChip(hero_chip_no, hero_chip_num)
                player.hero_chip_component.add_chip(hero_chip)
                player.hero_chip_component.save_data()

            else:
                hero = Hero()
                hero.hero_no = obj_id
                player.hero_component.add_hero(hero)

        elif type_id == BIG_BAG:
            big_bag = BigBag(obj_id)
            gain(player, big_bag.get_drop_items())

        elif type_id == EQUIPMENT:
            pass




