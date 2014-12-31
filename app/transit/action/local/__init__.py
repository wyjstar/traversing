# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import message
import pvp_award
from gtwisted.core import reactor


reactor.callLater(60*6, pvp_award.pvp_award_tick)
