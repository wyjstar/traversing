# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午5:29.
"""

from shared.db_opear.configs_data import game_configs


def init_travel_item(player):
    travel_item = {}
    for (item_id, conf) in game_configs.travel_item_config.get('items').items():
        stage_id = conf.get('stageId')
        if travel_item.get(stage_id):
            travel_item.get(stage_id).append([item_id, 1])
        else:
            travel_item[stage_id] = [[item_id, 1]]

    player.travel_component.travel_item = travel_item
    player.travel_component.save()
