# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午8:30.
"""


def init():
    """reinit all data , every test case """
    import test.unittest.init_data.mock_config
    from test.unittest.init_data.mock_redis import init_redis
    init_redis()
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

