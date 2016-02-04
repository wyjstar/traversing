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
from app.game.core.task import hook_task, CONDITIONId


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
            # if item_no == const.GOLD and player.finance[const.GOLD] - player.finance[const.CONSUME_GOLD] < num:
            #     return {'result': False, 'result_no': item_no}
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


def get_consume_gold_num(item_group, multiple=1):
    """docstring for get_consume_gold_num"""
    gold_num = 0
    for group_item in item_group:
        type_id = group_item.item_type
        num = group_item.num * multiple
        item_no = group_item.item_no
        if type_id == const.GOLD:
            gold_num += num
        elif type_id == const.RESOURCE:
            if item_no == const.GOLD:
                gold_num += num
    return gold_num


def consume(player, item_group, reason,
            shop=None, event_id='',
            luck_config=None, multiple=1):
    """消耗"""
    result = []

    after_num = 0
    itid = 0
    # reason = 0

    luckValue = None
    if luck_config:
        luckValue = luck_config.luckyValue
    for group_item in item_group:
        type_id = group_item.item_type
        num = group_item.num * multiple
        item_no = group_item.item_no
        if type_id == const.COIN:
            player.finance.coin -= num
            if shop and luckValue:
                shop['luck_num'] += num * luckValue.get(type_id)
            player.finance.save_data()
            after_num = player.finance.coin

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
            #item.num -= num
            player.item_package.consume_item(item_no, num)
            player.item_package.save_data()

            after_num = item.num - num

        elif type_id == const.RESOURCE:
            player.finance.consume(item_no, num, 0)
            player.finance.save_data()
            after_num = player.finance[item_no]
            if shop and luckValue and luckValue.get(item_no):
                shop['luck_num'] += num * luckValue.get(item_no)

            if item_no == 1 or item_no == 2:
                tlog_action.log('MoneyFlow', player, after_num, num, reason,
                                const.REDUCE, item_no)

        if type_id == const.COIN or type_id == const.GOLD:
            tlog_action.log('MoneyFlow', player, after_num, num, reason,
                            const.REDUCE, item_no)
        result.append([type_id, num, item_no])

        # =====Tlog================
        if type_id != const.RESOURCE:
            tlog_action.log('ItemFlow', player, const.REDUCE, type_id, num,
                            item_no, itid, reason, after_num, event_id)

    return result


def gain(player, item_group, reason,
         result=None,
         multiple=1,
         event_id='',
         part_multiple=[],
         lucky_attr_id=0):
    """获取
    @param item_group: [obj,obj]
    act 掉落翻倍. [[type_ids], xs]  [[翻倍类型列表]，系数]
    """
    if result is None:
        result = []
    after_num = 0
    itid = 0

    for group_item in item_group:
        type_id = group_item.item_type

        num = int(group_item.num * multiple)
        item_no = group_item.item_no

        multiple2 = 1
        for _part_multiple in part_multiple:
            _times = _part_multiple["times"]
            _item_type = _part_multiple["item_type"]
            _item_ids = _part_multiple["item_ids"]
            if type_id == _item_type:
                if not _item_ids[0] or item_no in _item_ids:
                    multiple2 = _times

        logger.debug("multiple %s multiple2 %s" % (multiple, multiple2))
        num = int(multiple2 * num)

        front_type_id = type_id # 记录类型，用于武将已存在的情况。
        if type_id == const.COIN:
            player.finance.coin += num
            player.finance.save_data()
            after_num = player.finance.coin

        elif type_id == const.RESOURCE:
            if item_no == 27:
                hook_task(player, CONDITIONId.GGZJ, num)
            elif item_no == const.TEAM_EXPERIENCE:
                player.base_info.addexp(num, reason)
                player.base_info.save_data()
                after_num = player.base_info.exp
            else:
                player.finance.add(item_no, num)
                player.finance.save_data()
                after_num = player.finance[item_no]

            if item_no == 1 or item_no == 2:
                tlog_action.log('MoneyFlow', player, after_num, num, reason,
                                const.ADD, item_no)

        elif type_id == const.GOLD:
            player.finance.add_gold(num, 0)
            player.finance.save_data()

        elif type_id == const.HERO_SOUL:
            player.finance.hero_soul += num
            player.finance.save_data()

        elif type_id == const.PVP:
            player.finance.pvp_score += num
            player.finance.save_data()

        elif type_id == const.HERO_CHIP:
            if game_configs.chip_config.get('chips').get(item_no):
                hero_chip = HeroChip(item_no, num)
                player.hero_chip_component.add_chip(hero_chip)
                player.hero_chip_component.save_data()
                after_num = player.hero_chip_component.get_chip(item_no).num
            else:
                logger.error('chip config not found:%', item_no)

        elif type_id == const.ITEM:
            item = Item(item_no, num)
            player.item_package.add_item(item)
            player.item_package.save_data()
            after_num = player.item_package.get_item(item_no).num

        elif type_id == const.HERO:
            is_have = player.hero_component.contain_hero(item_no)
            if not is_have:
                num -= 1
            if num != 0:
                # 已经存在该武将，自动转换为武将碎片
                # 获取hero对应的hero_chip_no, hero_chip_num
                hero_chip_config_item = game_configs.chip_config.get("mapping").get(item_no)
                hero_chip_no = hero_chip_config_item.id
                CardImparirment = 1
                if reason == const.SHOP_DRAW_HERO:
                    CardImparirment = game_configs.base_config.get("CardImparirment")
                hero_chip_num = int(hero_chip_config_item.needNum * num * CardImparirment)

                hero_chip = HeroChip(hero_chip_no, hero_chip_num)
                player.hero_chip_component.add_chip(hero_chip)
                player.hero_chip_component.save_data()
                after_num = player.hero_chip_component.get_chip(hero_chip_no).num

                result.append([const.HERO_CHIP, hero_chip_num, hero_chip_no])

                tlog_action.log('ItemFlow', player, const.ADD, type_id,
                                hero_chip_num, hero_chip_no, itid, reason,
                                after_num, event_id)
            if not is_have:
                hero = player.hero_component.add_hero(item_no)
                notice_item = game_configs.notes_config.get(2002)
                logger.debug("=================%s %s %s" % (reason, hero.hero_info.quality, notice_item.parameter1))
                if reason == const.SHOP_DRAW_HERO and hero.hero_info.quality in notice_item.parameter1:
                    push_notice(2002, player_name=player.base_info.base_name, hero_no=item_no)
                after_num = 1

                result.append([type_id, 1, item_no])

                tlog_action.log('ItemFlow', player, const.ADD, type_id,
                                1, item_no, itid, reason,
                                after_num, event_id)

        elif type_id == const.BIG_BAG:
            big_bag = BigBag(item_no)
            for i in range(num):
                temp = big_bag.get_drop_items()
                gain(player, temp, reason, result)
            return result

        elif type_id == const.EQUIPMENT:
            for _ in range(num):
                itid = item_no
                equipment = player.equipment_component.add_equipment(itid, lucky_attr_id)
                equ_item_no = equipment.base_info.id
                after_num = player.equipment_component.get_equipment_num(itid)
                notice_item = game_configs.notes_config.get(2004)
                if reason == const.COMMON_BUY_PVP and equipment.equipment_config_info.quality in notice_item.parameter1:
                    push_notice(2004, player_name=player.base_info.base_name, equipment_no=itid)

                notice_item = game_configs.notes_config.get(2005)
                if reason ==const.COMMON_BUY_MELT and equipment.equipment_config_info.quality in notice_item.parameter1:
                    push_notice(2005, player_name=player.base_info.base_name, equipment_no=itid)

                notice_item = game_configs.notes_config.get(2006)
                if reason == const.COMMON_BUY_EQUIPMENT and equipment.equipment_config_info.quality in notice_item.parameter1:
                    push_notice(2006, player_name=player.base_info.base_name, equipment_no=itid)

                result.append([type_id, 1, equ_item_no])
                tlog_action.log('ItemFlow', player, const.ADD, type_id, 1,
                                itid, item_no, reason, after_num, event_id)

        elif type_id == const.EQUIPMENT_CHIP:
            if game_configs.chip_config.get('chips').get(item_no):
                chip = EquipmentChip(item_no, num)
                player.equipment_chip_component.add_chip(chip)
                player.equipment_chip_component.save_data()
                after_num = player.equipment_chip_component.get_chip(item_no).chip_num
            else:
                logger.error('chip config not found:%', item_no)

        elif type_id == const.STAMINA:
            player.stamina.stamina += num
            # logger.debug(str(num)+" , stamina+++++++++++")
            player.stamina.save_data()

        elif type_id == const.TEAM_EXPERIENCE:
            player.base_info.addexp(num, reason)
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
            for _ in range(num):
                runt_id = player.runt.add_runt(item_no)
                result.append([type_id, 1, runt_id])
            player.runt.save()
            after_num = player.runt.get_runt_num(item_no)

        if type_id == const.COIN or type_id == const.GOLD:
            tlog_action.log('MoneyFlow', player, after_num, num, reason,
                            const.ADD, item_no)

        is_over = False       # 是否累加
        for i in result:
            if i[0] == type_id and i[2] == item_no and (front_type_id != const.HERO and type_id != const.HERO_CHIP and type_id != const.RUNT and type_id != const.EQUIPMENT and type_id != const.HERO):
                i[1] += num
                is_over = True
                continue

        if not is_over and type_id !=const.RUNT and type_id != const.HERO and type_id != const.EQUIPMENT:
            result.append([type_id, num, item_no])

        # ====tlog======
        if type_id != const.TEAM_EXPERIENCE and type_id != const.EQUIPMENT and type_id != const.HERO:
            tlog_action.log('ItemFlow', player, const.ADD, type_id, num,
                            item_no, itid, reason, after_num, event_id)
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
        item_num = int(lst[1])
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

            for finance_changes in game_resources_response.finance.finance_changes:
                if finance_changes.item_type == item_type and finance_changes.item_no == item_no:
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


def do_get_draw_drop_bag(pseudo_bag_id, draw_times):
    pseudo_random_info = game_configs.pseudo_random_config.get(pseudo_bag_id)
    assert pseudo_random_info!=None, "can not find pseudo bag:%s" % pseudo_bag_id
    gain = pseudo_random_info.gain
    drop_items = []
    for k in sorted(gain.keys(), reverse=True):
        if draw_times >= k:
            bags = gain.get(k)
            for bag_id in bags:
                # logger.debug("drop_bag_id %s", bag_id)
                big_bag = BigBag(bag_id)
                drop_items.extend(big_bag.get_drop_items())
            break
    # logger.debug("drop_items %s", drop_items)
    return drop_items

def dump_game_response_to_string():
    """
    game_resource_response to [{107:[1,1,1]}]
    """
    pass
