# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午11:03.
"""
from app.proto_file import line_up_pb2
from app.game.logic.common.check import have_player


@have_player
def get_line_up_info(dynamic_id, **kwargs):
    player = kwargs.get('player')
    response = line_up_info(player)
    return response.SerializePartialToString()


@have_player
def change_hero(dynamic_id, slot_no, hero_no, change_type, **kwargs):
    """
    @param dynamic_id:
    @param slot_no:
    @param hero_no:
    @param kwargs:
    @return:
    """
    player = kwargs.get('player')
    # 校验该武将是否已经上阵
    response = line_up_pb2.LineUpResponse()
    if hero_no in player.line_up_component.hero_nos:
        response.res.result = False
        response.res.result_no = 701
        return response.SerializePartialToString()

    player.line_up_component.change_hero(slot_no, hero_no, change_type)
    player.line_up_component.save_data()

    response = line_up_info(player)
    return response.SerializePartialToString()


@have_player
def change_equipment(dynamic_id, slot_no, no, equipment_id, **kwargs):
    """
    @param dynamic_id: 动态ID
    @param slot_no: 阵容位置
    @param no: 装备位置
    @param equipment_id: 装备ID
    @return:
    """
    player = kwargs.get('player')
    # 校验该装备是否已经装备
    response = line_up_pb2.LineUpResponse()
    if equipment_id in player.line_up_component.on_equipment_ids:
        response.res.result = False
        response.res.result_no = 702
        return response.SerializePartialToString()

    player.line_up_component.change_equipment(slot_no, no, equipment_id)
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



