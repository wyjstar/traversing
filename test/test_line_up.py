# -*- coding:utf-8 -*-
"""
created by server on 14-11-5下午1:20.
"""




def get_line_up_panel(player):
    fight_cache_component = player.fight_cache_component
    fight_cache_component.stage_id = 100201

    red_units, blue_units, drop_num, monster_unpara, replace_units, replace_no = fight_cache_component.fighting_start()
    for unit in red_units:
        if unit:
            print unit.info