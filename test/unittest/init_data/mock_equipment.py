# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午3:37.
"""
from app.game.core.equipment.equipment import Equipment
from shared.utils.pyuuid import get_uuid
from shared.db_opear.configs_data import game_configs


def init_equipment(player):

    for equip_no, val in game_configs.equipment_config.items():
        equipment_obj = Equipment(1, get_uuid(), '', equip_no)
        player.equipment_component.add_exist_equipment(equipment_obj)
        equipment_obj.attribute.strengthen_lv = 1

    return
    equipment_obj = Equipment(get_uuid(), '', 100001)
    player.equipment_component.add_exist_equipment(equipment_obj)
    equipment_obj.attribute.strengthen_lv = 2
    equipment_obj.attribute.awakening_lv = 2
    equipment_obj.save_data()

    equipment_obj = Equipment(get_uuid(), '', 100002)
    player.equipment_component.add_exist_equipment(equipment_obj)
    equipment_obj.attribute.strengthen_lv = 2
    equipment_obj.attribute.awakening_lv = 2
    equipment_obj.save_data()

    equipment_obj = Equipment(get_uuid(), '', 100003)
    player.equipment_component.add_exist_equipment(equipment_obj)
    equipment_obj.attribute.strengthen_lv = 2
    equipment_obj.attribute.awakening_lv = 2
    equipment_obj.save_data()

    equipment_obj = Equipment(get_uuid(), '', 100004)
    player.equipment_component.add_exist_equipment(equipment_obj)
    equipment_obj.attribute.strengthen_lv = 2
    equipment_obj.attribute.awakening_lv = 2
    equipment_obj.save_data()

    equipment_obj = Equipment(get_uuid(), '', 100005)
    player.equipment_component.add_exist_equipment(equipment_obj)
    equipment_obj.attribute.strengthen_lv = 2
    equipment_obj.attribute.awakening_lv = 2
    equipment_obj.save_data()

    equipment_obj = Equipment(get_uuid(), '', 100006)
    player.equipment_component.add_exist_equipment(equipment_obj)
    equipment_obj.attribute.strengthen_lv = 2
    equipment_obj.attribute.awakening_lv = 2
    equipment_obj.save_data()

    player.equipment_component.save_data()
