# -*- coding:utf-8 -*-
"""
created by server on 14-8-8上午10:46.
"""

def init_line_up(player):
    # 阵容武将
    player.line_up_component.change_hero(1, 10044, 0)
    player.line_up_component.change_hero(2, 10045, 0)
    player.line_up_component.change_hero(3, 10046, 0)

    # 助威武将
    player.line_up_component.change_hero(1, 10001, 1)
    player.line_up_component.change_hero(2, 10002, 1)
    player.line_up_component.change_hero(3, 10003, 1)
    player.line_up_component.change_hero(4, 10004, 1)
    player.line_up_component.change_hero(5, 10005, 1)
    player.line_up_component.change_hero(6, 10006, 1)

    # 装备
    for equipment in player.equipment_component.get_all():
        id = equipment.base_info.id
        no = equipment.base_info.equipment_no
        if no == 100001: # 烽火之冠
            player.line_up_component.change_equipment(2, 1, id)
            equipment.attribute.strengthen_lv = 10
        if no == 100012: # 烽火护胸
            player.line_up_component.change_equipment(2, 3, id)
            equipment.attribute.strengthen_lv = 10
        if no == 100023: # 烽火长靴
            player.line_up_component.change_equipment(2, 4, id)
            equipment.attribute.strengthen_lv = 20
        if no == 100047: # 青龙刀
            player.line_up_component.change_equipment(2, 2, id)
            equipment.attribute.strengthen_lv = 20
        if no == 100066: # 鲲鹏
            player.line_up_component.change_equipment(2, 5, id)
            equipment.attribute.strengthen_lv = 30
        if no == 100077: # 赤兔
            player.line_up_component.change_equipment(2, 6, id)
            equipment.attribute.strengthen_lv = 30

