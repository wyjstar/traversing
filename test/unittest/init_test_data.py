# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午8:30.
"""
import shared.db_opear.configs_data.game_configs

def init():
    """reinit all data , every test case """

    from test.unittest.init_data.mock_player import init_player
    init_player()
    from test.unittest.init_data.mock_heros import init_hero
    init_hero()
    from test.unittest.init_data.mock_item import init_item
    init_item()
    from test.unittest.init_data.mock_hero_chips import init_hero_chip
    init_hero_chip()
    from test.unittest.init_data.mock_equipment import init_equipment
    init_equipment()
    from test.unittest.init_data.mock_equipment_chip import init_equipment_chip
    init_equipment_chip()
    from test.unittest.init_data.mock_line_up import init_line_up
    #init_line_up()
    from test.unittest.init_data.mock_mails import init_mail
    #init_mail()

