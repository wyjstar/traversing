# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午5:11.
"""

from app.game.core.hero_chip import HeroChip
from app.game.core.equipment.equipment_chip import EquipmentChip
from app.game.core.pack.item import Item
from shared.db_opear.configs_data import game_configs
from app.game.core.drop_bag import BigBag
from app.proto_file.player_pb2 import FinancePB
from shared.utils.const import const
from gfirefly.server.logobj import logger
import time
from shared.tlog import tlog_action
from app.game.core.notice import push_notice


def is_afford(player, item_group, multiple=1):
    """消耗是否足够。"""
    for group_item in item_group:
        type_id = group_item.item_type
        num = group_item.num * multiple
        item_no = group_item.item_no
        if type_id == const.COIN and player.finance.coin < num:
            return {'result': False, 'result_no': 101}
        elif type_id == const.GOLD and player.finance.gold < num:
            return {'result': False, 'result_no': 102}
        elif type_id == const.HERO_SOUL and player.finance.hero_soul < num:
            return {'result': False, 'result_no': 103}
        elif type_id == const.PVP and player.finance.pvp_score < num:
            return {'result': False, 'result_no': 110}
        elif type_id == const.RESOURCE:
            if player.finance[item_no] < num:
                return {'result': False, 'result_no': item_no}
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


def is_consume(player, shop_item):
    """判断是否免费抽取"""
    free_period = shop_item.freePeriod
    shop_item_type = shop_item.type
    if free_period == -1:
        return True

    last_pick_time = 0
    if shop_item_type == 1 and free_period > 0:
        # 单抽良将
        last_pick_time = player.last_pick_time.fine_hero
    elif shop_item_type == 5 and free_period > 0:
        # 单抽神将
        last_pick_time = player.last_pick_time.excellent_hero
    elif shop_item_type == 2:
        # 单抽良装
        last_pick_time = player.last_pick_time.fine_equipment
    elif shop_item_type == 6:
        # 单抽神装
        last_pick_time = player.last_pick_time.excellent_equipment

    if last_pick_time + free_period*60*60 <= int(time.time()):
        # 抽取后重置时间
        if shop_item_type == 1:
            # 单抽良将
            player.last_pick_time.fine_hero = int(time.time())
        elif shop_item_type == 5:
            # 单抽神将
            player.last_pick_time.excellent_hero = int(time.time())
        elif shop_item_type == 2:
            # 单抽良装
            player.last_pick_time.fine_equipment = int(time.time())
        elif shop_item_type == 6:
            # 单抽神装
            player.last_pick_time.excellent_equipment = int(time.time())

        player.last_pick_time.save_data()
        return False

    return True


def consume(player, item_group, shop=None, luck_config=None, multiple=1):
# def consume(player, item_group, reason, shop=None, luck_config=None):
    """消耗"""
    result = []

    after_num = 0
    itid = 0
    reason = 0

    luckValue = None
    if luck_config:
        luckValue = luck_config.luckyValue
        print luckValue
    for group_item in item_group:
        type_id = group_item.item_type
        num = group_item.num * multiple
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
            after_num = player.finance.gold

        elif type_id == const.HERO_SOUL:
            player.finance.hero_soul -= num
            player.finance.save_data()
            after_num = player.finance.hero_soul

        elif type_id == const.PVP:
            player.finance.pvp_score -= num
            player.finance.save_data()
            after_num = player.finance.pvp_score

        elif type_id == const.HERO_CHIP:
            hero_chip = player.hero_chip_component.get_chip(item_no)
            hero_chip.num -= num
            player.hero_chip_component.save_data()
            after_num = hero_chip.num

        elif type_id == const.EQUIPMENT_CHIP:
            equipment_chip = player.equipment_chip_component.get_chip(item_no)
            equipment_chip.chip_num -= num
            player.equipment_chip_component.save_data()
            after_num = equipment_chip.chip_num

        elif type_id == const.ITEM:
            item = player.item_package.get_item(item_no)
            item.num -= num
            player.item_package.save_data()
            after_num = item.num

        elif type_id == const.RESOURCE:
            player.finance[item_no] -= num
            player.finance.save_data()
            after_num = player.finance[item_no]
            if shop and luckValue and luckValue.get(item_no):
                shop['luck_num'] += num * luckValue.get(item_no)

        result.append([type_id, num, item_no])

        # =====Tlog================
        tlog_action.log('ItemFlow', player, const.ADD, type_id, num, item_no, itid, reason, after_num)

    return result


def gain(player, item_group, reason, result=None, multiple=1):
    """获取
    @param item_group: [obj,obj]
    """
    if result is None:
        result = []

    after_num = 0
    itid = 0

    for group_item in item_group:
        type_id = group_item.item_type
        num = group_item.num * multiple
        item_no = group_item.item_no
        front_type_id = type_id # 记录类型，用于武将已存在的情况。
        if type_id == const.COIN:
            player.finance.coin += num
            player.finance.save_data()
            after_num = player.finance.coin

        elif type_id == const.RESOURCE:
            if item_no == 18:
                shoes = player.travel_component.shoes
                shoes[0] += num
                player.travel_component.save()
                after_num = shoes[0]
            elif item_no == 19:
                shoes = player.travel_component.shoes
                shoes[1] += num
                player.travel_component.save()
                after_num = shoes[1]
            elif item_no == 20:
                shoes = player.travel_component.shoes
                shoes[2] += num
                player.travel_component.save()
                after_num = shoes[2]
            else:
                player.finance[item_no] += num
                player.finance.save_data()
                after_num = player.finance[item_no]

        elif type_id == const.GOLD:
            player.finance.gold += num
            player.finance.save_data()

        elif type_id == const.HERO_SOUL:
            player.finance.hero_soul += num
            player.finance.save_data()

        elif type_id == const.PVP:
            player.finance.pvp_score += num
            player.finance.save_data()

        elif type_id == const.HERO_CHIP:
            hero_chip = HeroChip(item_no, num)
            player.hero_chip_component.add_chip(hero_chip)
            player.hero_chip_component.save_data()
            after_num = player.hero_chip_component.get_chip(item_no).num

        elif type_id == const.ITEM:
            item = Item(item_no, num)
            player.item_package.add_item(item)
            player.item_package.save_data()
            after_num = player.item_package.get_item(item_no).num

        elif type_id == const.HERO:
            if player.hero_component.contain_hero(item_no):
                # 已经存在该武将，自动转换为武将碎片
                # 获取hero对应的hero_chip_no, hero_chip_num
                hero_chip_config_item = game_configs.chip_config.get("mapping").get(item_no)
                hero_chip_no = hero_chip_config_item.id
                hero_chip_num = hero_chip_config_item.needNum
                print hero_chip_num, "--"*30

                hero_chip = HeroChip(hero_chip_no, hero_chip_num)
                player.hero_chip_component.add_chip(hero_chip)
                player.hero_chip_component.save_data()
                type_id = const.HERO_CHIP
                item_no = hero_chip_no
                num = hero_chip_num
                after_num = player.hero_chip_component.get_chip(item_no).num
            else:
                hero = player.hero_component.add_hero(item_no)
                notice_item = game_configs.notes_config.get(3001)
                logger.debug("=================%s %s %s" % (reason, hero.hero_info.quality, notice_item.parameter1))
                if reason == const.SHOP_DRAW_HERO and hero.hero_info.quality in notice_item.parameter1:
                    push_notice(3001, player_name=player.base_info.base_name, hero_no=item_no)
                after_num = 1

        elif type_id == const.BIG_BAG:
            big_bag = BigBag(item_no)
            for i in range(num):
                temp = big_bag.get_drop_items()
                print temp, "-+"*30
                gain(player, temp, reason, result)
            return result

        elif type_id == const.EQUIPMENT:
            equipment = player.equipment_component.add_equipment(item_no)
            itid = item_no
            item_no = equipment.base_info.id
            after_num = player.equipment_component.get_equipment_num(itid)
            notice_item = game_configs.notes_config.get(3001)
            if reason == const.COMMON_BUY_PVP and equipment.equipment_config_info.quality in notice_item.parameter1:
                push_notice(5001, player_name=player.base_info.base_name, equipment_no=item_no)

            notice_item = game_configs.notes_config.get(6001)
            if reason ==const.COMMON_BUY_MELT and equipment.equipment_config_info.quality in notice_item.parameter1:
                push_notice(6001, player_name=player.base_info.base_name, equipment_no=item_no)

            notice_item = game_configs.notes_config.get(7001)
            if reason == const.COMMON_BUY_EQUIPMENT and equipment.equipment_config_info.quality in notice_item.parameter1:
                push_notice(7001, player_name=player.base_info.base_name, equipment_no=item_no)

        elif type_id == const.EQUIPMENT_CHIP:
            chip = EquipmentChip(item_no, num)
            player.equipment_chip_component.add_chip(chip)
            player.equipment_chip_component.save_data()
            after_num = player.equipment_chip_component.get_chip(item_no).chip_num

        elif type_id == const.STAMINA:
            player.stamina.stamina += num
            # logger.debug(str(num)+" , stamina+++++++++++")
            player.stamina.save_data()

        elif type_id == const.TEAM_EXPERIENCE:
            player.base_info.addexp(num, const.GAIN)
            player.base_info.save_data()

        elif type_id == const.TRAVEL_ITEM:
            after_num = num
            stage_id = game_configs.travel_item_config.get('items').get(item_no).stageId
            flag1 = 1
            flag2 = 0
            stage_item_info = player.travel_component.travel_item.get(stage_id)
            for [travel_item_id, travel_item_num] in stage_item_info:
                if travel_item_id == item_no:
                    the_num = travel_item_num + num
                    stage_item_info[flag2] = \
                        [travel_item_id, the_num]
                    flag1 = 0
                    after_num = the_num
                    break
                flag2 += 1
            if flag1:
                stage_item_info.append([item_no, num])
            player.travel_component.save()

        elif type_id == const.RUNT:
            itid = item_no
            item_no = player.runt.add_runt(item_no)
            player.runt.save()
            after_num = player.runt.get_runt_num(item_no)

        is_over = False       # 是否累加
        for i in result:
            if i[0] == type_id and i[2] == item_no and (front_type_id != const.HERO and type_id !=const.HERO_CHIP):
                i[1] += num
                is_over = True
                continue

        if not is_over:
            result.append([type_id, num, item_no])

        # ====tlog======
        if type_id in [const.EQUIPMENT, const.RUNT]:
            a = itid
            itid = item_no
            item_no = a
        if type_id != const.TEAM_EXPERIENCE:
            tlog_action.log('ItemFlow', player, const.ADD, type_id, num, item_no, itid, reason, after_num)
        # ==============

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
        elif const.PVP == item_type:
            finance_pb.pvp_score += item_num
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

        elif const.TEAM_EXPERIENCE == item_type:
            game_resources_response.team_exp += item_num

        elif 107 == item_type:
            if item_no == 18:
                travel_item = game_resources_response.shoes_info.add()
                shoes_type = 1
                travel_item.shoes_type = shoes_type
                travel_item.shoes_no = item_num
            elif item_no == 19:
                travel_item = game_resources_response.shoes_info.add()
                shoes_type = 2
                travel_item.shoes_type = shoes_type
                travel_item.shoes_no = item_num
            elif item_no == 20:
                travel_item = game_resources_response.shoes_info.add()
                shoes_type = 3
                travel_item.shoes_type = shoes_type
                travel_item.shoes_no = item_num
            else:
                for finance_changes in game_resources_response.finance.finance_changes:
                    if finance_changes.item_type == item_type:
                        finance_changes.item_num += item_num
                        break
                else:
                    change = game_resources_response.finance.finance_changes.add()
                    change.item_type = item_type
                    change.item_num = item_num
                    change.item_no = item_no
        elif 108 == item_type:
            [runt_id, main_attr, minor_attr] = player.runt.m_runt.get(item_no)
            runt_pb = game_resources_response.runt.add()
            player.runt.deal_runt_pb(item_no, runt_id, main_attr, minor_attr, runt_pb)

    # logger.debug('return resource:%s', game_resources_response)
