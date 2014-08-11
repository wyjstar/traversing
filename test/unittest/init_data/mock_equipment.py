# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午3:37.
"""
from app.game.core.equipment.equipment import Equipment
from app.game.core.PlayersManager import PlayersManager


def init_equipment():
    print '#1 --------------------'
    player = PlayersManager().get_player_by_id(1)
    equipment = player.equipment_component.add_equipment(110001)
    equipment.base_info.base_name = 'e1'
    equipment.attribute.strengthen_lv = 1
    equipment.attribute.awakening_lv = 1
    equipment.save_data()

    player.equipment_component.add_equipment(110002)
    equipment.base_info.base_name = 'e2'
    equipment.attribute.strengthen_lv = 2
    equipment.attribute.awakening_lv = 2
    equipment.save_data()

    player.equipment_component.add_equipment(110003)
    equipment.base_info.base_name = 'e3'
    equipment.attribute.strengthen_lv = 2
    equipment.attribute.awakening_lv = 2
    equipment.save_data()

    player.equipment_component.add_equipment(110004)
    equipment.base_info.base_name = 'e4'
    equipment.attribute.strengthen_lv = 2
    equipment.attribute.awakening_lv = 2
    equipment.save_data()

    player.equipment_component.add_equipment(110005)
    equipment.base_info.base_name = 'e5'
    equipment.attribute.strengthen_lv = 2
    equipment.attribute.awakening_lv = 2
    equipment.save_data()

    player.equipment_component.add_equipment(110006)
    equipment.base_info.base_name = 'e6'
    equipment.attribute.strengthen_lv = 2
    equipment.attribute.awakening_lv = 2
    equipment.save_data()

    equipment = Equipment("001111", '', 100001)
    player.equipment_component.add_exist_equipment(equipment)
    equipment.base_info.base_name = 'e6'
    equipment.attribute.strengthen_lv = 10
    equipment.attribute.awakening_lv = 20
    equipment.attribute.nobbing_effect = 9
    equipment.save_data()

    equipment = Equipment("001112", '', 100023)
    player.equipment_component.add_exist_equipment(equipment)
    equipment.base_info.base_name = 'e6'
    equipment.attribute.strengthen_lv = 11
    equipment.attribute.awakening_lv = 20
    equipment.attribute.nobbing_effect = 9
    equipment.save_data()

    equipment = Equipment("001113", '', 100022)
    player.equipment_component.add_exist_equipment(equipment)
    equipment.base_info.base_name = 'e6'
    equipment.attribute.strengthen_lv = 2
    equipment.attribute.awakening_lv = 20
    equipment.attribute.nobbing_effect = 9
    equipment.save_data()

    equipment = Equipment("001114", '', 100036)
    player.equipment_component.add_exist_equipment(equipment)
    equipment.base_info.base_name = 'e6'
    equipment.attribute.strengthen_lv = 110
    equipment.attribute.awakening_lv = 20
    equipment.attribute.nobbing_effect = 9
    equipment.save_data()

    equipment = Equipment("001115", '', 100037)
    player.equipment_component.add_exist_equipment(equipment)
    equipment.base_info.base_name = 'e6'
    equipment.attribute.strengthen_lv = 0
    equipment.attribute.awakening_lv = 20
    equipment.attribute.nobbing_effect = 9
    equipment.save_data()
