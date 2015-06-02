# -*- coding:utf-8 -*-
"""
created by server on 14-11-9下午5:11.
"""
import action

from shared.utils.ranking import Ranking
import time
from gtwisted.core import reactor
from app.world.core.rank_helper import tick_rank, do_tick_rank
from app.world.core.limit_hero import tick_limit_hero, limit_hero_obj


# 初始化工会排行
Ranking.init('LevelRank1', 99999)
Ranking.init('LevelRank2', 99999)
Ranking.init('PowerRank1', 99999)
Ranking.init('PowerRank2', 99999)
Ranking.init('StarRank1', 99999)
Ranking.init('StarRank2', 99999)
Ranking.init('LimitHeroRank', 99999)


now = int(time.time())
t = time.localtime(now)
time1 = time.mktime(time.strptime(time.strftime('%Y-%m-%d 00:00:00', t),
                    '%Y-%m-%d %H:%M:%S'))
need_time = 24*60*60 - (now - time1) + 2
do_tick_rank()
reactor.callLater(need_time, tick_rank)


tick_limit_hero()
