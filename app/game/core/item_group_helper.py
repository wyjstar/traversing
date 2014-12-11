# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午5:11.
"""

from app.game.core.hero_chip import HeroChip
from app.game.core.equipment.equipment_chip import EquipmentChip
from app.game.core.pack.item import Item
from shared.db_opear.configs_data.game_configs import chip_config, travel_item_config
from app.game.core.drop_bag import BigBag
from app.proto_file.player_pb2 import FinancePB
from shared.utils.const import const
from gfirefly.server.logobj import logger


def is_afford(player, item_group):
    """消耗是否足够。"""
    for group_item in item_group:
        type_id = group_item.item_type
        num = group_item.num
        item_no = group_item.item_no
        if type_id == const.COIN and player.finance.coin < num:
            return {'result': False, 'result_no': 101}
        elif type_id == const.GOLD and player.finance.gold < num:
            return {'result': False, 'result_no': 102}
        elif type_id == const.HERO_SOUL and player.finance.hero_soul < num:
            return {'result': False, 'result_no': 103}
        elif type_id == const.JUNIOR_STONE and player.finance.junior_stone < num:
            return {'result': False, 'result_no': 107}
        elif type_id == const.MIDDLE_STONE and player.finance.middle_stone < num:
            return {'result': False, 'result_no': 108}
        elif type_id == const.HIGH_STONE and player.finance.high_stone < num:
            return {'result': False, 'result_no': 109}
        elif type_id == const.PVP and player.finance.pvp_score < num:
            return {'result': False, 'result_no': 110}
        elif type_id == const.HERO_CHIP:
            hero_chip = player.hero_chip_component.get_chip(item_no)
            if not hero_chip or hero_chip.num < num:
                return {'result': False, 'result_no': 104}
        elif type_id == const.EQUIPMENT_CHIP:
            equipment_chip = player.equipment_chip_component.get_chip(item_no)
            if not equipment_chip or equipment_chip.chip_num < num:
                return {'result': False, 'result_no': 105}
        elif type_id == const.ITEM:
            item = player.item_package.get_item(item_no)
            if not item or item.num < num:
                return {'result': False, 'result_no': 106}

    return {'result': True}


def consume(player, item_group, shop=None, luck_config=None):
    """消耗"""
    result = []
    luckValue = None
    if luck_config:
        luckValue = luck_config.luckyValue
    for group_item in item_group:
        type_id = group_item.item_type
        num = group_item.num
        item_no = group_item.item_no
        if type_id == const.COIN:
            player.finance.coin -= num
            if shop and luckValue:
                shop['luck_num'] += num * luckValue.get(type_id)
            player.finance.save_data()

        elif type_id == const.GOLD:
            player.finance.gold -= num
            if shop and luckValue:
                shop['luck_num'] += num * luckValue.get(type_id)
            player.finance.save_data()

        elif type_id == const.HERO_SOUL:
            player.finance.hero_soul -= num
            player.finance.save_data()

        elif type_id == const.JUNIOR_STONE:
            player.finance.junior_stone -= num
            player.finance.save_data()

        elif type_id == const.MIDDLE_STONE:
            player.finance.middle_stone -= num
            player.finance.save_data()

        elif type_id == const.HIGH_STONE:
            player.finance.high_stone -= num
            player.finance.save_data()

        elif type_id == const.PVP:
            player.finance.pvp_score -= num
            player.finance.save_data()

        elif type_id == const.HERO_CHIP:
            hero_chip = player.hero_chip_component.get_chip(item_no)
            hero_chip.num -= num
            player.hero_chip_component.save_data()

        elif type_id == const.EQUIPMENT_CHIP:
            equipment_chip = player.equipment_chip_component.get_chip(item_no)
            equipment_chip.chip_num -= num
            player.equipment_chip_component.save_data()

        elif type_id == const.ITEM:
            item = player.item_package.get_item(item_no)
            item.num -= num
            player.item_package.save_data()
        result.append([type_id, num, item_no])
    return result


def gain(player, item_group, result=None):
    """获取
    @param item_group: [obj,obj]
    """
    if result is None:
        result = []

    for group_item in item_group:
        type_id = group_item.item_type
        num = group_item.num
        item_no = group_item.item_no
        if type_id == const.COIN:
            player.finance.coin += num
            player.finance.save_data()

        elif type_id == const.GOLD:
            player.finance.gold += num
            player.finance.save_data()

        elif type_id == const.HERO_SOUL:
            player.finance.hero_soul += num
            player.finance.save_data()

        elif type_id == const.JUNIOR_STONE:
            player.finance.junior_stone += num
            player.finance.save_data()
        elif type_id == const.MIDDLE_STONE:
            player.finance.middle_stone += num
            player.finance.save_data()
        elif type_id == const.HIGH_STONE:
            player.finance.high_stone += num
            player.finance.save_data()

        elif type_id == const.HERO_CHIP:
            hero_chip = HeroChip(item_no, num)
            player.hero_chip_component.add_chip(hero_chip)
            player.hero_chip_component.save_data()

        elif type_id == const.ITEM:
            item = Item(item_no, num)
            player.item_package.add_item(item)
            player.item_package.save_data()

        elif type_id == const.HERO:
            if player.hero_component.contain_hero(item_no):
                # 已经存在该武将，自动转换为武将碎片
                # 获取hero对应的hero_chip_no, hero_chip_num
                hero_chip_config_item = chip_config.get("mapping").get(item_no)
                hero_chip_no = hero_chip_config_item.id
                hero_chip_num = hero_chip_config_item.needNum

                hero_chip = HeroChip(hero_chip_no, hero_chip_num)
                player.hero_chip_component.add_chip(hero_chip)
                player.hero_chip_component.save_data()
                type_id = const.HERO_CHIP
                item_no = hero_chip_no
                num = hero_chip_num
            else:
                player.hero_component.add_hero(item_no)

        elif type_id == const.BIG_BAG:
            big_bag = BigBag(item_no)
            for i in range(num):
                gain(player, big_bag.get_drop_items(), result)
            return result

        elif type_id == const.EQUIPMENT:
            equipment = player.equipment_component.add_equipment(item_no)
            item_no = equipment.base_info.id

        elif type_id == const.EQUIPMENT_CHIP:
            chip = EquipmentChip(item_no, num)
            player.equipment_chip_component.add_chip(chip)
            player.equipment_chip_component.save_data()
        elif type_id == const.STAMINA:
            player.stamina.stamina += num
            logger.debug(str(num)+" , stamina+++++++++++")
            player.stamina.save_data()
        elif type_id == const.TRAVEL_ITEM:
            stage_id = travel_item_config.get(item_no).stageId
            flag1 = 1
            flag2 = 0
            stage_item_info = player.travel_component.travel_item.get(stage_id)
            for [travel_item_id, travel_item_num] in stage_item_info:
                if travel_item_id == item_no:
                    stage_item_info[flag2] = \
                        [travel_item_id, travel_item_num + num]
                    flag1 = 0
                    break
                flag2 += 1
            if flag1:
                stage_item_info.append([item_no, num])
            player.travel_component.save()
        elif type_id == u'107':
            shoes = player.travel_component.shoes
            if item_no == 18:
                shoes[0] += num
            elif item_no == 19:
                shoes[1] += num
            elif item_no == 20:
                shoes[2] += num

            player.travel_component.save()

        flag = 1
        for i in result:
            if i[0] == type_id and i[2] == item_no:
                i[1] += 1
                flag = 0
                continue
        if flag:
            result.append([type_id, num, item_no])
        # result.append([type_id, num, item_no])
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
        game_resources_response.finance = finance_pb

    for lst in return_data:
        item_type = lst[0]
        item_num = lst[1]
        item_no = lst[2]

        if const.COIN == item_type:
            finance_pb.coin += item_num
        elif const.GOLD == item_type:
            finance_pb.gold += item_num
        elif const.HERO_SOUL == item_type:
            finance_pb.hero_soul += item_num
        elif const.JUNIOR_STONE == item_type:
            finance_pb.junior_stone += item_num
        elif const.MIDDLE_STONE == item_type:
            finance_pb.middle_stone += item_num
        elif const.HIGH_STONE == item_type:
            finance_pb.high_stone += item_num
        elif const.HERO_CHIP == item_type:
            hero_chip_pb = game_resources_response.hero_chips.add()
            hero_chip_pb.hero_chip_no = item_no
            hero_chip_pb.hero_chip_num = item_num
        elif const.ITEM == item_type:
            item_pb = game_resources_response.items.add()
            item_pb.item_no = item_no
            item_pb.item_num = item_num
        elif const.HERO == item_type:
            hero = player.hero_component.get_hero(item_no)
            hero_pb = game_resources_response.heros.add()
            hero.update_pb(hero_pb)
        elif const.EQUIPMENT == item_type:
            equipment = player.equipment_component.get_equipment(item_no)
            equipment_pb = game_resources_response.equipments.add()
            equipment.update_pb(equipment_pb)
        elif const.EQUIPMENT_CHIP == item_type:
            chip_pb = game_resources_response.equipment_chips.add()
            chip_pb.equipment_chip_no = item_no
            chip_pb.equipment_chip_num = item_num

        elif const.STAMINA == item_type:
            game_resources_response.stamina += item_num

        elif const.TRAVEL_ITEM == item_type:
            travel_item = game_resources_response.travel_item.add()
            travel_item.id = item_no
            travel_item.num = item_num

        elif u'107' == item_type:
            travel_item = game_resources_response.shoes_info.add()
            if item_no == 18:
                shoes_type = 1
            elif item_no == 19:
                shoes_type = 2
            elif item_no == 20:
                shoes_type = 3
            travel_item.shoes_type = shoes_type
            travel_item.shoes_no = item_num

    logger.debug('return resource:%s', game_resources_response)
