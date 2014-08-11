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
def change_hero(dynamic_id, slot_no, hero_no, **kwargs):
    """
    @param dynamic_id:
    @param slot_no:
    @param hero_no:
    @param kwargs:
    @return:
    """

    print 'have player change hero #1:', slot_no, hero_no

    player = kwargs.get('player')

    # TODO 校验

    player.line_up_component.change_hero(slot_no, hero_no)
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

    player.line_up_component.change_equipment(slot_no, no, equipment_id)
    player.line_up_component.save_data()
    response = line_up_info(player)
    return response.SerializePartialToString()


def line_up_info(player):
    """取得用户的阵容信息
    """
    line_up_slots = player.line_up_component.line_up_slots
    print 'line_up_slots:', line_up_slots
    links_info = player.line_up_component.get_links()  # 羁绊信息

    print 'links_info:', links_info

    response = line_up_pb2.LineUpResponse()

    for slot in line_up_slots.values():
        add_slot = response.slot.add()
        add_slot.slot_no = slot.slot_no
        add_slot.activation = slot.activation

        if not slot.activation:  # 如果卡牌位未激活，则不初始化信息
            continue
        hero_no = slot.hero_no  # 英雄编号

        # 组装英雄
        hero_obj = None
        if hero_no:
            hero_obj = player.hero_component.heros.get(hero_no)
        if hero_obj:
            hero = add_slot.hero
            hero.hero_no = hero_obj.hero_no
            hero.level = hero_obj.level
            hero.exp = hero_obj.exp
            hero.break_level = hero_obj.break_level

            link_info = links_info.get(hero_no, {})

            for key, value in link_info.items():
                add_link = hero.links.add()
                add_link.link_no = key
                add_link.is_activation = value

        for key, value in slot.equipment_ids.items():
            equ_add = add_slot.equs.add()
            equ_add.no = key

            equipment_obj = player.equipment_component.equipments_obj.get(value)
            if equipment_obj:
                equ = equ_add.equ
                equ.id = equipment_obj.base_info.id
                equ.no = equipment_obj.base_info.equipment_no
                equ.strengthen_lv = equipment_obj.attribute.strengthen_lv
                equ.awakening_lv = equipment_obj.attribute.awakening_lv

                # TODO

    return response






