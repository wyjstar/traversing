# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午5:29.
"""

from shared.db_opear.configs_data.game_configs import travel_item_config


def init_travel_item(player):
    travel_item = {}
    for conf in travel_item_config.get('items'):
        stage_id = conf.stageId
        if travel_item.get(stage_id):
            travel_item.get(stage_id).append([conf.id, 1])
        else:
            travel_item[stage_id] = [conf.id, 1]

    player.travel_component.travel_item = travel_item
    player.travel_component.save()
