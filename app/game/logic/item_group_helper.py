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
from app.proto_file.hero_pb2 import HeroPB
from app.proto_file.player_pb2 import FinancePB
from app.proto_file.player_response_pb2 import GameResourcesResponse


def is_afford(player, item_group):
    """消耗是否足够。"""
    for group_item in item_group:
        type_id = group_item.item_type
        num = group_item.num
        obj_id = group_item.item_no
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
        type_id = group_item.item_type
        num = group_item.num
        obj_id = group_item.item_no
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

    result = []

    for group_item in item_group:
        type_id = group_item.item_type
        num = group_item.num
        item_no = group_item.item_no
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
            hero_chip = HeroChip(item_no, num)
            player.hero_chip_component.add_chip(hero_chip)
            player.hero_chip_component.save_data()

        elif type_id == ITEM:
            item = Item(item_no, num)
            player.item_package.add_item(item)
            player.item_package.save_data()

        elif type_id == HERO:
            if player.hero_component.contain_hero(item_no):
                # 已经存在该武将，自动转换为武将碎片
                # 获取hero对应的hero_chip_no, hero_chip_num
                print chip_config
                hero_chip_config_item = chip_config.get("mapping").get(item_no)
                hero_chip_no = hero_chip_config_item.id
                hero_chip_num = hero_chip_config_item.need_num

                hero_chip = HeroChip(hero_chip_no, hero_chip_num)
                player.hero_chip_component.add_chip(hero_chip)
                player.hero_chip_component.save_data()
                type_id = HERO_CHIP
                item_no = hero_chip_no
                num = hero_chip_num

            else:
                player.hero_component.add_hero(item_no)

        elif type_id == BIG_BAG:
            big_bag = BigBag(item_no)
            gain(player, big_bag.get_drop_items())

        elif type_id == EQUIPMENT:
            equipment = player.equipment_component.add_equipment(item_no)
            item_no = equipment.base_info.id

        result.append([type_id, num, item_no])
    return result


def get_return(player, return_data, game_resources_response):
    """
    构造返回数据
    :param player:
    :param return_data: 需要返回的信息
    :param game_resources_response: 返回数据
    """
    # finance
    finance_pb = game_resources_response.finance
    if not finance_pb:
        finance_pb = FinancePB()
        # finance_pb.coin = 0
        # finance_pb.gold = 0
        # finance_pb.hero_soul = 0
        game_resources_response.finance = finance_pb

    for lst in return_data:
        item_type = lst[0]
        item_num = lst[1]
        item_no = lst[2]

        if COIN == item_type:
            finance_pb.coin += item_num
        elif GOLD == item_type:
            finance_pb.gold += item_num
        elif HERO_SOUL == item_type:
            finance_pb.hero_soul += item_num
        elif HERO_CHIP == item_type:
            hero_chip_pb = game_resources_response.hero_chips.add()
            hero_chip_pb.hero_chip_no = item_no
            hero_chip_pb.hero_chip_num = item_num
        elif ITEM == item_type:
            item_pb = game_resources_response.items.add()
            item_pb.item_no = item_no
            item_pb.item_num = item_num
        elif HERO == item_type:
            hero = player.hero_component.get_hero(item_no)
            hero_pb = game_resources_response.heros.add()
            hero_pb.hero_no = hero.hero_no
            hero_pb.level = hero.level
            hero_pb.exp = hero.exp
            hero_pb.break_level = hero.break_level
        elif EQUIPMENT == item_type:
            equipment = player.equipment_component.get_equipment(item_no)
            equipment_pb = game_resources_response.equipments.add()
            equipment_pb.id = equipment.base_info.id
            equipment_pb.no = equipment.base_info.equipment_no
            equipment_pb.strengthen_lv = equipment.attribute.strengthen_lv
            equipment_pb.awakening_lv = equipment.attribute.awakening_lv
            equipment_pb.nobbing_effect = 0
            equipment_pb.hero_no = 0













