# -*- coding:utf-8 -*-
"""
created by server on 14-8-20下午6:02.
"""
#import test.unittest.init_data.init_connection
from test.init_data.mock_heros import init_hero
from test.init_data.mock_hero_chips import init_hero_chip
from test.init_data.mock_equipment import init_equipment
from test.init_data.mock_equipment_chip import init_equipment_chip
from test.init_data.mock_item import init_item
from test.init_data.mock_line_up import init_line_up
from test.init_data.mock_runt import init_runt
from test.init_data.mock_guild import init_guild
from test.init_data.mock_travel_item import init_travel_item
from test.init_data.mock_player import init_player
from shared.db_opear.configs_data import game_configs


def init(player):
    init_player(player)
    init_hero(player)
    init_hero_chip(player)
    init_equipment(player)
    init_equipment_chip(player)
    init_item(player)
    init_line_up(player)
    init_runt(player)
    # init_guild(player)
    init_travel_item(player)
    change_stage(101601, player)


def change_stage(stage_id, player):
    """docstring for change_stage"""
    #stage_id = int(args['attr_value'])
    #attr_value = int(args['attr_value'])
    attr_value = stage_id
    stage_info = game_configs.stage_config.get('stages').get(stage_id)
    if not stage_info:
        return {'success': 0, 'message': 4}

    first_stage_id = game_configs.stage_config.get('first_stage_id')
    next_stages = game_configs.stage_config.get('condition_mapping')

    stage_id_a = stage_id
    while True:
        if not next_stages.get(stage_id_a):
            break
        for stage in [player.stage_component.get_stage(stage_id_1) for stage_id_1 in next_stages.get(stage_id_a)]:
            stage.state = -2
        for stage_id_1 in next_stages.get(stage_id_a):
            if game_configs.stage_config.get('stages').get(stage_id_1)['type'] == 1:
                stage_id_a = stage_id_1
                break
        else:
            break

    while True:
        the_last_stage_id = game_configs.stage_config.get('stages').get(stage_id)['condition']
        player.stage_component.get_stage(stage_id).state = 1

        if next_stages.get(the_last_stage_id):
            for stage in [player.stage_component.get_stage(stage_id_1) for stage_id_1 in next_stages.get(the_last_stage_id)]:
                if stage_id != stage.stage_id:
                    stage.state = -1

        if stage_id == first_stage_id:
            break
        else:
            stage_id = the_last_stage_id

    player.stage_component.get_stage(attr_value).state = -1
    if game_configs.stage_config.get('stages').get(attr_value)['section'] == 1:
        player.stage_component.plot_chapter = game_configs.stage_config.get('stages').get(attr_value)['chapter']
    else:
        player.stage_component.plot_chapter = game_configs.stage_config.get('stages').get(attr_value)['chapter'] + 1
    player.stage_component.stage_progress = attr_value
    player.stage_component.save_data()
