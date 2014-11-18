# -*- coding:utf-8 -*-
"""
created by server on 14-7-14下午5:25.
"""
from app.proto_file import line_up_pb2
from gfirefly.server.globalobject import remoteserviceHandle
import cPickle
from app.game.core.PlayersManager import PlayersManager
from app.game.core.hero import Hero
from app.game.redis_mode import tb_character_line_up
from app.game.redis_mode import tb_character_hero
from app.game.redis_mode import tb_equipment_info
from app.game.core.check import check_have_equipment
from gfirefly.server.logobj import logger


@remoteserviceHandle('gate')
def get_line_up_info_701(pro_data, player):
    """取得阵容信息 """
    response = line_up_info(player)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def get_target_line_up_info_706(pro_data, player):
    """取得目标玩家阵容信息
    """
    request = line_up_pb2.GetLineUpRequest()
    request.ParseFromString(pro_data)
    target_id = request.target_id

    invitee_player = PlayersManager().get_player_by_id(target_id)
    if invitee_player:  # 在线
        response = line_up_info(invitee_player)
    else:
        response = line_up_pb2.LineUpResponse()

        heros_obj = {}
        heros = tb_character_hero.getObjListByFk(target_id)
        hero_ids = tb_character_hero.getAllPkByFk(target_id)

        for hero_mmode in heros:
            data = hero_mmode.get('data')
            hero = Hero(target_id)
            hero.init_data(data)
            heros_obj[hero.hero_no] = hero

        line_up_data = tb_character_line_up.getObjData(target_id)

        if line_up_data:
            # 阵容位置信息
            line_up_slots = line_up_data.get('line_up_slots')

            for slot_no, slot1 in line_up_slots.items():
                slot = cPickle.loads(slot1)
                add_slot = response.slot.add()
                add_slot.slot_no = slot.get('slot_no')

                add_slot.activation = slot.get('activation')
                if not slot.get('activation'):  # 如果卡牌位未激活，则不初始化信息
                    continue

                hero_obj = heros_obj.get(slot.get('hero_no'))
                if hero_obj:
                    hero = add_slot.hero
                    hero.hero_no = hero_obj.hero_no
                    hero.level = hero_obj.level
                    hero.exp = hero_obj.exp
                    hero.break_level = hero_obj.break_level

                    t_data = {'ids': [], 'datas': {}}
                    equipment_ids = slot.get('equipment_ids').values()
                    for equ_id in equipment_ids:
                        if equ_id:
                            equ_data = tb_equipment_info.getObjData(equ_id)
                            # t_equipment_ids
                            if equ_data:
                                t_data['ids'].append(equ_data.get('equipment_info').get('equipment_no'))
                                t_data['datas'][equ_id] = equ_data

                    link_data = {}
                    for i in range(1, 6):
                        link_no = getattr(hero_obj.hero_links, 'link%s' % i)  # 羁绊技能
                        trigger_list = getattr(hero_obj.hero_links, 'trigger%s' % i)  # 羁绊触发条件
                        if not link_no:
                            continue

                        activation = 0
                        if trigger_list:
                            activation = 1

                            for no in trigger_list:
                                if len('%s' % no) == 5:  # 英雄ID
                                    if no not in hero_ids:  # 羁绊需要英雄不在阵容中
                                        activation = 0
                                        break
                                elif len('%s' % no) == 6:  # 装备ID
                                    if no not in t_data.get('ids'):  # 羁绊需要的装备不在阵容中
                                        activation = 0
                                        break
                        link_data[link_no] = activation

                    link_info = link_data
                    for key, value in link_info.items():
                        add_link = hero.links.add()
                        add_link.link_no = key
                        add_link.is_activation = value

                    for key, equipment_id in slot.get('equipment_ids').items():
                        equ_add = add_slot.equs.add()
                        equ_add.no = key

                        equipment_obj = t_data.get('datas').get(equipment_id)
                        if equipment_obj:
                            equ = equ_add.equ
                            equ.id = equipment_id
                            equ.no = equipment_obj.get('equipment_info').get('equipment_no')
                            equ.strengthen_lv = equipment_obj.get('equipment_info').get('slv')
                            equ.awakening_lv = equipment_obj.get('equipment_info').get('alv')

            # 助威位置信息
            line_sub_slots = line_up_data.get('sub_slots')
            for sub_slot_no, sub_slot in line_sub_slots.items():
                slot = cPickle.loads(sub_slot)

                add_slot = response.sub.add()
                add_slot.slot_no = slot.get('slot_no')
                add_slot.activation = slot.get('activation')
                if not slot.get('activation'):  # 如果卡牌位未激活，则不初始化信息
                    continue

                hero_obj = heros_obj.get(slot.get('hero_no'))

                if hero_obj:

                    hero = add_slot.hero
                    hero.hero_no = hero_obj.hero_no
                    hero.level = hero_obj.level
                    hero.exp = hero_obj.exp
                    hero.break_level = hero_obj.break_level
                    hero.refine = hero_obj.refine

    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def change_hero_702(pro_data, player):
    """更换英雄
    """
    request = line_up_pb2.ChangeHeroRequest()
    request.ParseFromString(pro_data)
    slot_no = request.slot_no
    change_type = request.change_type  # 更换类型
    hero_no = request.hero_no
    return change_hero(slot_no, hero_no, change_type, player)


@remoteserviceHandle('gate')
def change_equipments_703(pro_data, player):
    """更换装备
    """
    request = line_up_pb2.ChangeEquipmentsRequest()
    request.ParseFromString(pro_data)
    slot_no = request.slot_no
    no = request.no
    equipment_id = request.equipment_id
    return change_equipment(slot_no, no, equipment_id, player)


def change_hero(slot_no, hero_no, change_type, player):
    """
    @param dynamic_id:
    @param slot_no:
    @param hero_no:
    @param kwargs:
    @return:
    """
    logger.debug("change hero: slot_no:%d, hero_no:%d, change_type:%d", slot_no, hero_no, change_type)

    # 校验该武将是否已经上阵
    response = line_up_pb2.LineUpResponse()
    if hero_no in player.line_up_component.hero_nos:
        logger.debug("hero already in the line up+++++++")
        response.res.result = False
        response.res.result_no = 701
        return response.SerializePartialToString()

    player.line_up_component.change_hero(slot_no, hero_no, change_type)
    player.line_up_component.save_data()

    response = line_up_info(player)

    for slot in response.slot:
        logger.debug("slot no %d, %d", slot.slot_no, slot.hero.hero_no)
        for equip in slot.equs:
            logger.debug("equip no %d", equip.no)

    return response.SerializePartialToString()


def change_equipment(slot_no, no, equipment_id, player):
    """
    @param dynamic_id: 动态ID
    @param slot_no: 阵容位置
    @param no: 装备位置
    @param equipment_id: 装备ID
    @return:
    """
    logger.debug("change equipment id %s %s %s", slot_no, no, equipment_id)
    response = line_up_pb2.LineUpResponse()

    # 检验装备是否存在
    if equipment_id != '0' and not check_have_equipment(player, equipment_id):
        logger.debug("1check_have_equipment %d", equipment_id)
        response.res.result = False
        response.res.result_no = 702
        return response.SerializePartialToString()

    # 校验该装备是否已经装备
    if equipment_id != '0' and equipment_id in player.line_up_component.on_equipment_ids:
        logger.debug("2check_have_equipment")
        response.res.result = False
        response.res.result_no = 703
        return response.SerializePartialToString()

    # 校验装备类型
    if not player.line_up_component.change_equipment(slot_no, no, equipment_id):
        logger.debug("3check_have_equipment")
        response.res.result = False
        response.res.result_no = 704
        return response.SerializePartialToString()
    logger.debug("0check_have_equipment")
    player.line_up_component.save_data()
    response = line_up_info(player)
    return response.SerializePartialToString()


def line_up_info(player):
    """取得用户的阵容信息
    """
    response = line_up_pb2.LineUpResponse()
    assembly_slots(player, response)
    assembly_sub_slots(player, response)

    return response


def assembly_slots(player, response):
    """组装阵容单元格
    """
    line_up_slots = player.line_up_component.line_up_slots
    for slot in line_up_slots.values():
        add_slot = response.slot.add()
        add_slot.slot_no = slot.slot_no

        add_slot.activation = slot.activation
        if not slot.activation:  # 如果卡牌位未激活，则不初始化信息
            continue
        hero_obj = slot.hero_slot.hero_obj  # 英雄实例
        if hero_obj:
            hero = add_slot.hero
            hero.hero_no = hero_obj.hero_no
            hero.level = hero_obj.level
            hero.exp = hero_obj.exp
            hero.break_level = hero_obj.break_level
            link_info = slot.hero_slot.link
            for key, value in link_info.items():
                add_link = hero.links.add()
                add_link.link_no = key
                add_link.is_activation = value
        for key, equipment_slot in slot.equipment_slots.items():
            equ_add = add_slot.equs.add()
            equ_add.no = key

            equipment_obj = equipment_slot.equipment_obj
            if equipment_obj:
                equ = equ_add.equ
                equ.id = equipment_obj.base_info.id
                equ.no = equipment_obj.base_info.equipment_no
                equ.strengthen_lv = equipment_obj.attribute.strengthen_lv
                equ.awakening_lv = equipment_obj.attribute.awakening_lv
                equ.set.no = equipment_slot.suit.get('suit_no', 0)
                equ.set.num = equipment_slot.suit.get('num', 0)


def assembly_sub_slots(player, response):
    """组装助威阵容
    """
    sub_slots = player.line_up_component.sub_slots
    for slot in sub_slots.values():
        add_slot = response.sub.add()
        add_slot.slot_no = slot.slot_no

        add_slot.activation = slot.activation
        if not slot.activation:  # 如果卡牌位未激活，则不初始化信息
            continue
        hero_obj = slot.hero_slot.hero_obj  # 英雄实例
        if hero_obj:
            hero = add_slot.hero
            hero.hero_no = hero_obj.hero_no
            hero.level = hero_obj.level
            hero.exp = hero_obj.exp
            hero.break_level = hero_obj.break_level
            link_info = slot.hero_slot.link
            for key, value in link_info.items():
                add_link = hero.links.add()
                add_link.link_no = key
                add_link.is_activation = value
