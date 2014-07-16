# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午11:03.
"""
from app.proto_file import line_up_pb2


def line_up_info(player):
    """取得用户的阵容信息
    """
    line_up_slots = player.line_up_component.line_up_slots
    links_info = player.line_up_component.get_links()  # 羁绊信息

    response = line_up_pb2.LineUpResponse()

    for slot in line_up_slots:
        add_slot = response.slot.add()
        add_slot.slot_no = slot.slot_no
        add_slot.activation = slot.activation

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

            equipment_obj = player.equipment.get(value)
            if equipment_obj:
                equ = equ_add.equ
                equ.id = equipment_obj.base_info.id
                equ.no = equipment_obj.base_info.equipment_no
                equ.strengthen_lv = equipment_obj.attribute.strengthen_lv
                equ.awakening_lv = equipment_obj.attribute.awakening_lv

                # TODO

    return response






