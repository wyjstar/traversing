# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import message
import pvp_award
from gtwisted.core import reactor


reactor.callLater(600, pvp_award.pvp_award_tick)
pvp_award.pvp_daily_award_tick()
