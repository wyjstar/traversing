# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import message
from pvp_award import do_pvp_daily_award_tick
# from gtwisted.core import reactor
from shared.time_event_manager.te_manager import te_manager
from shared.db_opear.configs_data import game_configs


award_time = game_configs.base_config.get('arena_day_points_time').split(':')
# pvp_award.pvp_daily_award_tick()
the_time = int(award_time[0])*60*60 + int(award_time[1])*60 + int(award_time[2])
te_manager.add_event(the_time, 2, do_pvp_daily_award_tick)
te_manager.deal_event()
